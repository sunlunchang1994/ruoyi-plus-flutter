@echo off
REM 对所有模块执行 flutter gen-l10n，然后自动同步 l10n 包装文件

setlocal enabledelayedexpansion

set "SCRIPT_DIR=%~dp0"

REM 执行 flutter gen-l10n
call "%SCRIPT_DIR%run_all.bat" "flutter gen-l10n"

REM 无论 gen-l10n 是否成功，都执行同步脚本
REM 同步脚本会跳过没有生成文件的模块
echo.
echo ========================================
echo 开始同步 l10n 包装文件...
echo ========================================
echo.

REM 执行同步脚本
call "%SCRIPT_DIR%sync_l10n_wrapper.bat"

