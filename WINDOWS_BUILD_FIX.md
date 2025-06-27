# Windows 构建问题修复指南

## 问题描述

在 GitHub Actions 中构建 Windows 平台的 Tauri 应用时出现以下错误：

```
CVTRES : fatal error CVT1100: duplicate resource.  type:VERSION, name:1, language:0x0409
LINK : fatal error LNK1123: failure during conversion to COFF: file invalid or corrupt
```

## 问题原因

这个错误通常由以下原因引起：

1. **重复的版本资源**：`build.rs` 中手动设置的 Windows 资源与 Tauri 自动生成的资源冲突
2. **`winres` 依赖冲突**：同时使用 `winres` 和 Tauri 的内置资源管理
3. **语言资源冲突**：不同的语言设置导致资源重复

## 解决方案

### 1. 修改 `build.rs` 文件

移除手动的 Windows 资源设置，只保留 Tauri 的构建配置：

```rust
fn main() {
    tauri_build::build()
}
```

### 2. 更新 `Cargo.toml`

移除 `winres` 依赖：

```toml
[build-dependencies]
tauri-build = { version = "2.3.0", features = ["isolation", "config-json5"] }

# 移除这部分
# [target.'cfg(windows)'.build-dependencies]
# winres = "0.1"
```

### 3. 检查 `tauri.conf.json`

确保 Windows 配置正确：

```json
{
  "bundle": {
    "windows": {
      "certificateThumbprint": null,
      "digestAlgorithm": "sha256",
      "timestampUrl": "",
      "webviewInstallMode": {
        "type": "downloadBootstrapper"
      },
      "allowDowngrades": false,
      "nsis": {
        "displayLanguageSelector": true,
        "languages": ["SimpChinese", "English"],
        "installerIcon": "icons/icon.ico",
        "installMode": "currentUser"
      }
    }
  }
}
```

### 4. 清理缓存

```bash
# 进入 Tauri 目录
cd src-tauri

# 清理 Cargo 缓存
cargo clean

# 回到项目根目录
cd ..

# 重新安装依赖
pnpm install

# 重新构建前端
pnpm build
```

### 5. 重新构建

```bash
# 构建 Windows 版本
pnpm tauri build --target x86_64-pc-windows-msvc
```

## 验证修复

运行修复脚本来自动检查和修复：

```bash
./scripts/fix-windows-build.sh
```

## 其他建议

### GitHub Actions 优化

在 CI/CD 环境中，可以添加以下步骤来避免问题：

```yaml
- name: Clean Rust cache
  run: |
    cd src-tauri
    cargo clean
    
- name: Build Tauri app with verbose output
  run: |
    pnpm tauri build --target x86_64-pc-windows-msvc --verbose
```

### 调试步骤

如果问题仍然存在，可以尝试：

1. **检查图标文件**：确保 `src-tauri/icons/icon.ico` 文件存在且有效
2. **更新 Tauri 版本**：升级到最新的 Tauri 版本
3. **使用 `--verbose` 标志**：获取更详细的构建日志
4. **检查 Windows SDK**：确保 CI 环境中的 Windows SDK 版本正确

### 常见错误

- **图标文件缺失**：确保所有必需的图标文件都存在
- **权限问题**：在某些情况下，文件权限可能导致构建失败
- **依赖版本冲突**：检查 Tauri 相关依赖的版本兼容性

## 相关链接

- [Tauri 官方文档](https://tauri.app/guides/)
- [Windows 资源文件文档](https://learn.microsoft.com/en-us/windows/win32/menurc/resource-files)
- [Cargo build.rs 文档](https://doc.rust-lang.org/cargo/reference/build-scripts.html)
