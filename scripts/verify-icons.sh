#!/bin/bash

# Vue 图标验证脚本

echo "🎨 Vue.js 图标验证报告"
echo "=========================="

# 检查源图标
if [ -f "src/public/logo.svg" ]; then
    echo "✅ 源文件: src/public/logo.svg"
    echo "   大小: $(du -h src/public/logo.svg | cut -f1)"
else
    echo "❌ 源文件: src/public/logo.svg 不存在"
fi

echo ""
echo "📁 生成的图标文件:"
echo "-------------------"

# 检查所有图标文件
icons=(
    "src-tauri/icons/32x32.png"
    "src-tauri/icons/64x64.png" 
    "src-tauri/icons/128x128.png"
    "src-tauri/icons/128x128@2x.png"
    "src-tauri/icons/icon.ico"
    "src-tauri/icons/icon.icns"
    "src-tauri/icons/icon.png"
)

for icon in "${icons[@]}"; do
    if [ -f "$icon" ]; then
        size=$(du -h "$icon" | cut -f1)
        echo "✅ $(basename "$icon") - $size"
    else
        echo "❌ $(basename "$icon") - 缺失"
    fi
done

echo ""
echo "🔧 Tauri 配置状态:"
echo "------------------"

# 检查 tauri.conf.json 中的图标配置
if grep -q "icons/32x32.png" src-tauri/tauri.conf.json; then
    echo "✅ 32x32.png 已配置"
else
    echo "❌ 32x32.png 未配置"
fi

if grep -q "icons/64x64.png" src-tauri/tauri.conf.json; then
    echo "✅ 64x64.png 已配置"
else
    echo "❌ 64x64.png 未配置"
fi

if grep -q "icons/icon.ico" src-tauri/tauri.conf.json; then
    echo "✅ icon.ico 已配置"
else
    echo "❌ icon.ico 未配置"
fi

echo ""
echo "📋 下一步操作:"
echo "--------------"
echo "1. 运行构建命令:"
echo "   pnpm tauri:build:win-fast"
echo ""
echo "2. 或推送代码触发自动构建:"
echo "   git add . && git commit -m 'update: Vue logo icons'"
echo "   git push"
echo ""
echo "3. 生成的应用将显示 Vue.js 绿色图标 🎉"
