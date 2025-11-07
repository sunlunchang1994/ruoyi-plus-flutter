@echo off
REM 自动同步 l10n 包装文件脚本 (Windows 版本)
REM 从生成的 xxx_localizations.dart 文件同步代码到 xxx_l10n.dart 文件

setlocal enabledelayedexpansion

set "SCRIPT_DIR=%~dp0"
set "PROJECT_ROOT=%SCRIPT_DIR%.."

echo ========================================
echo 自动同步 l10n 包装文件
echo ========================================
echo.

REM 查找所有 l10n.yaml 文件
set "SUCCESS_COUNT=0"
set "FAIL_COUNT=0"
set "SKIP_COUNT=0"

for /r "%PROJECT_ROOT%" %%f in (l10n.yaml) do (
    set "L10N_FILE=%%f"
    set "MODULE_DIR=%%~dpf"
    
    REM 计算相对路径
    set "MODULE_NAME=!MODULE_DIR:%PROJECT_ROOT%\=!"
    if "!MODULE_NAME!"=="!MODULE_DIR!" set "MODULE_NAME=."
    
    echo [33m>>> 处理模块: !MODULE_NAME![0m
    
    REM 读取 l10n.yaml 配置
    for /f "tokens=2 delims=: " %%a in ('findstr /C:"output-localization-file:" "!L10N_FILE!"') do set "OUTPUT_FILE=%%a"
    for /f "tokens=2 delims=: " %%a in ('findstr /C:"output-class:" "!L10N_FILE!"') do set "OUTPUT_CLASS=%%a"
    for /f "tokens=2 delims=: " %%a in ('findstr /C:"output-dir:" "!L10N_FILE!"') do set "OUTPUT_DIR=%%a"
    
    if "!OUTPUT_FILE!"=="" (
        echo [33m  ⚠ 跳过: 配置不完整[0m
        set /a SKIP_COUNT+=1
        echo.
        continue
    )
    
    if "!OUTPUT_DIR!"=="" set "OUTPUT_DIR=lib/gen/l10n"
    
    REM 构建文件路径
    set "LOCALIZATIONS_FILE=!MODULE_DIR!!OUTPUT_DIR!\!OUTPUT_FILE!"
    set "GEN_DIR=!MODULE_DIR!lib\gen"
    
    if not exist "!LOCALIZATIONS_FILE!" (
        echo [33m  ⚠ 跳过: 找不到文件[0m
        set /a SKIP_COUNT+=1
        echo.
        continue
    )
    
    REM 从文件名提取基础名称
    set "BASE_NAME=!OUTPUT_FILE:_localizations.dart=!"
    set "WRAPPER_FILE_NAME=!BASE_NAME!_l10n.dart"
    set "WRAPPER_FILE=!GEN_DIR!\!WRAPPER_FILE_NAME!"
    
    REM 解析生成的 localizations 文件
    for /f "tokens=3 delims= " %%a in ('findstr /R "^abstract class " "!LOCALIZATIONS_FILE!"') do set "CLASS_NAME=%%a"
    if "!CLASS_NAME!"=="" set "CLASS_NAME=!OUTPUT_CLASS!"
    
    REM 扫描 l10n 目录下所有的本地化文件，提取导入语句
    set "L10N_DIR=!MODULE_DIR!!OUTPUT_DIR!"
    set "LOCALE_IMPORTS="
    
    REM 查找所有匹配 *_localizations_*.dart 的文件
    if exist "!L10N_DIR!" (
        for %%f in ("!L10N_DIR!\!BASE_NAME!_localizations_*.dart") do (
            if exist "%%f" (
                set "LOCALE_FILE=%%~nxf"
                set "LOCALE_IMPORTS=!LOCALE_IMPORTS!import 'l10n/!LOCALE_FILE!';^
"
            )
        )
    )
    
    REM 从生成的 localizations 文件中提取 _MainLocalizationsDelegate 类和 lookup 函数
    REM 查找以 "class _" 开头的类（即 _MainLocalizationsDelegate）
    for /f "tokens=1 delims=:" %%a in ('findstr /N /R "^class _" "!LOCALIZATIONS_FILE!"') do (
        set "DELEGATE_START_LINE=%%a"
        goto :found_delegate
    )
    
    echo [33m  ⚠ 跳过: 找不到 _MainLocalizationsDelegate 类[0m
    set /a SKIP_COUNT+=1
    echo.
    continue
    
    :found_delegate
    REM 提取从 _MainLocalizationsDelegate 开始到文件末尾的内容到临时文件
    set "TEMP_FILE=%TEMP%\l10n_delegate_%RANDOM%.tmp"
    more +!DELEGATE_START_LINE! "!LOCALIZATIONS_FILE!" > "!TEMP_FILE!"
    
    REM 读取临时文件内容并修改 load 方法
    set "MODIFIED_DELEGATE="
    set "IN_LOAD_METHOD=0"
    set "LOAD_MODIFIED=0"
    
    for /f "tokens=* delims=" %%a in ('type "!TEMP_FILE!"') do (
        set "LINE=%%a"
        
        REM 检测是否进入 load 方法
        echo !LINE! | findstr /C:"Future<" | findstr /C:"load(Locale locale)" >nul
        if !errorlevel! equ 0 (
            set "IN_LOAD_METHOD=1"
            set "LOAD_MODIFIED=0"
        )
        
        REM 在 load 方法中，在 return SynchronousFuture 前插入两行
        if !IN_LOAD_METHOD! equ 1 (
            echo !LINE! | findstr /C:"return SynchronousFuture" >nul
            if !errorlevel! equ 0 (
                if !LOAD_MODIFIED! equ 0 (
                    set "MODIFIED_DELEGATE=!MODIFIED_DELEGATE!    !CLASS_NAME! fastLocalizations = lookupLocalizations(locale);^
"
                    set "MODIFIED_DELEGATE=!MODIFIED_DELEGATE!    S._current = fastLocalizations;^
"
                    set "LOAD_MODIFIED=1"
                    REM 替换 return 语句，使用 fastLocalizations 而不是再次调用 lookupLocalizations
                    set "LINE=!LINE:lookupLocalizations(locale)=fastLocalizations!"
                )
            )
            
            REM 检测 load 方法结束
            echo !LINE! | findstr /C:"^  }" >nul
            if !errorlevel! equ 0 (
                set "IN_LOAD_METHOD=0"
            )
        )
        
        set "MODIFIED_DELEGATE=!MODIFIED_DELEGATE!!LINE!^
"
    )
    
    REM 删除临时文件
    del "!TEMP_FILE!" >nul 2>&1
    
    REM 将类名从 _MainLocalizationsDelegate 改为 _LocalizationsDelegate
    set "MODIFIED_DELEGATE=!MODIFIED_DELEGATE:_%CLASS_NAME%Delegate=_LocalizationsDelegate!"
    
    REM 将 lookup 函数名从 lookupMainLocalizations 改为 lookupLocalizations
    set "MODIFIED_DELEGATE=!MODIFIED_DELEGATE:lookup%CLASS_NAME%=lookupLocalizations!"
    
    REM 生成 S 类名称
    set "S_CLASS_NAME=!CLASS_NAME:Localizations=S!"
    
    REM 确保目录存在
    if not exist "!GEN_DIR!" mkdir "!GEN_DIR!"
    
    REM 生成文件内容
    (
        echo import 'package:flutter/cupertino.dart';^
        echo import 'package:flutter/foundation.dart';^
        echo import 'package:flutter/widgets.dart';^
        echo import 'package:flutter_localizations/flutter_localizations.dart';^
        echo.^
        echo import 'l10n/!OUTPUT_FILE!';^
        echo !LOCALE_IMPORTS!^
        echo.^
        echo class !S_CLASS_NAME! {^
        echo   static get current {^
        echo     return S._current;^
        echo   }^
        echo.^
        echo   static const delegate  = S.delegate;^
        echo }^
        echo.^
        echo class S {^
        echo   static !CLASS_NAME!? _current;^
        echo.^
        echo   static !CLASS_NAME! get current {^
        echo     assert(^
        echo       _current != null,^
        echo       'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',^
        echo     );^
        echo     return _current!;^
        echo   }^
        echo.^
        echo   static !CLASS_NAME! of(BuildContext context) {^
        echo     return !CLASS_NAME!.of(context)!;^
        echo   }^
        echo.^
        echo   static const LocalizationsDelegate^<!CLASS_NAME!^> delegate = _LocalizationsDelegate();^
        echo.^
        echo   static const List^<LocalizationsDelegate^<dynamic^>^> localizationsDelegates =^
        echo       ^<LocalizationsDelegate^<dynamic^>^>[^
        echo     delegate,^
        echo     GlobalMaterialLocalizations.delegate,^
        echo     GlobalCupertinoLocalizations.delegate,^
        echo     GlobalWidgetsLocalizations.delegate,^
        echo   ];^
        echo }^
        echo.^
        echo !MODIFIED_DELEGATE!
    ) > "!WRAPPER_FILE!"
    
    if !errorlevel! equ 0 (
        echo [32m  ✓ 已生成: !WRAPPER_FILE![0m
        set /a SUCCESS_COUNT+=1
    ) else (
        echo [31m  ✗ 生成失败[0m
        set /a FAIL_COUNT+=1
    )
    
    echo.
)

echo ========================================
echo 执行完成
echo ========================================
echo 成功: !SUCCESS_COUNT!
if !FAIL_COUNT! gtr 0 echo 失败: !FAIL_COUNT!
if !SKIP_COUNT! gtr 0 echo 跳过: !SKIP_COUNT!

if !FAIL_COUNT! gtr 0 exit /b 1
exit /b 0
