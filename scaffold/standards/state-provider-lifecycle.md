# Provider、VM 和生命周期标准

## Provider 使用

- 新建 VM：`ChangeNotifierProvider(create: (context) => XxxVm())`。
- 已有实例/单例：`ChangeNotifierProvider.value(value: XxxVmSingleton())`。
- 不要写 `ChangeNotifierProvider.value(value: XxxVm())`，这会让 Provider 生命周期语义错误。
- 子树只需要读一次上级 VM 时，用 `Provider.of<XxxVm>(context, listen: false)`。
- 局部 UI 刷新优先 `NqSelector`，不要整页 `Consumer`。

## 页面基类

- 普通页面：`AppBaseStatelessWidget<T extends AppBaseVm>`。
- 持有 controller/focus/timer/listener 的页面：`StatefulWidget + AppBaseState<W, T>`。
- 使用 `AutomaticKeepAliveClientMixin` 时，`build()` 必须调用 `super.build(context)`。

## initVm 幂等

`build()` 可能重复执行，所以 `initVm()` 必须符合以下至少一种：

- 只做 `registerVmSub(...)`，底层会去重。
- 用实体字段判空，例如 `if (info != null) return;`。
- 用 `_initialized`，适用于网络请求、Timer、listener、controller 初始化。

标准写法：

```dart
bool _initialized = false;

void initVm() {
  if (_initialized) {
    return;
  }
  _initialized = true;
  // network/listener/timer/controller init
}
```

## 资源释放

必须在 `dispose()` 释放：

- `PageController`、`ScrollController`、`TextEditingController`
- `FocusNode`
- `Timer`
- 手动 `addListener` 的 listener
- 自建 `EasyRefreshController`

请求取消：

- VM 或 VmSub 混入 `CancelTokenAssist`。
- 使用 `defCancelToken` 传给 Repository。
- `AppBaseVm.dispose()` 和 `FastVmSub.onCleared()` 会触发取消。
