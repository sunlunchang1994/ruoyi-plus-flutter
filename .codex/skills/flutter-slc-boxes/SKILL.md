---
name: flutter-slc-boxes
description: 处理 flutter_slc_boxes、boxes_flutter，或 ruoyi-flutter-plus 等依赖 boxes_flutter 的 Flutter 项目时使用；用于判断基础盒子边界、MVVM/FastVm、路由、加载弹窗、状态页、选择/分页工具、国际化代理和依赖解析问题。
metadata:
  short-description: boxes_flutter 基础盒子规则
---

# Flutter Slc Boxes

## 先确认

- `flutter_slc_boxes` 是源码目录，Dart 包名是 `boxes_flutter`；消费项目不要写 `package:flutter_slc_boxes/...`。
- 在消费项目报错时，先查 `pubspec.yaml`、`pubspec.lock`、`.dart_tool/package_config.json`，确认 `boxes_flutter` 实际解析到 Git 缓存、pub 缓存还是本地覆盖。
- 不要在业务项目里复制基础工具。通用行为先改 `flutter_slc_boxes`，业务语义才放到 `ruoyi-flutter-plus` 的 `base`、`fast`、`feature` 或 `business` 模块。
- 若要临时联调本地源码，使用 `pubspec_overrides.yaml`；正式脚手架不要依赖相对路径，优先用 Git 依赖并通过 `flutter pub upgrade boxes_flutter` 拉取最新提交。

## 架构边界

- `lib/flutter/slc/mvvm/base_mvvm.dart`：`BaseVm`、`VmSub`、`MvvmStatelessWidget`、`MvvmState` 是基础 MVVM。
- `lib/flutter/slc/mvvm/fast_mvvm.dart`：`FastVm` 组合 loading、router、status；业务项目应通过自己的 `AppBaseVm` 扩展。
- `lib/flutter/slc/router`：路由参数与返回值使用 `SlcRouterInfo` 和 BuildContext 扩展。
- `lib/flutter/slc/dialog`：加载弹窗由 VM 驱动；用到事件注册的页面优先使用有 dispose 的 `FastState`。
- `lib/flutter/slc/mvvm/status_widget.dart`：状态页依赖 `Boxes.of(context)`，消费项目必须注册 `BoxesLocalizations.delegate`。
- `lib/flutter/slc/adapter`：分页、选择盒子、`PageModel`、`PageUtils` 等基础适配放这里，不放 RuoYi 的租户、权限、接口语义。

## 使用规则

- 页面使用 `FastVm` 能力前，必须先通过 `Provider`/`ChangeNotifierProvider` 提供 VM，再调用 `registerEvent`。
- 新创建的 VM 用 `ChangeNotifierProvider(create: ...)`；已有实例或单例才用 `.value`。
- `registerEvent(context, listen: true)` 只在确实需要整个页面响应 VM 通知时使用；局部刷新优先用 `NqSelector`。
- 路由参数通过既有 helper 传递 `SlcRouterInfo`，页面中用 `context.getSlcRouterInfo()` 读取。
- 可选择列表实体实现 `ISelectBox<T>` 或混入 `SelectBoxMixin<T>`；不要手写一套选择状态。
- 分页使用 `PageModel` 和 `PageUtils`；接口响应转换放业务项目的 repository/base 层。

## 校验

- 基础工具改动优先补 `flutter_slc_boxes/test` 的聚焦测试。
- 本地 Flutter 工具可用时运行 `flutter test`、`flutter analyze`。
- 如果 Dart/Flutter 在启动分析前崩溃，把工具链崩溃单独报告，不把它当作源码问题。
