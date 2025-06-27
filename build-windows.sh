#!/bin/bash

# Vue Docs Windows 桌面应用构建脚本

echo "开始构建 Vue Docs Windows 桌面应用..."

# 解析命令行参数
FAST_BUILD=false
BUNDLE_TYPE="nsis"

while [[ $# -gt 0 ]]; do
    case $1 in
        --fast|-f)
            FAST_BUILD=true
            shift
            ;;
        --no-bundle|-n)
            BUNDLE_TYPE="none"
            shift
            ;;
        --msi|-m)
            BUNDLE_TYPE="msi"
            shift
            ;;
        --help|-h)
            echo "用法: $0 [选项]"
            echo "选项:"
            echo "  --fast, -f      快速构建（仅生成exe文件）"
            echo "  --no-bundle, -n 不生成安装包"
            echo "  --msi, -m       生成MSI安装包（默认NSIS）"
            echo "  --help, -h      显示帮助信息"
            exit 0
            ;;
        *)
            echo "未知选项: $1"
            echo "使用 --help 查看帮助"
            exit 1
            ;;
    esac
done

# 检查Rust是否安装
if ! command -v rustc &> /dev/null; then
    echo "错误：需要安装 Rust。请访问 https://rustup.rs/ 下载安装。"
    exit 1
fi

# 检查是否有Windows目标
if ! rustup target list --installed | grep -q "x86_64-pc-windows-msvc"; then
    echo "添加 Windows 构建目标..."
    rustup target add x86_64-pc-windows-msvc
fi

# 安装依赖
echo "安装依赖..."
pnpm install

# 构建前端资源
echo "构建前端资源..."
pnpm build

# 构建Tauri应用
if [ "$FAST_BUILD" = true ] || [ "$BUNDLE_TYPE" = "none" ]; then
    echo "快速构建Tauri应用（仅可执行文件）..."
    pnpm tauri:build:win-fast
    echo "构建完成！"
    echo "可执行文件位置: src-tauri/target/x86_64-pc-windows-msvc/release/vue-docs-zh-cn.exe"
elif [ "$BUNDLE_TYPE" = "msi" ]; then
    echo "构建Tauri Windows应用（MSI安装包）..."
    pnpm tauri build --target x86_64-pc-windows-msvc --bundles msi
    echo "构建完成！"
    echo "安装程序位置: src-tauri/target/x86_64-pc-windows-msvc/release/bundle/msi/"
else
    echo "构建Tauri Windows应用（NSIS安装包）..."
    pnpm tauri:build:win-nsis
    echo "构建完成！"
    echo "安装程序位置: src-tauri/target/x86_64-pc-windows-msvc/release/bundle/nsis/"
fi
