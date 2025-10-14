#!/bin/bash
# 对所有模块执行 dart run build_runner build

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"$SCRIPT_DIR/run_all.sh" "dart run build_runner build --delete-conflicting-outputs"

