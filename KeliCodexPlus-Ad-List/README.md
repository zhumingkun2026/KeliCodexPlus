# Keli CodexPlus-Ad-List

Keli CodexPlus 的**远程广告 / 推荐**数据源。App 在 `crates/codex-plus-core/src/ads.rs` 中通过以下两个地址拉取本文件：

- `https://raw.githubusercontent.com/zhumingkun2026/KeliCodexPlus-Ad-List/main/ads.json`
- `https://cdn.jsdelivr.net/gh/zhumingkun2026/KeliCodexPlus-Ad-List@main/ads.json`（jsDelivr 加速镜像）

## 文件格式（`ads.json`）

```json
{
  "version": 1,
  "ads": [
    {
      "id": "唯一ID(小写字母数字-_)",
      "type": "sponsor | normal",
      "title": "标题（必填，非空）",
      "description": "描述（必填，非空）",
      "url": "https://...（必填，非空）",
      "image": "可选，data: URI 或远程图片地址",
      "highlights": ["可选标签"],
      "expires_at": "可选，ISO8601，过期后不再展示"
    }
  ]
}
```

- `type` 必须是 `sponsor` 或 `normal`，否则会被过滤。
- 不提供远程 `image` 的广告会以纯文本卡片展示。
- App 内置了一批赞助商，会**自动追加**到列表末尾，无需在此重复配置。

## 维护
直接编辑 `ads.json` 后提交到 `main` 分支即可；jsDelivr 镜像可能有数分钟缓存。

## License
MIT License

Copyright (c) 2026 Keli

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

