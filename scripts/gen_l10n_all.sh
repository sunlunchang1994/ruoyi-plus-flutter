#!/bin/bash
# 对所有模块执行 flutter gen-l10n

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"$SCRIPT_DIR/run_all.sh" "flutter gen-l10n"

