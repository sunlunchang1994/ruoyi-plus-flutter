# 新增模块/功能检查清单

## 文件

- 新建 package 或在现有 package 下新增功能目录。
- 如果是新 package，更新根 `pubspec.yaml` 的 `workspace:`。
- 子 package `pubspec.yaml` 声明直接 import 的依赖。
- 新增 entity、repository、page、vd、route、l10n。

## 代码

- Page 使用 `ChangeNotifierProvider(create)`。
- `initVm()` 幂等。
- 请求传 `defCancelToken`。
- Repository 不向页面暴露 Dio。
- 列表使用 `PageDataVd`。
- 表单使用 `FormOperateWithProvider`。
- 保存成功 `finish(result: ...)`。
- 列表根据 result 刷新。
- 权限只包裹 action。
- 用户可见文案进入 l10n。

## 生成

- 运行 l10n 生成。
- 运行 build_runner。
- 运行格式化和 analyze。
- 若 Dart/Flutter 工具链崩溃，记录工具链问题。
