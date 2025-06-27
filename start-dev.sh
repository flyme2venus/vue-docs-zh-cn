#!/bin/bash

# Vue Docs 桌面应用开发模式启动脚本

echo "🚀 启动 Vue Docs 桌面应用开发模式..."

# 检查依赖
if ! command -v rustc &> /dev/null; then
    echo "❌ 错误：未找到 Rust。请访问 https://rustup.rs/ 安装。"
    exit 1
fi

if ! command -v pnpm &> /dev/null; then
    echo "❌ 错误：未找到 pnpm。请运行: npm install -g pnpm"
    exit 1
fi

# 安装依赖（如果需要）
if [ ! -d "node_modules" ]; then
    echo "📦 安装依赖..."
    pnpm install
fi

# 启动开发模式
echo "🔥 启动开发模式..."
echo "这将启动 VitePress 开发服务器和 Tauri 应用"
echo "按 Ctrl+C 退出"
echo ""

pnpm tauri:dev
