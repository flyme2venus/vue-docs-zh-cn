# Vuejs.org 新版中文文档

这里是焕然一新的 [cn.vuejs.org](https://cn.vuejs.org)。

你也可以预览对应的英文原文文档 [https://vuejs.org](https://vuejs.org) 及其代码仓库 [vuejs/docs](https://github.com/vuejs/docs)。

## 如何参与贡献

本仓库是[英文文档仓库](https://github.com/vuejs/docs)的镜像翻译仓库。我们仅对原文进行内容同步与翻译，**不包含**基于英文原版的扩展、删减或演绎等。如对原文有任何意见或建议，欢迎到[英文文档仓库](https://github.com/vuejs/docs)提出 issue 或发起 PR。

有劳访问我们的 [wiki](https://github.com/vuejs-translations/docs-zh-cn/wiki) 了解相关注意事项。

目前网站处于维护状态，我们会定期同步英文版的更新，包括文档内容和前端代码等。欢迎大家：

- 同步英文站点最新的改动到这里
- 修复错别字或错误的书写格式
- 发 issue 讨论译法或书写格式
- 发 issue 讨论部署或协作流程上的问题

同时我们的文档中可能会偶尔存在暂时未翻译的段落，这些段落通常都以 `<!-- TODO: translation -->` 开头作为标记。所以也欢迎大家在源码中搜索这些段落并贡献翻译。你也可以通过[这个链接](https://github.com/vuejs-translations/docs-zh-cn/search?q=TODO%3A+translation)快速找到尚未翻译好的内容。

## 如何在本地编辑和预览该网站

建议使用 [pnpm](https://pnpm.io/) 作为本地开发的包管理器：

```bash
pnpm i
pnpm run dev
```

该项目要求 Node.js 为 `v18` 或更高版本。并且建议启用 corepack：

```bash
corepack enable
```

## 贡献者列表

最新的文档/翻译贡献情况可以参阅 GitHub 提供的 [contributors](https://github.com/vuejs-translations/docs-zh-cn/graphs/contributors) 页面。

以下是基于该仓库中 PR 和 commit 统计并按总数量排序的所有贡献者，[生成逻辑可在此查阅](https://github.com/ShenQingchuan/github-contributor-svg-generator)。

<p align="center">
  <a href="https://cdn.jsdelivr.net/gh/ShenQingchuan/github-contributor-svg-generator@main/.github-contributors/vuejs-translations_docs-zh-cn.svg">
    <img src="https://cdn.jsdelivr.net/gh/ShenQingchuan/github-contributor-svg-generator@main/.github-contributors/vuejs-translations_docs-zh-cn.svg" />
  </a>
</p>

## 版权声明

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="知识共享许可协议" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />本作品采用<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">知识共享署名-非商业性使用-相同方式共享 4.0 国际许可协议  (CC BY-NC-SA 4.0) </a>进行许可。

# Vue.js 中文文档

[![Development Build](https://github.com/vuejs-translations/docs-zh-cn/actions/workflows/dev-build.yml/badge.svg)](https://github.com/vuejs-translations/docs-zh-cn/actions/workflows/dev-build.yml)
[![Windows Release](https://github.com/vuejs-translations/docs-zh-cn/actions/workflows/windows-release.yml/badge.svg)](https://github.com/vuejs-translations/docs-zh-cn/actions/workflows/windows-release.yml)
[![Multi-platform Build](https://github.com/vuejs-translations/docs-zh-cn/actions/workflows/build-multiplatform.yml/badge.svg)](https://github.com/vuejs-translations/docs-zh-cn/actions/workflows/build-multiplatform.yml)

## 🖥️ 桌面应用

本项目现已支持构建为跨平台桌面应用！使用 [Tauri](https://tauri.app/) 技术栈，提供原生的桌面体验。

### 下载桌面应用

- **Windows**: 访问 [Releases](https://github.com/vuejs-translations/docs-zh-cn/releases) 页面下载 `.msi` 安装程序
- **macOS**: 下载 `.dmg` 文件
- **Linux**: 下载 `.deb` 或 `.AppImage` 文件

### 桌面应用特性

- 🖥️ 原生桌面体验
- 📖 完整的Vue.js中文文档离线访问
- 🔍 强大的内置搜索功能
- 📱 响应式设计，适配不同屏幕尺寸
- ⚡ 快速启动和流畅导航
- 🌙 支持深色/浅色主题切换

### 本地构建

```bash
# 安装依赖
pnpm install

# 开发模式
pnpm tauri:dev

# 构建应用
pnpm tauri:build

# 构建 Windows 版本
pnpm tauri:build:win
```

详细说明请参阅 [TAURI_SETUP.md](./TAURI_SETUP.md)。

---
