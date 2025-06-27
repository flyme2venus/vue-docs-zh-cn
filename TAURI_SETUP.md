# Vue Docs Tauri 桌面应用构建指南

## 概述

这个项目已经配置为使用Tauri将Vue.js中文文档转换为桌面应用。你可以在Windows、macOS和Linux上构建和运行这个应用。

## ✅ 已完成的配置

- ✅ 添加了Tauri依赖到package.json
- ✅ 初始化了Tauri配置文件 (`src-tauri/tauri.conf.json`)
- ✅ 配置了构建脚本和命令
- ✅ 优化了窗口设置（1200x800，最小800x600）
- ✅ 设置了正确的VitePress开发服务器端口（5173）
- ✅ 创建了Windows构建脚本 (`build-windows.sh`)

## 🚀 快速开始

### 1. 安装前置要求

#### Rust工具链（必需）
```bash
# 在Linux/macOS上
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env

# 在Windows上
# 下载并运行: https://rustup.rs/
```

#### Linux特定依赖（如果在Linux上构建）
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install libwebkit2gtk-4.1-dev libgtk-3-dev libayatana-appindicator3-dev librsvg2-dev

# Fedora
sudo dnf install webkit2gtk4.1-devel gtk3-devel libayatana-appindicator3-devel librsvg2-devel

# Arch Linux
sudo pacman -S webkit2gtk-4.1 gtk3 libayatana-appindicator librsvg
```

### 2. 开发模式

```bash
# 安装依赖
pnpm install

# 启动开发模式（同时启动VitePress和Tauri）
pnpm tauri:dev
```

这将：
- 启动VitePress开发服务器在 http://localhost:5173
- 启动Tauri应用并加载网页内容
- 支持热重载

### 3. 构建应用

#### 构建当前平台
```bash
pnpm tauri:build
```

#### 专门构建Windows应用
```bash
# 添加Windows构建目标
rustup target add x86_64-pc-windows-msvc

# 构建Windows应用
pnpm tauri:build:win
```

#### 使用自动化构建脚本（推荐）
```bash
chmod +x build-windows.sh
./build-windows.sh
```

## 📦 构建产物

构建完成后，你可以在以下位置找到安装程序：

```
src-tauri/target/[target]/release/bundle/
```

### Windows构建产物
- `*.msi` - Windows安装程序
- `*.exe` - 可执行文件

### macOS构建产物
- `*.dmg` - macOS磁盘映像
- `*.app` - 应用程序包

### Linux构建产物
- `*.deb` - Debian包
- `*.rpm` - Red Hat包（如果配置）
- `*.AppImage` - 便携式应用

## ⚙️ 配置说明

### 应用配置 (`src-tauri/tauri.conf.json`)
- **窗口大小**: 默认1200x800，最小800x600
- **应用名称**: "Vue Docs - 中文文档"
- **标识符**: `org.vuejs.docs.zh-cn`
- **图标**: 位于 `src-tauri/icons/`

### 构建脚本 (`package.json`)
- `tauri:dev` - 开发模式
- `tauri:build` - 构建当前平台
- `tauri:build:win` - 构建Windows版本

## 🛠️ 自定义和扩展

### 修改窗口设置
编辑 `src-tauri/tauri.conf.json` 中的 `app.windows` 部分：

```json
{
  "app": {
    "windows": [
      {
        "title": "自定义标题",
        "width": 1400,
        "height": 900,
        "minWidth": 1000,
        "minHeight": 700
      }
    ]
  }
}
```

### 更换应用图标
替换 `src-tauri/icons/` 目录中的图标文件，或使用：
```bash
pnpm tauri icon /path/to/your/icon.png
```

### 添加原生功能
在 `src-tauri/src/main.rs` 中添加Tauri插件和API。

## 🐛 常见问题

### 构建失败
1. **Rust未安装**: 按照上面的指南安装Rust
2. **Linux依赖缺失**: 安装webkit2gtk和相关开发包
3. **Windows工具链**: 确保安装了Visual Studio Build Tools

### 开发模式启动失败
1. **端口冲突**: 确保5173端口未被占用
2. **VitePress构建失败**: 运行 `pnpm build` 检查错误

### 清理和重置
```bash
# 清理前端构建
pnpm clean

# 清理Rust构建
cd src-tauri && cargo clean

# 重新安装依赖
rm -rf node_modules && pnpm install
```

## 📝 许可证

本项目遵循 CC BY-NC-SA 4.0 许可证，与原Vue.js文档保持一致。

## 🤝 贡献

欢迎提交Issue和Pull Request来改进这个桌面应用！
