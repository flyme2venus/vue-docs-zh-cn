#!/bin/bash

# Vue Docs 桌面应用版本发布脚本

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 函数：显示帮助信息
show_help() {
    echo "Vue Docs 桌面应用版本发布脚本"
    echo ""
    echo "用法: $0 [选项] <版本号>"
    echo ""
    echo "选项:"
    echo "  -h, --help     显示帮助信息"
    echo "  -p, --patch    发布补丁版本 (x.x.X)"
    echo "  -m, --minor    发布次要版本 (x.X.0)"
    echo "  -M, --major    发布主要版本 (X.0.0)"
    echo "  -d, --dry-run  试运行，不实际提交和推送"
    echo ""
    echo "示例:"
    echo "  $0 1.2.3              # 发布指定版本"
    echo "  $0 --patch            # 自动递增补丁版本"
    echo "  $0 --minor            # 自动递增次要版本"
    echo "  $0 --major            # 自动递增主要版本"
    echo "  $0 --dry-run 1.2.3    # 试运行模式"
}

# 函数：获取当前版本
get_current_version() {
    grep '"version"' package.json | head -1 | awk -F'"' '{print $4}'
}

# 函数：递增版本号
increment_version() {
    local version=$1
    local type=$2
    
    IFS='.' read -ra PARTS <<< "$version"
    local major=${PARTS[0]}
    local minor=${PARTS[1]}
    local patch=${PARTS[2]}
    
    case $type in
        patch)
            patch=$((patch + 1))
            ;;
        minor)
            minor=$((minor + 1))
            patch=0
            ;;
        major)
            major=$((major + 1))
            minor=0
            patch=0
            ;;
    esac
    
    echo "$major.$minor.$patch"
}

# 函数：验证版本号格式
validate_version() {
    local version=$1
    if [[ ! $version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo -e "${RED}错误：版本号格式不正确。应为 x.y.z 格式（如 1.2.3）${NC}"
        exit 1
    fi
}

# 函数：更新版本号
update_version() {
    local new_version=$1
    
    echo -e "${BLUE}更新版本号到 $new_version...${NC}"
    
    # 更新 package.json
    sed -i.bak "s/\"version\": \".*\"/\"version\": \"$new_version\"/" package.json
    
    # 更新 Cargo.toml
    sed -i.bak "s/version = \".*\"/version = \"$new_version\"/" src-tauri/Cargo.toml
    
    # 更新 tauri.conf.json
    sed -i.bak "s/\"version\": \".*\"/\"version\": \"$new_version\"/" src-tauri/tauri.conf.json
    
    # 删除备份文件
    rm -f package.json.bak src-tauri/Cargo.toml.bak src-tauri/tauri.conf.json.bak
    
    echo -e "${GREEN}✓ 版本号已更新${NC}"
}

# 函数：创建提交和标签
create_release() {
    local version=$1
    local dry_run=$2
    
    echo -e "${BLUE}创建发布提交和标签...${NC}"
    
    if [ "$dry_run" = true ]; then
        echo -e "${YELLOW}[试运行] 将执行以下操作：${NC}"
        echo "  git add package.json src-tauri/Cargo.toml src-tauri/tauri.conf.json"
        echo "  git commit -m \"chore: release v$version\""
        echo "  git tag v$version"
        echo "  git push origin main"
        echo "  git push origin v$version"
        return
    fi
    
    # 检查是否有未提交的更改
    if [ -n "$(git status --porcelain)" ]; then
        echo -e "${YELLOW}发现未提交的更改，将包含在此次发布中${NC}"
    fi
    
    # 添加文件到暂存区
    git add package.json src-tauri/Cargo.toml src-tauri/tauri.conf.json
    
    # 创建提交
    git commit -m "chore: release v$version"
    
    # 创建标签
    git tag "v$version"
    
    # 推送到远程仓库
    echo -e "${BLUE}推送到远程仓库...${NC}"
    git push origin main
    git push origin "v$version"
    
    echo -e "${GREEN}✓ 发布完成！${NC}"
    echo -e "${GREEN}GitHub Actions 将自动开始构建 Windows 桌面应用${NC}"
    echo -e "${BLUE}访问 https://github.com/$(git config --get remote.origin.url | sed 's/.*://; s/.git$//')/actions 查看构建状态${NC}"
}

# 解析命令行参数
dry_run=false
version_type=""
custom_version=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -p|--patch)
            version_type="patch"
            shift
            ;;
        -m|--minor)
            version_type="minor"
            shift
            ;;
        -M|--major)
            version_type="major"
            shift
            ;;
        -d|--dry-run)
            dry_run=true
            shift
            ;;
        -*)
            echo -e "${RED}未知选项: $1${NC}"
            show_help
            exit 1
            ;;
        *)
            custom_version="$1"
            shift
            ;;
    esac
done

# 检查是否在 git 仓库中
if [ ! -d ".git" ]; then
    echo -e "${RED}错误：当前目录不是 git 仓库${NC}"
    exit 1
fi

# 检查是否有必要的文件
for file in package.json src-tauri/Cargo.toml src-tauri/tauri.conf.json; do
    if [ ! -f "$file" ]; then
        echo -e "${RED}错误：找不到文件 $file${NC}"
        exit 1
    fi
done

# 获取当前版本
current_version=$(get_current_version)
echo -e "${BLUE}当前版本: $current_version${NC}"

# 确定新版本号
if [ -n "$custom_version" ]; then
    validate_version "$custom_version"
    new_version="$custom_version"
elif [ -n "$version_type" ]; then
    new_version=$(increment_version "$current_version" "$version_type")
else
    echo -e "${RED}错误：请指定版本号或版本类型${NC}"
    show_help
    exit 1
fi

echo -e "${GREEN}新版本: $new_version${NC}"

# 确认发布
if [ "$dry_run" != true ]; then
    echo -e "${YELLOW}确定要发布版本 $new_version 吗？ (y/N)${NC}"
    read -r confirm
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}发布已取消${NC}"
        exit 0
    fi
fi

# 更新版本号
update_version "$new_version"

# 创建发布
create_release "$new_version" "$dry_run"

if [ "$dry_run" != true ]; then
    echo -e "${GREEN}🎉 版本 $new_version 发布成功！${NC}"
    echo -e "${BLUE}接下来的步骤：${NC}"
    echo "1. 等待 GitHub Actions 完成构建"
    echo "2. 查看生成的 Release"
    echo "3. 下载并测试 Windows 安装包"
    echo "4. 编辑 Release 说明并发布"
fi
