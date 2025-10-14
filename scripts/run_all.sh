#!/bin/bash

# Flutter Workspace 批量执行脚本
# 自动从 pubspec.yaml 读取 workspace 配置并对所有模块执行命令
# 使用方法: ./scripts/run_all.sh <command>
# 例如: ./scripts/run_all.sh "flutter pub get"
#       ./scripts/run_all.sh "flutter gen-l10n"
#       ./scripts/run_all.sh "dart run build_runner build"

set -e  # 遇到错误立即退出

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 检查参数
if [ -z "$1" ]; then
    echo -e "${RED}错误: 请提供要执行的命令${NC}"
    echo "用法: $0 <command>"
    echo "示例: $0 \"flutter pub get\""
    exit 1
fi

COMMAND=$1
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
PUBSPEC_FILE="$PROJECT_ROOT/pubspec.yaml"

# 检查 pubspec.yaml 是否存在
if [ ! -f "$PUBSPEC_FILE" ]; then
    echo -e "${RED}错误: 找不到 pubspec.yaml 文件${NC}"
    exit 1
fi

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Flutter Workspace 批量命令执行${NC}"
echo -e "${BLUE}========================================${NC}"
echo -e "${YELLOW}执行命令: ${COMMAND}${NC}"
echo ""

# 提取 workspace 配置
# 使用 awk 提取 workspace 块中的路径
WORKSPACE_PACKAGES=$(awk '
    /^workspace:/ { in_workspace = 1; next }
    in_workspace && /^[^ ]/ { exit }
    in_workspace && /^  - / { 
        gsub(/^  - /, "");
        gsub(/ *$/, "");
        print 
    }
' "$PUBSPEC_FILE")

# 检查是否找到 workspace 配置
if [ -z "$WORKSPACE_PACKAGES" ]; then
    echo -e "${RED}错误: 未找到 workspace 配置${NC}"
    exit 1
fi

# 首先在根目录执行命令
echo -e "${GREEN}>>> 执行根目录: .${NC}"
cd "$PROJECT_ROOT"
eval $COMMAND
echo ""

# 对每个 workspace 成员执行命令
SUCCESS_COUNT=0
FAIL_COUNT=0
SKIP_COUNT=0

while IFS= read -r package; do
    # 跳过空行
    [ -z "$package" ] && continue
    
    PACKAGE_PATH="$PROJECT_ROOT/$package"
    
    # 检查目录是否存在
    if [ ! -d "$PACKAGE_PATH" ]; then
        echo -e "${YELLOW}⚠ 跳过 $package (目录不存在)${NC}"
        ((SKIP_COUNT++))
        continue
    fi
    
    # 检查是否有 pubspec.yaml
    if [ ! -f "$PACKAGE_PATH/pubspec.yaml" ]; then
        echo -e "${YELLOW}⚠ 跳过 $package (无 pubspec.yaml)${NC}"
        ((SKIP_COUNT++))
        continue
    fi
    
    echo -e "${GREEN}>>> 执行模块: $package${NC}"
    
    # 进入包目录并执行命令
    if cd "$PACKAGE_PATH" && eval $COMMAND; then
        echo -e "${GREEN}✓ $package 执行成功${NC}"
        ((SUCCESS_COUNT++))
    else
        echo -e "${RED}✗ $package 执行失败${NC}"
        ((FAIL_COUNT++))
    fi
    echo ""
    
done <<< "$WORKSPACE_PACKAGES"

# 返回根目录
cd "$PROJECT_ROOT"

# 显示执行摘要
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}执行完成${NC}"
echo -e "${BLUE}========================================${NC}"
echo -e "总模块数: $(echo "$WORKSPACE_PACKAGES" | wc -l | tr -d ' ')"
echo -e "${GREEN}成功: $((SUCCESS_COUNT + 1))${NC} (包含根目录)"
[ $FAIL_COUNT -gt 0 ] && echo -e "${RED}失败: $FAIL_COUNT${NC}"
[ $SKIP_COUNT -gt 0 ] && echo -e "${YELLOW}跳过: $SKIP_COUNT${NC}"

# 如果有失败，退出码为 1
[ $FAIL_COUNT -gt 0 ] && exit 1

exit 0

