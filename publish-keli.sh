#!/usr/bin/env bash
# ============================================================
#  Keli CodexPlus 一键发布脚本 (在 Git Bash 中运行，非 cmd)
#  用途：提交并推送主仓库 + 三个配套仓库，并创建已发布的
#        GitHub Release —— 后者会触发 CI 自动构建
#        Windows 安装包 (KeliCodexPlus-*-windows-x64-setup.exe)
#        与 macOS DMG。
#  版本号自动从 Cargo.toml [workspace.package] 读取。
# ============================================================
set -e

# ---------- 配置 ----------
GITHUB_USER="zhumingkun2026"
BASE="C:/Users/jolly chu/WorkBuddy/codex++"

MAIN_REPO="$BASE/keli-codexplus"
AD_REPO="$BASE/KeliCodexPlus-Ad-List"
THEME_REPO="$BASE/KeliCodexPlus-Themes"
SCRIPT_REPO="$BASE/KeliCodexPlusScriptMarket"

# 自动读取版本号（来自 Cargo.toml 的 [workspace.package] version）
CARGO_VER="$(grep -m1 '^version' "$MAIN_REPO/Cargo.toml" 2>/dev/null | sed -E 's/.*"([^"]+)".*/\1/')"
if [ -n "$CARGO_VER" ]; then
  VERSION="v$CARGO_VER"
else
  VERSION="v1.2.49"
  echo "!! 未能从 Cargo.toml 读取版本，回退到 $VERSION"
fi

# 生成更新日志（优先 git 本次改动，其次 CHANGELOG.md 最近段落）
gen_changelog() {
  local log=""
  if git -C "$MAIN_REPO" rev-parse --git-dir >/dev/null 2>&1; then
    local prev
    prev="$(git -C "$MAIN_REPO" describe --tags --abbrev=0 2>/dev/null || true)"
    if [ -n "$prev" ] && [ "$prev" != "$VERSION" ]; then
      log="$(git -C "$MAIN_REPO" log --oneline "${prev}..HEAD" 2>/dev/null)"
    fi
    [ -z "$log" ] && log="$(git -C "$MAIN_REPO" log --oneline -10 2>/dev/null)"
  fi
  if [ -z "$log" ] && [ -f "$MAIN_REPO/CHANGELOG.md" ]; then
    log="$(awk '/^## /{if(p)exit; p=1} p' "$MAIN_REPO/CHANGELOG.md" | sed '1d')"
  fi
  [ -z "$log" ] && log="— 首次 Keli CodexPlus 发布（基于上游 BigPizzaV3/CodexPlusPlus 更名）"
  echo "$log"
}

echo "=================================================="
echo " Keli CodexPlus 发布脚本"
echo " GitHub 用户 : $GITHUB_USER"
echo " 版本 (tag)  : $VERSION  (自动读取自 Cargo.toml)"
echo "=================================================="
echo "发布前请确认已满足以下前提："
echo "  [1] 已在 GitHub 网页建好 4 个 PUBLIC 仓库："
echo "        $GITHUB_USER/KeliCodexPlus"
echo "        $GITHUB_USER/KeliCodexPlus-Ad-List"
echo "        $GITHUB_USER/KeliCodexPlus-Themes"
echo "        $GITHUB_USER/KeliCodexPlusScriptMarket"
echo "  [2] 本机 git 已能推送 GitHub（凭证管理器 / SSH key / GitHub Desktop 登录）"
echo "  [3] 已安装并登录 gh CLI：gh auth login  (用于自动创建 Release)"
echo "=================================================="
read -p "确认以上已就绪并继续执行? [y/N] " CONFIRM
if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "Y" ]; then
  echo "已取消。"
  exit 1
fi

# ---------- 主仓库：提交 + 推送 ----------
echo
echo ">>> [1/4] 处理主仓库 keli-codexplus ..."
cd "$MAIN_REPO"
git add -A
echo "--- 待提交改动预览 ---"
git status --short
git commit -m "rebrand: rename display name to Keli CodexPlus + repoint external links to $GITHUB_USER" \
  || echo "(无新改动可提交，继续)"

git remote get-url origin >/dev/null 2>&1 || git remote add origin "https://github.com/$GITHUB_USER/KeliCodexPlus"
git remote set-url origin "https://github.com/$GITHUB_USER/KeliCodexPlus"
git push -u origin main

# ---------- tag：冲突保护（重要）----------
# 若 tag 已存在（很可能来自上游 fork），直接复用会让 CI checkout 旧代码，
# 导致改名/替换不生效。必须在此确认。
if git rev-parse "$VERSION" >/dev/null 2>&1; then
  echo
  echo "!!! 警告：本地已存在 tag $VERSION（很可能来自上游 fork）。"
  echo "    直接复用会让 CI 拉取上游旧代码，本次改名结果不会进入安装包！"
  echo "    请选择：(a) 输入一个新版本号（推荐，如 v1.2.49 / v1.0.0-keli）"
  echo "            (b) 输入 'force' 把 $VERSION 强制移动到当前改名后的 commit"
  read -p "请输入新版本号 或 'force': " CHOICE
  if [ "$CHOICE" = "force" ]; then
    git tag -f "$VERSION" -m "Keli CodexPlus $VERSION"
  else
    VERSION="$CHOICE"
    git tag -a "$VERSION" -m "Keli CodexPlus $VERSION"
  fi
else
  git tag -a "$VERSION" -m "Keli CodexPlus $VERSION"
fi
git push origin "$VERSION" 2>/dev/null || true

# ---------- 三个配套仓库 ----------
for pair in "$AD_REPO:KeliCodexPlus-Ad-List" "$THEME_REPO:KeliCodexPlus-Themes" "$SCRIPT_REPO:KeliCodexPlusScriptMarket"; do
  path="${pair%%:*}"; name="${pair##*:}"
  echo
  echo ">>> 处理配套仓库: $name ..."
  cd "$path"
  git add -A
  git commit -m "init: Keli CodexPlus companion repo" || echo "(无新改动)"
  git remote get-url origin >/dev/null 2>&1 || git remote add origin "https://github.com/$GITHUB_USER/$name"
  git remote set-url origin "https://github.com/$GITHUB_USER/$name"
  git push -u origin main
done

# ---------- 创建已发布的 Release（触发 CI）----------
echo
echo ">>> 创建 GitHub Release（Published 状态会触发 CI 构建 exe/dmg）..."
cd "$MAIN_REPO"
CHANGELOG="$(gen_changelog)"
NOTES="$(cat <<EOF
# Keli CodexPlus $VERSION 发布说明

Keli CodexPlus 是基于上游 BigPizzaV3/CodexPlusPlus（AGPL-3.0）派生的 Codex 管理工具。本版本完成产品更名与功能外链重定向。

## 本次更新
$CHANGELOG

## 下载与安装
- Windows：下载 \`KeliCodexPlus-${VERSION#v}-windows-x64-setup.exe\`，双击安装。
- macOS：下载对应架构的 \`.dmg\` 安装包。

> 提示：本安装包未做代码签名，Windows 首次运行可能弹出 SmartScreen「未知发布者」警告，点击「仍要运行」即可，不影响使用。

## 开源与合规
本软件基于 AGPL-3.0 开源，源代码随公开仓库分发。Keli CodexPlus 为第三方工具，与 OpenAI 无隶属或背书关系。
EOF
)"
if command -v gh >/dev/null 2>&1; then
  gh release create "$VERSION" \
    --repo "$GITHUB_USER/KeliCodexPlus" \
    --title "Keli CodexPlus $VERSION" \
    --notes "$NOTES" \
    || echo "(Release 可能已存在，请到 GitHub 网页确认)"
  echo "Release 已创建/存在。"
else
  echo "!!! 未检测到 gh CLI，请改用 GitHub 网页手动发布："
  echo "    打开 https://github.com/$GITHUB_USER/KeliCodexPlus/releases/new"
  echo "    Choose a tag = $VERSION，填标题，点 [Publish release]。"
  echo "    发布后 CI 会自动运行并上传安装包到该 release。"
fi

echo
echo "=================================================="
echo " 推送完成。接下来："
echo "  1) 打开 https://github.com/$GITHUB_USER/KeliCodexPlus/actions"
echo "     查看 'Release assets' 工作流，等 windows-installer / macos-dmg 跑完。"
echo "  2) 完成后到 Releases 页面下载："
echo "       KeliCodexPlus-${VERSION#v}-windows-x64-setup.exe  (Windows 安装包)"
echo "       KeliCodexPlus-${VERSION#v}-macos-*.dmg            (macOS 安装包)"
echo "  3) 首次安装 Windows 版会弹 SmartScreen '未知发布者' 警告，"
echo "     点 '仍要运行' 即可（本仓库未做代码签名，非错误）。"
echo "=================================================="
