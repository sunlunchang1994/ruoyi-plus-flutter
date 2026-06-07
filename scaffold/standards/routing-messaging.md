# 路由和页面消息标准

## 路由注册

- 页面定义 `static const String routeName`。
- 根应用统一在 `lib/code/route/app_router.dart` 注册。
- route builder 中用 `context.getSlcRouterInfo()` 读取参数。
- 参数 key 放常量类，优先使用 `ConstantBase` 或业务 `ConstantXxx`。

模板见 `templates/infrastructure/route_registration.dart.tpl`。

## 跳转

VM 中使用：

```dart
pushNamed(DemoAddEditPage.routeName, arguments: {
  ConstantDemo.KEY_DEMO: item,
}).then((result) {
  if (result != null) {
    listVmSub.sendRefreshEvent();
  }
});
```

规则：

- 新增/编辑成功后用 `finish(result: entity)`。
- 列表页根据返回值刷新，不引入全局事件总线。
- Web URL 菜单跳 `AppWebViewPage.routeName`，参数包含 URL 和 title。

## 页面返回

- 普通返回：`finish()`。
- 带结果返回：`finish(result: data)`。
- 表单页有未保存数据时，用 `PopScope` 拦截并提示。

## 页面间刷新

- 父子页面：用 Future 返回值。
- 列表内部：用 `listVmSub.sendRefreshEvent()`。
- 共享用户/字典状态：使用 `UserShareVm`、`DictShareVm` 这类已有共享 VM。
- 不新增全局 event bus，除非有明确跨模块广播需求。
