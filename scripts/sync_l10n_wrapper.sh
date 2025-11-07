#!/bin/bash
# 自动同步 l10n 包装文件脚本
# 从生成的 xxx_localizations.dart 文件同步代码到 xxx_l10n.dart 文件

set -e

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}自动同步 l10n 包装文件${NC}"
echo -e "${BLUE}========================================${NC}\n"

# 查找所有 l10n.yaml 文件
L10N_FILES=$(find "$PROJECT_ROOT" -name "l10n.yaml" -type f)

if [ -z "$L10N_FILES" ]; then
    echo -e "${YELLOW}未找到任何包含 l10n.yaml 的模块${NC}"
    exit 0
fi

SUCCESS_COUNT=0
FAIL_COUNT=0
SKIP_COUNT=0

# 处理每个模块
while IFS= read -r l10n_file; do
    MODULE_DIR=$(dirname "$l10n_file")
    # 计算相对路径（兼容 macOS 和 Linux）
    if [ "$MODULE_DIR" = "$PROJECT_ROOT" ]; then
        MODULE_NAME="."
    else
        MODULE_NAME=$(cd "$PROJECT_ROOT" && cd "$MODULE_DIR" && pwd | sed "s|^$PROJECT_ROOT/||")
    fi
    
    echo -e "${GREEN}>>> 处理模块: $MODULE_NAME${NC}"
    
    # 读取 l10n.yaml 配置
    OUTPUT_FILE=$(grep "^output-localization-file:" "$l10n_file" | sed 's/^output-localization-file: *//' | tr -d ' ')
    OUTPUT_CLASS=$(grep "^output-class:" "$l10n_file" | sed 's/^output-class: *//' | tr -d ' ')
    OUTPUT_DIR=$(grep "^output-dir:" "$l10n_file" | sed 's/^output-dir: *//' | tr -d ' ')
    
    if [ -z "$OUTPUT_FILE" ] || [ -z "$OUTPUT_CLASS" ]; then
        echo -e "${YELLOW}  ⚠ 跳过: 配置不完整 (output-localization-file 或 output-class 缺失)${NC}"
        ((SKIP_COUNT++))
        echo ""
        continue
    fi
    
    if [ -z "$OUTPUT_DIR" ]; then
        OUTPUT_DIR="lib/gen/l10n"
    fi
    
    # 构建文件路径
    LOCALIZATIONS_FILE="$MODULE_DIR/$OUTPUT_DIR/$OUTPUT_FILE"
    GEN_DIR="$MODULE_DIR/lib/gen"
    
    if [ ! -f "$LOCALIZATIONS_FILE" ]; then
        echo -e "${YELLOW}  ⚠ 跳过: 找不到文件 ${LOCALIZATIONS_FILE#$PROJECT_ROOT/}${NC}"
        ((SKIP_COUNT++))
        echo ""
        continue
    fi
    
    # 从文件名提取基础名称 (如 main_localizations.dart -> main)
    BASE_NAME=$(echo "$OUTPUT_FILE" | sed 's/_localizations\.dart$//')
    WRAPPER_FILE_NAME="${BASE_NAME}_l10n.dart"
    WRAPPER_FILE="$GEN_DIR/$WRAPPER_FILE_NAME"
    
    # 解析生成的 localizations 文件
    # 提取类名
    CLASS_NAME=$(grep -m 1 "^abstract class " "$LOCALIZATIONS_FILE" | sed 's/^abstract class \([A-Za-z0-9_]*\).*/\1/')
    
    if [ -z "$CLASS_NAME" ]; then
        CLASS_NAME="$OUTPUT_CLASS"
    fi
    
    # 扫描 l10n 目录下所有的本地化文件，提取导入语句
    L10N_DIR="$MODULE_DIR/$OUTPUT_DIR"
    LOCALE_IMPORTS=""
    
    # 查找所有匹配 *_localizations_*.dart 的文件
    if [ -d "$L10N_DIR" ]; then
        shopt -s nullglob 2>/dev/null || true
        for locale_file in "$L10N_DIR"/${BASE_NAME}_localizations_*.dart; do
            if [ -f "$locale_file" ]; then
                locale_file_name=$(basename "$locale_file")
                LOCALE_IMPORTS="${LOCALE_IMPORTS}import 'l10n/${locale_file_name}';\n"
            fi
        done
        shopt -u nullglob 2>/dev/null || true
    fi
    
    # 从生成的 localizations 文件中提取 _MainLocalizationsDelegate 类和 lookup 函数
    # 查找以 "class _" 开头的类（即 _MainLocalizationsDelegate）
    DELEGATE_START_LINE=$(grep -n "^class _" "$LOCALIZATIONS_FILE" | head -1 | cut -d: -f1)
    
    if [ -z "$DELEGATE_START_LINE" ]; then
        echo -e "${YELLOW}  ⚠ 跳过: 找不到 _MainLocalizationsDelegate 类${NC}"
        ((SKIP_COUNT++))
        echo ""
        continue
    fi
    
    # 提取从 _MainLocalizationsDelegate 开始到文件末尾的内容
    DELEGATE_AND_LOOKUP=$(sed -n "${DELEGATE_START_LINE},\$p" "$LOCALIZATIONS_FILE")
    
    # 修改 load 方法：在 return SynchronousFuture 前添加两行代码，并替换 return 语句
    # 使用 sed 在 return SynchronousFuture 前插入两行，并修改 return 语句使用 fastLocalizations
    MODIFIED_DELEGATE=$(echo "$DELEGATE_AND_LOOKUP" | sed -e "/return SynchronousFuture/i\\
    ${CLASS_NAME} fastLocalizations = lookupLocalizations(locale);\\
    S._current = fastLocalizations;" -e "s/return SynchronousFuture<${CLASS_NAME}>(lookupLocalizations(locale));/return SynchronousFuture<${CLASS_NAME}>(fastLocalizations);/")
    
    # 将类名从 _MainLocalizationsDelegate 改为 _LocalizationsDelegate
    MODIFIED_DELEGATE=$(echo "$MODIFIED_DELEGATE" | sed "s/_${CLASS_NAME}Delegate/_LocalizationsDelegate/g")
    
    # 将 lookup 函数名从 lookupMainLocalizations 改为 lookupLocalizations
    MODIFIED_DELEGATE=$(echo "$MODIFIED_DELEGATE" | sed "s/lookup${CLASS_NAME}/lookupLocalizations/g")
    
    # 生成 S 类名称 (如 MainS, AppS, SysS)
    S_CLASS_NAME=$(echo "$CLASS_NAME" | sed 's/Localizations$/S/')
    
    # 确保目录存在
    mkdir -p "$GEN_DIR"
    
    # 生成文件内容
    {
        cat << EOF
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/$OUTPUT_FILE';
$(echo -e "$LOCALE_IMPORTS")

class ${S_CLASS_NAME} {
  static get current {
    return S._current;
  }

  static const delegate  = S.delegate;
}

class S {
  static ${CLASS_NAME}? _current;

  static ${CLASS_NAME} get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static ${CLASS_NAME} of(BuildContext context) {
    return ${CLASS_NAME}.of(context)!;
  }

  static const LocalizationsDelegate<${CLASS_NAME}> delegate = _LocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];
}

$MODIFIED_DELEGATE
EOF
    } > "$WRAPPER_FILE"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}  ✓ 已生成: ${WRAPPER_FILE#$PROJECT_ROOT/}${NC}"
        ((SUCCESS_COUNT++))
    else
        echo -e "${RED}  ✗ 生成失败${NC}"
        ((FAIL_COUNT++))
    fi
    
    echo ""
    
done <<< "$L10N_FILES"

# 显示摘要
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}执行完成${NC}"
echo -e "${BLUE}========================================${NC}"
TOTAL_COUNT=$(echo "$L10N_FILES" | wc -l | tr -d ' ')
echo "总模块数: $TOTAL_COUNT"
echo -e "${GREEN}成功: $SUCCESS_COUNT${NC}"
[ $FAIL_COUNT -gt 0 ] && echo -e "${RED}失败: $FAIL_COUNT${NC}"
[ $SKIP_COUNT -gt 0 ] && echo -e "${YELLOW}跳过: $SKIP_COUNT${NC}"

# 如果有失败，退出码为 1
[ $FAIL_COUNT -gt 0 ] && exit 1

exit 0
