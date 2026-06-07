# fast

`fast` 是 ruoyi-flutter-plus 的快速开发基础包，负责列表/分页视图驱动、Provider Selector、刷新状态组件、Toast、权限和少量通用 Widget。它依赖 `boxes_flutter` 提供的 MVVM、分页模型、可观察字段、主题扩展等基础能力。

## 当前真实能力

- 列表/分页数据：`FastBaseListDataVmSub`、`FastBasePageDataVmSub`、`ListDataVd`、`PageDataVd`。
- 选择模式：`ListenerItemSelect` 支持长按进入选择、单选切换、全选/取消全选。
- 刷新与加载更多：基于 `easy_refresh`，默认 header/footer 由 `HeaderFooterSimple` 提供。
- Provider 优化：`NqSelector` 按值变化重建，`NqNullSelector` 只在空/非空可见性变化时重建。
- 请求取消：`CancelTokenAssist` 管理 Dio `CancelToken`，`IListDataVmSub.onCleared()` 会自动取消。
- 通用 UI：空数据、加载更多状态、Toast、系统 UI 显隐、返回/关闭按钮、图片自适应、可勾选菜单项。
- 权限：`PermissionCompat` 当前主要处理 Android 存储权限，其他平台暂按已授权处理。

## 标准使用

分页列表优先使用 `FastBasePageDataVmSub`：

```dart
final listVmSub = FastBasePageDataVmSub<MyRow>()
  ..setLoadData((loadMoreFormat) {
    return repository.page(loadMoreFormat);
  });
```

页面中用 `PageDataVd(listVmSub, vm)` 包裹列表，刷新完成后由 `PageDataVd` 通知外层 VM 重建。列表主体通常监听 `listVmSub.shouldSetState.version`，不要让整页无差别重建。

普通列表使用 `FastBaseListDataVmSub`，必须先调用 `setRefresh()`。如果忘记配置刷新/加载回调，基础类会抛出明确的 `StateError`，避免隐藏的 null check 崩溃。

业务操作成功后刷新列表，优先调用：

```dart
listVmSub.sendRefreshEvent();
```

不要随意直接调用 `refreshAsync()`，因为它只更新 VmSub 数据，是否刷新 UI 取决于外层页面是否额外通知。

## 兼容性说明

- `PageDataVd` 和 `ListDataVd` 只有在内部创建 `EasyRefreshController` 时，才会监听 `sendRefreshEvent()` 并触发 `callRefresh()`。如果传入外部 controller，调用方需要自己管理刷新触发。
- `ListenerItemSelect.onSelectAll()` 批量修改后只通知一次，避免大列表重复重建。
- `DataWrapper.isSuccess()` 同时兼容后端常见的 `0` 和 `200` 成功码。
- `CancelTokenAssist.cancelTokenByKey(remove: false)` 会保留 token；如果 token 已取消，再次复用会得到已取消 token，默认应使用 `remove: true`。

## 依赖规则

子包直接 import 的依赖必须在自己的 `pubspec.yaml` 声明，版本由根 workspace 管理。`fast` 当前直接依赖：

- `boxes_flutter`
- `dio`
- `intl`
- `provider`
- `easy_refresh`
- `fluttertoast`
- `flutter_svg`
- `permission_handler`

## 不包含的能力

`fast` 不放 RuoYi 业务概念，不包含租户、权限菜单、字典、用户 DTO、接口地址配置。网络请求封装、登录态、ResultEntity 转换属于 `base` 或具体 feature/business 模块。
