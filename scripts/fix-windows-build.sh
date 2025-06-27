#!/bin/bash

# 修复 Windows 构建问题的脚本

echo "开始修复 Windows 构建问题..."

# 1. 清理 Cargo 缓存
echo "清理 Cargo 缓存..."
cd src-tauri
cargo clean

# 2. 检查 Cargo.toml 配置
echo "检查 Cargo.toml 配置..."
if grep -q "winres" Cargo.toml; then
    echo "⚠️  发现 winres 依赖，建议移除以避免版本资源冲突"
fi

# 3. 检查 build.rs 文件
echo "检查 build.rs 文件..."
if grep -q "WindowsResource" build.rs; then
    echo "⚠️  发现手动设置的 Windows 资源，建议移除以避免与 Tauri 冲突"
fi

# 4. 验证图标文件
echo "验证图标文件..."
if [ ! -f "icons/icon.ico" ]; then
    echo "❌ 缺少 icon.ico 文件"
    exit 1
else
    echo "✅ icon.ico 文件存在"
fi

# 5. 重新构建
echo "重新构建项目..."
cd ..
pnpm install
pnpm build

echo "修复完成！现在可以尝试重新构建 Windows 版本："
echo "pnpm tauri build --target x86_64-pc-windows-msvc"
