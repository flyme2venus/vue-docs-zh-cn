# GitHub Actions CI/CD 配置说明

本项目配置了完整的 GitHub Actions 工作流，用于自动构建 Vue.js 中文文档的桌面应用。

## 🔄 工作流说明

### 1. 开发构建 (`dev-build.yml`)
**触发条件：**
- 推送到 `main`、`master`、`develop` 分支
- 对主要文件的 Pull Request

**功能：**
- 跨平台测试构建（Ubuntu、Windows、macOS）
- TypeScript 类型检查
- Markdown 代码检查
- 生成开发版本的 Windows 应用（仅主分支）

### 2. Windows 发布构建 (`windows-release.yml`)
**触发条件：**
- 推送标签（如 `v1.0.0`）
- 手动触发

**功能：**
- 构建生产级 Windows 安装程序
- 生成便携版可执行文件
- 创建 GitHub Release
- 计算文件校验和
- 长期保存构建产物（90天）

### 3. 多平台构建 (`build-multiplatform.yml`)
**触发条件：**
- 推送到主分支
- 推送标签
- Pull Request

**功能：**
- 同时构建 Windows、macOS、Linux 版本
- 支持 Apple Silicon (M1) 和 Intel Mac
- 自动发布到 GitHub Releases

### 4. 单独 Windows 构建 (`build-windows.yml`)
**触发条件：**
- 推送到主分支
- 推送标签
- Pull Request

**功能：**
- 专门针对 Windows 的快速构建
- 上传构建产物

## 🚀 使用方法

### 自动构建
1. **开发测试**：推送代码到任何主要分支即可触发测试构建
2. **发布版本**：创建版本标签触发正式构建

```bash
# 创建并推送版本标签
git tag v1.0.0
git push origin v1.0.0
```

### 手动构建
1. 访问 GitHub 项目的 Actions 页面
2. 选择 "Windows Release Build" 工作流
3. 点击 "Run workflow"
4. 输入版本号（如 `v1.0.0`）
5. 点击 "Run workflow" 按钮

## 📦 构建产物

### 自动上传的文件
- **Windows 安装程序** (`.msi`)
- **便携版可执行文件** (`.exe`)
- **校验和文件** (`checksums.txt`)

### 下载位置
1. **GitHub Releases**：正式发布版本
2. **Actions Artifacts**：开发版本和测试构建

## ⚙️ 环境变量和密钥

### 必需的密钥
- `GITHUB_TOKEN`：自动提供，用于创建 Release

### 可选的密钥（代码签名）
如需对 Windows 应用进行代码签名，添加以下密钥：
- `TAURI_SIGNING_PRIVATE_KEY`：签名私钥
- `TAURI_SIGNING_PRIVATE_KEY_PASSWORD`：私钥密码

### 添加密钥步骤
1. 访问 GitHub 项目设置页面
2. 进入 "Secrets and variables" > "Actions"
3. 点击 "New repository secret"
4. 添加相应的密钥

## 🔧 自定义配置

### 修改构建目标
编辑工作流文件中的 `args` 参数：
```yaml
args: --target x86_64-pc-windows-msvc  # Windows 64位
args: --target i686-pc-windows-msvc    # Windows 32位
```

### 修改Node.js版本
在工作流文件中找到：
```yaml
- name: Setup Node.js
  uses: actions/setup-node@v4
  with:
    node-version: '18'  # 修改为所需版本
```

### 修改发布信息
编辑 `windows-release.yml` 中的 `releaseBody` 部分自定义发布说明。

## 📊 构建状态

### 查看构建状态
- 访问项目的 Actions 页面查看所有工作流状态
- 每个 commit 和 PR 都会显示构建状态徽章

### 构建失败处理
1. 查看失败的工作流详细日志
2. 检查错误信息和失败步骤
3. 修复问题后重新推送代码或重新运行工作流

## 🎯 最佳实践

### 版本发布流程
1. 在本地完成开发和测试
2. 更新版本号（`package.json` 和 `src-tauri/Cargo.toml`）
3. 创建版本标签并推送
4. GitHub Actions 自动构建并创建 Release
5. 下载并测试生成的安装包
6. 编辑 Release 说明并发布

### 开发流程
1. 功能开发在特性分支进行
2. 创建 PR 时会自动运行测试构建
3. 合并到主分支后生成开发版本
4. 定期创建正式版本发布

这个 CI/CD 配置确保了每次代码变更都能自动测试和构建，并且可以轻松发布新版本的桌面应用。
