@echo off
REM 对所有模块执行 dart run build_runner build
"%~dp0run_all.bat" "dart run build_runner build --delete-conflicting-outputs"

