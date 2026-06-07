---
name: ruoyi-flutter-plus
description: 处理 ruoyi-flutter-plus Flutter 脚手架、页面开发、Provider/MVVM、路由跳转、列表/详情/新增编辑/搜索/Tab 页面、网络请求、本地持久化、国际化、主题样式、权限控制，或结合 boxes_flutter/flutter_slc_boxes 开发业务模块时使用。
metadata:
  short-description: ruoyi-flutter-plus 脚手架开发规则
---

# RuoYi Flutter Plus

## 工作方式

- 先沿真实链路读代码：页面 -> VM/AppBaseVm -> VmSub -> Repository -> Retrofit API -> ResultEntity/DataWrapper -> UI 通知。
- 优先复用现有模块：基础 Flutter 能力看 `boxes_flutter`，脚手架通用能力看 `base`、`lib_module/fast`、`lib_module/db_base`、`feature/component`，业务页面放 `business/*`。
- 不要把 RuoYi 的租户、权限、字典、用户、接口地址、业务 DTO 写进 `flutter_slc_boxes`；这些属于 ruoyi 脚手架或业务模块。
- 新页面必须让 `initVm()` 幂等，不能因为 `build()` 重入重复请求、重复注册 VmSub、重复创建计时器或控制器。

## Provider 和生命周期

- 新建页面 VM 用 `ChangeNotifierProvider(create: (context) => XxxVm())`。
- 已存在实例或 `GlobalVm()` 这类工厂单例才用 `ChangeNotifierProvider.value(value: ...)`，不要 `ChangeNotifierProvider.value(value: XxxVm())`。
- 页面持有 `PageController`、`FocusNode`、`Timer`、自建 `EasyRefreshController` 等资源时，用 `StatefulWidget`/`AppBaseState` 并在 `dispose()` 释放。
- 使用 `AutomaticKeepAliveClientMixin` 的 `build()` 必须调用 `super.build(context)`。
- 用到 loading/router/status 事件注册时，优先用 `AppBaseState`；纯展示或已有模式页面可继续用 `AppBaseStatelessWidget`。

## 按任务读取参考

- 项目级标准和模板统一在根目录 `scaffold/`，先读 `scaffold/INDEX.md`。
- 架构、`lib_module` 基础包、启动任务、网络、路由、页面、Provider、持久化、国际化、主题、权限等标准写法，读 `scaffold/standards/`。
- 新增功能或模块时，优先复制 `scaffold/templates/` 中的模板，再按当前业务替换占位符。
- 新功能交付前，对照 `scaffold/checklists/new-module.md`。
- 如果用户要把项目整理成干净脚手架、删除默认业务示例、抽离模板，改用 `ruoyi-clean-scaffold` skill，并先保留范例知识。

## 默认质量线

- 页面初始化不要放不可控副作用到 `build()`；若必须从 `build()` 触发，VM 内必须有幂等保护。
- 只用 `NqSelector`/`Consumer` 刷新必要区域，列表主体通常监听 `listVmSub.shouldSetState.version`。
- 表单页用 `_infoChange` 或等价脏数据标记保护返回；保存成功后 `finish(result: ...)`，列表页在 `.then(result != null)` 后 `sendRefreshEvent()`。
- 所有用户可见文案优先走对应模块 l10n；固定后端字典值显示用字典模块转换。
- 改动后至少跑 `git diff --check`；Flutter/Dart 工具链可用时再跑 `dart format`、`flutter analyze` 或聚焦测试。
