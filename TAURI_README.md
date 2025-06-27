# Vue.js 中文文档桌面应用

这是Vue.js中文文档的Tauri桌面应用版本，可以在Windows、macOS和Linux上运行。

## 前置要求

### 1. 安装 Rust
访问 [https://rustup.rs/](https://rustup.rs/) 下载并安装Rust工具链。

### 2. 安装 Node.js 和 pnpm
- Node.js >= 18.0.0
- pnpm >= 7.4.0

### 3. Windows 构建要求
如果要构建Windows应用，需要安装：
- Visual Studio Build Tools 或 Visual Studio Community
- Windows SDK

## 开发

### 启动开发模式
```bash
# 安装依赖
pnpm install

# 启动开发模式（会同时启动VitePress和Tauri）
pnpm tauri:dev
```

### 构建应用

#### 构建当前平台
```bash
pnpm tauri:build
```

#### 构建Windows应用（交叉编译）
```bash
# 添加Windows目标（仅需运行一次）
rustup target add x86_64-pc-windows-msvc

# 构建Windows应用
pnpm tauri:build:win
```

#### 使用构建脚本（推荐）
```bash
# 运行Windows构建脚本
chmod +x build-windows.sh
./build-windows.sh
```

## 构建产物

构建完成后，安装程序将位于：
```
src-tauri/target/x86_64-pc-windows-msvc/release/bundle/
```

包含以下文件：
- `.msi` - Windows安装程序
- `.exe` - 可执行文件

## 应用特性

- 🖥️ 原生桌面体验
- 📖 完整的Vue.js中文文档
- 🔍 内置搜索功能
- 📱 响应式设计
- ⚡ 快速启动和导航
- 🌙 支持深色/浅色主题

## 配置

应用配置位于 `src-tauri/tauri.conf.json`，可以修改：
- 窗口大小和位置
- 应用名称和图标
- 权限设置
- 构建选项

## 故障排除

### 构建失败
1. 确保已安装所有前置要求
2. 清理缓存：`pnpm clean && cargo clean`
3. 重新安装依赖：`rm -rf node_modules && pnpm install`

### Windows构建问题
1. 确保安装了Visual Studio Build Tools
2. 确保已添加Windows构建目标：`rustup target add x86_64-pc-windows-msvc`

## 许可证

本项目基于 CC BY-NC-SA 4.0 许可证，与原Vue.js文档保持一致。
