dart run build_runner build
flutter gen-l10n
# 为每个模块执行命令
find . -name "pubspec.yaml" -execdir flutter pub get \;