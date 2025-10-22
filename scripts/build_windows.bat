@echo off
REM 一键打包 Windows 桌面应用（包含完整的清理和构建流程）

setlocal enabledelayedexpansion

set SCRIPT_DIR=%~dp0
set PROJECT_ROOT=%SCRIPT_DIR%..

echo ========================================
echo 开始打包 Windows 桌面应用
echo ========================================

REM 询问用户是否需要执行步骤3和4
echo.
echo ========================================
echo 可选步骤配置
echo ========================================
echo 是否需要生成国际化文件？
echo   提示: 如果项目中已存在国际化文件且未修改，可跳过此步骤以加快打包速度
set /p GEN_L10N="  (y/n，默认y): "
if "%GEN_L10N%"=="" set GEN_L10N=y

echo.
echo 是否需要执行代码生成 (build_runner)？
echo   提示: 如果项目中已存在生成的代码且未修改相关注解，可跳过此步骤
set /p BUILD_RUNNER="  (y/n，默认y): "
if "%BUILD_RUNNER%"=="" set BUILD_RUNNER=y

REM 步骤1: 清理所有模块
echo.
echo [1/5] 清理所有模块...
call "%SCRIPT_DIR%clean_all.bat"
if errorlevel 1 (
    echo 清理失败！
    exit /b 1
)
echo 清理完成

REM 步骤2: 获取依赖
echo.
echo [2/5] 获取所有依赖...
call "%SCRIPT_DIR%pub_get_all.bat"
if errorlevel 1 (
    echo 获取依赖失败！
    exit /b 1
)
echo 依赖获取完成

REM 步骤3: 生成国际化文件（可选）
echo.
if /i "%GEN_L10N%"=="y" (
    echo [3/5] 生成国际化文件...
    call "%SCRIPT_DIR%gen_l10n_all.bat"
    if errorlevel 1 (
        echo 警告: 国际化文件生成失败或跳过（可能已存在）
    ) else (
        echo 国际化文件生成完成
    )
) else (
    echo [3/5] 跳过生成国际化文件
)

REM 步骤4: 代码生成（可选）
echo.
if /i "%BUILD_RUNNER%"=="y" (
    echo [4/5] 执行代码生成...
    call "%SCRIPT_DIR%build_runner_all.bat"
    if errorlevel 1 (
        echo 警告: 代码生成失败或跳过（可能已存在）
    ) else (
        echo 代码生成完成
    )
) else (
    echo [4/5] 跳过代码生成
)

REM 步骤5: 打包 Windows
echo.
echo [5/5] 打包 Windows 桌面应用...
cd /d "%PROJECT_ROOT%"
flutter build windows --release
if errorlevel 1 (
    echo 打包 Windows 失败！
    exit /b 1
)
echo Windows 打包完成

REM 显示Windows输出路径
set WINDOWS_PATH=%PROJECT_ROOT%build\windows\x64\runner\Release
if exist "%WINDOWS_PATH%" (
    echo.
    echo ========================================
    echo 打包成功！
    echo ========================================
    echo Windows 应用路径：
    echo %WINDOWS_PATH%
    echo.
    echo 提示：可以将整个 Release 文件夹打包分发
) else (
    echo 警告: Windows 输出目录未找到！
)

endlocal

