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

REM 智能解析 workspace 模块列表
echo [信息] 正在解析 workspace 配置...
set "IN_WORKSPACE=0"
set "WORKSPACE_LIST="

for /f "usebackq tokens=*" %%l in ("%PUBSPEC_FILE%") do (
    set "LINE=%%l"
    
    REM 移除行首空格
    for /f "tokens=*" %%a in ("!LINE!") do set "LINE=%%a"
    
    REM 检查是否进入workspace部分
    if "!LINE!"=="workspace:" (
        set "IN_WORKSPACE=1"
    ) else if "!IN_WORKSPACE!"=="1" (
        REM 检查是否遇到其他顶级键（结束workspace）
        echo !LINE! | findstr /b /r "[a-zA-Z][a-zA-Z0-9_]*:" >nul
        if !errorlevel! equ 0 (
            if not "!LINE:~0,1!"==" " if not "!LINE:~0,1!"=="-" (
                set "IN_WORKSPACE=0"
            )
        )
        
        REM 如果在workspace内，解析模块
        if "!IN_WORKSPACE!"=="1" (
            REM 检查是否是列表项（以-开头）
            echo !LINE! | findstr /b /r "^ *-" >nul
            if !errorlevel! equ 0 (
                REM 提取模块名（移除-和空格）
                set "MODULE=!LINE:*- =!"
                for /f "tokens=*" %%a in ("!MODULE!") do set "MODULE=%%a"
                
                REM 如果不是注释且不为空
                if not "!MODULE:~0,1!"=="#" if not "!MODULE!"=="" (
                    if not "!WORKSPACE_LIST!"=="" set "WORKSPACE_LIST=!WORKSPACE_LIST!;"
                    set "WORKSPACE_LIST=!WORKSPACE_LIST!!MODULE!"
                )
            )
        )
    )
)

REM 检查是否解析到模块
if "!WORKSPACE_LIST!"=="" (
    echo [错误] 未找到 workspace 配置
    exit /b 1
)

echo [信息] 找到模块: !WORKSPACE_LIST!
echo.

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
for %%m in ("%WORKSPACE_LIST:;=" "%") do (
    set "MODULE=%%~m"
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

REM 返回根目录
cd /d "%PROJECT_ROOT%"

REM 显示执行摘要
echo ========================================
echo 执行完成
echo ========================================
echo 总模块数: %TOTAL_COUNT%
echo 成功: %SUCCESS_COUNT% ^(包含根目录^)
if %FAIL_COUNT% gtr 0 echo 失败: %FAIL_COUNT%
if %SKIP_COUNT% gtr 0 echo 跳过: %SKIP_COUNT%

REM 如果有失败，退出码为 1
if %FAIL_COUNT% gtr 0 exit /b 1

endlocal
exit /b 0