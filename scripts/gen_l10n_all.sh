#!/bin/bash
# 对所有模块执行 flutter gen-l10n，然后自动同步 l10n 包装文件

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 执行 flutter gen-l10n
"$SCRIPT_DIR/run_all.sh" "flutter gen-l10n"

# 无论 gen-l10n 是否成功，都执行同步脚本
# 同步脚本会跳过没有生成文件的模块
echo ""
echo "========================================"
echo "开始同步 l10n 包装文件..."
echo "========================================"
echo ""

# 执行同步脚本
"$SCRIPT_DIR/sync_l10n_wrapper.sh"