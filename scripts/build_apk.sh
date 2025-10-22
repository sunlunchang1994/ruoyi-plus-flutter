#!/bin/bash
# 一键打包 APK（包含完整的清理和构建流程）

set -e  # 遇到错误立即退出

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================"
echo -e "开始打包 APK"
echo -e "========================================${NC}"

# 询问用户是否需要执行步骤3和4
echo -e "\n${BLUE}========================================"
echo -e "可选步骤配置"
echo -e "========================================${NC}"
echo -e "${YELLOW}是否需要生成国际化文件？${NC}"
echo -e "${YELLOW}  提示: 如果项目中已存在国际化文件且未修改，可跳过此步骤以加快打包速度${NC}"
echo -e "${YELLOW}  (y/n，默认y): ${NC}\c"
read -r GEN_L10N
GEN_L10N=${GEN_L10N:-y}

echo -e "\n${YELLOW}是否需要执行代码生成 (build_runner)？${NC}"
echo -e "${YELLOW}  提示: 如果项目中已存在生成的代码且未修改相关注解，可跳过此步骤${NC}"
echo -e "${YELLOW}  (y/n，默认y): ${NC}\c"
read -r BUILD_RUNNER
BUILD_RUNNER=${BUILD_RUNNER:-y}

# 步骤1: 清理所有模块
echo -e "\n${BLUE}[1/5] 清理所有模块...${NC}"
"$SCRIPT_DIR/clean_all.sh"
if [ $? -ne 0 ]; then
    echo -e "${RED}清理失败！${NC}"
    exit 1
fi
echo -e "${GREEN}✓ 清理完成${NC}"

# 步骤2: 获取依赖
echo -e "\n${BLUE}[2/5] 获取所有依赖...${NC}"
"$SCRIPT_DIR/pub_get_all.sh"
if [ $? -ne 0 ]; then
    echo -e "${RED}获取依赖失败！${NC}"
    exit 1
fi
echo -e "${GREEN}✓ 依赖获取完成${NC}"

# 步骤3: 生成国际化文件（可选）
if [[ "$GEN_L10N" == "y" || "$GEN_L10N" == "Y" ]]; then
    echo -e "\n${BLUE}[3/5] 生成国际化文件...${NC}"
    "$SCRIPT_DIR/gen_l10n_all.sh"
    if [ $? -ne 0 ]; then
        echo -e "${YELLOW}⚠ 国际化文件生成失败或跳过（可能已存在）${NC}"
    else
        echo -e "${GREEN}✓ 国际化文件生成完成${NC}"
    fi
else
    echo -e "\n${YELLOW}[3/5] 跳过生成国际化文件${NC}"
fi

# 步骤4: 代码生成（可选）
if [[ "$BUILD_RUNNER" == "y" || "$BUILD_RUNNER" == "Y" ]]; then
    echo -e "\n${BLUE}[4/5] 执行代码生成...${NC}"
    "$SCRIPT_DIR/build_runner_all.sh"
    if [ $? -ne 0 ]; then
        echo -e "${YELLOW}⚠ 代码生成失败或跳过（可能已存在）${NC}"
    else
        echo -e "${GREEN}✓ 代码生成完成${NC}"
    fi
else
    echo -e "\n${YELLOW}[4/5] 跳过代码生成${NC}"
fi

# 步骤5: 打包 APK
echo -e "\n${BLUE}[5/5] 打包 APK...${NC}"
cd "$PROJECT_ROOT"
flutter build apk --release
if [ $? -ne 0 ]; then
    echo -e "${RED}打包 APK 失败！${NC}"
    exit 1
fi
echo -e "${GREEN}✓ APK 打包完成${NC}"

# 显示APK路径
APK_PATH="$PROJECT_ROOT/build/app/outputs/flutter-apk/app-release.apk"
if [ -f "$APK_PATH" ]; then
    echo -e "\n${GREEN}========================================"
    echo -e "打包成功！"
    echo -e "========================================${NC}"
    echo -e "${YELLOW}APK 文件路径：${NC}"
    echo -e "$APK_PATH"
    
    # 获取文件大小
    if [[ "$OSTYPE" == "darwin"* ]]; then
        SIZE=$(ls -lh "$APK_PATH" | awk '{print $5}')
    else
        SIZE=$(du -h "$APK_PATH" | cut -f1)
    fi
    echo -e "${YELLOW}文件大小：${NC}$SIZE"
else
    echo -e "${RED}警告: APK 文件未找到！${NC}"
fi

