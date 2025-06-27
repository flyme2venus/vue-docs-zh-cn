# Windows 构建优化说明

## 🚀 问题解决

### 原问题分析
- `test-build` 工作流耗时过长（跨平台测试）
- `build-sample` 因 WiX 工具包下载失败而构建失败
- MSI 安装包生成不稳定

### 解决方案
1. **移除耗时的多平台测试** - 用快速的前端验证替代
2. **切换到 NSIS 安装包** - 比 WiX 更稳定可靠
3. **添加快速构建选项** - 仅生成可执行文件，跳过安装包
4. **增强错误处理** - 构建失败时仍能上传部分产物

## 📋 新的工作流配置

### 1. 开发构建 (`dev-build.yml`) - 已优化
- ✅ **快速验证**: 仅在 Ubuntu 上做前端构建和类型检查
- ✅ **Windows 构建**: 只在主分支推送时运行
- ✅ **多种构建策略**: 先尝试 NSIS，失败则仅构建可执行文件
- ✅ **智能上传**: 上传所有可用的构建产物

### 2. 快速构建 (`quick-build.yml`) - 新增
- ⚡ **纯可执行文件构建**: 跳过安装包生成，速度最快
- 📦 **便携版打包**: 自动创建便携版 ZIP 包
- 📊 **构建总结**: 在 GitHub Actions 中显示构建结果
- 🔄 **适用场景**: 日常开发测试、快速验证

### 3. Windows 发布构建 (`windows-release.yml`) - 已优化
- 🛠️ **NSIS 安装包**: 替代不稳定的 MSI
- 🔒 **错误容忍**: 安装包失败时仍提供便携版
- 📋 **智能校验**: 根据实际生成的文件计算校验和

## 🎯 使用建议

### 日常开发 - 使用快速构建
```bash
# 本地快速构建（仅可执行文件）
pnpm tauri:build:win-fast

# 或使用构建脚本
./build-windows.sh --fast
```

### 测试验证 - 推送到主分支
- 自动触发 `dev-build.yml`，生成开发版本

### 正式发布 - 创建版本标签
```bash
# 使用发布脚本（推荐）
./scripts/release.sh --patch

# 或手动创建标签
git tag v1.0.0
git push origin v1.0.0
```

## 📦 构建产物说明

### 快速构建 (`quick-build.yml`)
- `vue-docs-zh-cn.exe` - 原始可执行文件
- `vue-docs-portable-{sha}.zip` - 便携版包（含说明文件）

### 开发构建 (`dev-build.yml`)
- `*.exe` - NSIS 安装程序（如果成功）
- `vue-docs-zh-cn.exe` - 可执行文件（总是生成）

### 发布构建 (`windows-release.yml`)
- `Vue Docs_x.x.x_x64_en-US.exe` - NSIS 安装程序
- `vue-docs-portable-windows.zip` - 便携版
- `checksums.txt` - 文件校验和

## 🔧 配置文件更改

### Tauri 配置 (`tauri.conf.json`)
```json
{
  "bundle": {
    "targets": ["nsis", "app"],  // 优先 NSIS，备选纯应用
    "windows": {
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

### 新增 npm 脚本
```json
{
  "tauri:build:win-fast": "tauri build --target x86_64-pc-windows-msvc --no-bundle",
  "tauri:build:win-nsis": "tauri build --target x86_64-pc-windows-msvc --bundles nsis"
}
```

## 🎯 性能对比

### 构建时间估算
- **快速构建**: ~3-5 分钟（仅可执行文件）
- **NSIS 构建**: ~5-8 分钟（含安装程序）
- **完整构建**: ~8-12 分钟（多种格式）

### 之前的问题
- **多平台测试**: 15-20 分钟
- **WiX 构建**: 经常失败，需要 10+ 分钟

## 🚀 立即可用

1. **推送代码到主分支** → 自动触发快速开发构建
2. **创建版本标签** → 自动生成正式发布版本
3. **本地快速测试** → `./build-windows.sh --fast`

所有改进都是向后兼容的，现有的构建流程仍然可用，但新增了更快速和可靠的选项。
