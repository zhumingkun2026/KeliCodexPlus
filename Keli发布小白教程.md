# Keli CodexPlus 发布教程（零基础手把手版）

> 你不需要懂命令行、不用装 git。全程用鼠标点。预计 30 分钟（含等 CI 构建的时间）。

## 一、先确认你电脑上已有的东西

你的电脑里已经有 4 个文件夹（别人已经帮你改好代码并提交好了），路径分别是：

- `C:\Users\jolly chu\WorkBuddy\codex++\keli-codexplus` ← 主程序
- `C:\Users\jolly chu\WorkBuddy\codex++\KeliCodexPlus-Ad-List`
- `C:\Users\jolly chu\WorkBuddy\codex++\KeliCodexPlus-Themes`
- `C:\Users\jolly chu\WorkBuddy\codex++\KeliCodexPlusScriptMarket`

你只需要把这些文件夹"上传"到你的 GitHub 账户，再点一下发布，网站就会**自动帮你生成** Windows 安装包（`.exe`）。

你已经有 GitHub 账户：**zhumingkun2026** ✅

---

## 二、安装 GitHub Desktop（一个图形界面工具，免费）

1. 打开浏览器，访问 **https://desktop.github.com**
2. 点页面上的 **Download for Windows**，下载安装程序
3. 双击下载好的安装程序，一路点 **Next / 安装 / Finish**
4. 安装完后打开 **GitHub Desktop**

---

## 三、登录你的 GitHub 账户

1. 第一次打开 GitHub Desktop 会让你登录，点 **Sign in to GitHub.com**
2. 它会弹出浏览器，输入你的账户 **zhumingkun2026** 和密码登录（如果有验证码/两步验证，按提示完成）
3. 登录成功后回到 GitHub Desktop 即可

---

## 四、把 4 个文件夹上传到 GitHub（最重要的一步）

对下面 **4 个文件夹一个一个地**重复操作（建议先从主程序开始）：

1. 顶部菜单点 **File → Add Local Repository…**（或者按键盘 `Ctrl + O`）
2. 点 **Choose…**，在弹出的窗口里找到并选中文件夹，例如 `C:\Users\jolly chu\WorkBuddy\codex++\keli-codexplus`，然后点 **选择文件夹**
3. 点 **Add Repository**
4. 窗口右上角会出现一个蓝色按钮 **Publish repository**（意思是"发布到 GitHub"），点它
5. 在弹出的窗口里填：
   - **Name（仓库名）**：主程序填 `KeliCodexPlus`；其余三个分别填 `KeliCodexPlus-Ad-List`、`KeliCodexPlus-Themes`、`KeliCodexPlusScriptMarket`
   - **Description（描述）**：可留空
   - **⚠️ 一定要取消勾选 "Keep this code private"** —— 必须选 **Public（公开）**。如果设成私有，既违反开源协议，别人也装不了你的程序
   - 点 **Publish repository**
6. 等进度条走完（主程序文件稍多一点，可能要 1–3 分钟；三个小的很快）

> 四个都上传完后，打开 https://github.com/zhumingkun2026 就能看到这 4 个仓库了。

---

## 五、创建 Release（只有这一步才会自动生成安装包！）

1. 浏览器打开 **https://github.com/zhumingkun2026/KeliCodexPlus**
2. 在页面右侧（或靠上位置）找 **Releases** 字样的链接，点进去
3. 点绿色的 **Draft a new release**
4. 在 **Choose a tag** 这个框里，**手动输入 `v1.2.49`**（注意是 1.2.49，不要写成 1.2.48）
5. **Target** 下拉框选 **main**（一般默认就是 main，不用改）
6. **Release title** 填 `Keli CodexPlus 1.2.49`
7. 下面的描述（Describe）可以留空
8. **⚠️ 一定要点绿色的 "Publish release" 按钮**（不要点 Draft 草稿，草稿不会触发构建）
9. 点完后会跳回 Releases 页面，并显示一个构建任务正在运行

---

## 六、等网站自动构建完，下载 exe

1. 在仓库页面顶部点 **Actions** 标签
2. 你会看到一个名为 **Release assets** 的构建任务在跑（它会同时生成 Windows 安装包和 macOS 安装包）
3. 等它变成**绿色对勾**（通常 10–30 分钟；第一次可能更久，耐心等，不要关页面）
4. 回到 **Releases** 页面，刚才发布的 `v1.2.49` 下面会出现几个文件：
   - `KeliCodexPlus-1.2.49-windows-x64-setup.exe` ← **这就是 Windows 安装包，下载它**
   - `KeliCodexPlus-1.2.49-macos-...dmg`（mac 用，可忽略）
   - `latest.json`（自动更新用，不用管）
5. 点 `KeliCodexPlus-1.2.49-windows-x64-setup.exe` 下载到你的电脑

---

## 七、安装 exe

1. 双击下载好的 `KeliCodexPlus-1.2.49-windows-x64-setup.exe`
2. ⚠️ Windows 会弹出 **"Windows 已保护你的电脑 / 未知发布者"** 的 SmartScreen 警告 —— 这是**正常现象**，因为安装包没有花钱做代码签名。点 **"仍要运行"**（有的版本要先点"更多信息"再点"仍要运行"）即可
3. 按提示一路安装，它会自动在桌面和开始菜单建好快捷方式
4. 安装完成后，从桌面或开始菜单打开 **Keli CodexPlus**

---

## 八、常见问题

- **Q：登录或上传失败？** 确认账户名密码正确、电脑能正常打开 github.com；GitHub Desktop 一般会自动处理登录。
- **Q：Publish 时提示"仓库已存在"？** 说明你之前在网页建过同名空仓库。去 github.com 把那个空仓库删掉，再重新点 Publish。
- **Q：不小心设成私有（Private）了？** 进该仓库 → **Settings** → 页面最底部 **Danger Zone** → **Change repository visibility** → 改成 **Public**。
- **Q：exe 下载了但双击没反应？** 多半是被 SmartScreen 拦了，按第七步点"仍要运行"。
- **Q：安装包装好但打不开？** 那是另一个运行环境问题，先把"安装"这步跑通，遇到再问。

---

## 附：进阶方式（可选，不用也完全 OK）

如果你以后想用一条命令搞定上传+发布，可以用之前准备好的 `publish-keli.sh` 脚本（在 Git Bash 里运行）。但对零基础来说，上面用 GitHub Desktop 点界面的方法最简单可靠，推荐先用这个方法。
