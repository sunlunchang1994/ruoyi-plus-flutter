@echo off
REM Flutter Workspace 批量执行脚本 (Windows 批处理版本)
REM 使用方法: scripts\run_all.bat "命令"
REM 例如: scripts\run_all.bat "flutter pub get"

REM 设置控制台编码为UTF-8，防止中文乱码
chcp 65001 >nul 2>&1

setlocal enabledelayedexpansion

REM 检查参数
if "%~1"=="" (
    echo [错误] 请提供要执行的命令
    echo 用法: %~nx0 "command"
    echo 示例: %~nx0 "flutter pub get"
    exit /b 1
)

set "COMMAND=%~1"
set "PROJECT_ROOT=%~dp0.."
set "PUBSPEC_FILE=%PROJECT_ROOT%\pubspec.yaml"

REM 检查 pubspec.yaml 是否存在
if not exist "%PUBSPEC_FILE%" (
    echo [错误] 找不到 pubspec.yaml 文件
    exit /b 1
)

echo ========================================
echo Flutter Workspace 批量命令执行
echo ========================================
echo 执行命令: %COMMAND%
echo.

REM 提取 workspace 配置
REM 只解析 workspace: 块中以 "  - " 开头的行（两个空格 + 减号 + 空格）
REM 使用临时文件存储模块列表，避免字符串分割问题
set "TEMP_MODULES_FILE=%TEMP%\workspace_modules_%RANDOM%.txt"
set "IN_WORKSPACE=0"

REM 创建空的临时文件
if exist "%TEMP_MODULES_FILE%" del "%TEMP_MODULES_FILE%"

for /f "usebackq tokens=* delims=" %%a in ("%PUBSPEC_FILE%") do (
    set "LINE=%%a"
    
    REM 检查是否进入 workspace 块（精确匹配 "workspace:"）
    echo !LINE! | findstr /r /c:"^workspace:" >nul
    if not errorlevel 1 (
        set "IN_WORKSPACE=1"
    ) else if "!IN_WORKSPACE!"=="1" (
        REM 检查是否退出 workspace 块（遇到不以空格开头的行，表示新的顶级键）
        echo !LINE! | findstr /r "^[^ ]" >nul
        if not errorlevel 1 (
            REM 遇到不以空格开头的行，退出 workspace 块
            set "IN_WORKSPACE=0"
        ) else (
            REM 只处理以 "  - " 开头的行（两个空格 + 减号 + 空格）
            echo !LINE! | findstr /r /c:"^  - " >nul
            if not errorlevel 1 (
                REM 提取模块路径：去掉 "  - " 前缀和尾随空格
                set "MODULE=!LINE:  - =!"
                REM 去掉尾随空格
                for /f "tokens=* delims= " %%b in ("!MODULE!") do set "MODULE=%%b"
                if not "!MODULE!"=="" (
                    REM 直接写入临时文件
                    echo !MODULE! >> "%TEMP_MODULES_FILE%"
                )
            )
        )
    )
)

REM 首先在根目录执行
echo ^>^>^> 执行根目录: .
cd /d "%PROJECT_ROOT%"
call %COMMAND%
if errorlevel 1 (
    echo [错误] 根目录执行失败
) else (
    echo [成功] 根目录执行成功
)
echo.

REM 统计变量
set /a SUCCESS_COUNT=1
set /a FAIL_COUNT=0
set /a SKIP_COUNT=0
set /a TOTAL_COUNT=0

REM 对每个 workspace 成员执行命令
REM 从临时文件读取模块列表（每行一个模块）
if exist "%TEMP_MODULES_FILE%" (
    for /f "usebackq tokens=* delims=" %%m in ("%TEMP_MODULES_FILE%") do (
        set "MODULE=%%m"
        REM 跳过空行
        if not "!MODULE!"=="" (
            REM 去掉可能的尾随空格和换行符
            for /f "tokens=* delims= " %%b in ("!MODULE!") do set "MODULE=%%b"
            if not "!MODULE!"=="" (
                set "MODULE_PATH=%PROJECT_ROOT%\!MODULE!"
                
                REM 转换路径分隔符
                set "MODULE_PATH=!MODULE_PATH:/=\!"
                
                set /a TOTAL_COUNT+=1
                
                REM 检查目录是否存在
                if not exist "!MODULE_PATH!" (
                    echo [警告] 跳过 !MODULE! ^(目录不存在^)
                    set /a SKIP_COUNT+=1
                ) else if not exist "!MODULE_PATH!\pubspec.yaml" (
                    echo [警告] 跳过 !MODULE! ^(无 pubspec.yaml^)
                    set /a SKIP_COUNT+=1
                ) else (
                    echo ^>^>^> 执行模块: !MODULE!
                    cd /d "!MODULE_PATH!"
                    call %COMMAND%
                    if errorlevel 1 (
                        echo [失败] !MODULE! 执行失败
                        set /a FAIL_COUNT+=1
                    ) else (
                        echo [成功] !MODULE! 执行成功
                        set /a SUCCESS_COUNT+=1
                    )
                    echo.
                )
            )
        )
    )
    
    REM 清理临时文件
    if exist "%TEMP_MODULES_FILE%" del "%TEMP_MODULES_FILE%"
)

REM 返回根目录
cd /d "%PROJECT_ROOT%"

REM 显示执行摘要
echo ========================================
echo 执行完成
echo ========================================
set /a TOTAL_MODULES=%TOTAL_COUNT%+1
echo 总模块数: %TOTAL_MODULES% ^(包含根目录^)
echo 成功: %SUCCESS_COUNT% ^(包含根目录^)
if %FAIL_COUNT% gtr 0 echo 失败: %FAIL_COUNT%
if %SKIP_COUNT% gtr 0 echo 跳过: %SKIP_COUNT%

REM 如果有失败，退出码为 1
if %FAIL_COUNT% gtr 0 exit /b 1

endlocal
exit /b 0