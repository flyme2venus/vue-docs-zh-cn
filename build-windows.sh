#!/bin/bash

# Vue Docs Windows 桌面应用构建脚本

echo "开始构建 Vue Docs Windows 桌面应用..."

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
echo "构建Tauri Windows应用..."
pnpm tauri build --target x86_64-pc-windows-msvc

echo "构建完成！"
echo "安装程序位置: src-tauri/target/x86_64-pc-windows-msvc/release/bundle/"
