# 页面标准写法

## Tab 页

- 主 Tab 用 `StatefulWidget + AppBaseState` 管理 `PageController`。
- Tab 子页如果需要保活，混入 `AutomaticKeepAliveClientMixin` 并调用 `super.build(context)`。
- 子页网络初始化必须幂等。

## 分页列表页

使用：

- `AppBaseStatelessWidget<T>`
- `ChangeNotifierProvider(create)`
- `registerEvent(context)`
- `PageDataVd`
- `NqSelector` 监听 `listVmSub.shouldSetState.version`
- `FastBasePageDataVmSub<T>` 管理分页、搜索、选择、刷新

模板：

- `templates/crud/page_list.dart.tpl`
- `templates/crud/page_vd.dart.tpl`

## 搜索抽屉

- 搜索入口放 AppBar 搜索按钮。
- 搜索 UI 放 `endDrawer`。
- 搜索状态放 `listVmSub.currentSearch` 或 SearchVm。
- 清空按钮使用 `NqNullSelector`。
- 搜索提交调用 `sendRefreshEvent()`。

## 新增/编辑页

使用：

- `getStatusBody(context)` 管加载状态。
- `FormOperateWithProvider` 管 `FormBuilder`。
- `_infoChange` 管脏数据。
- `PopScope` 拦截未保存返回。
- 保存成功 `finish(result: entity)`。

模板：`templates/crud/page_add_edit.dart.tpl`。

## 详情页

- 详情页仍可使用 `getStatusBody(context)`。
- 只读展示用 `ListTile`、`Table`、普通 `Text` 或 disabled 表单。
- 删除、复制、打开等操作只包裹对应权限按钮。

模板：`templates/crud/page_detail.dart.tpl`。

## WebView

- `WebViewController` 初始化必须幂等。
- 返回优先 `controller.canGoBack()`，不能回退再 `Navigator.pop(context)`。
- 外部浏览器打开使用 `launchUrl(Uri.parse(url))`。

## 选择器

- 单选、多选、树选择都走独立 route。
- 调用方通过 `.then((result) { ... })` 写回实体和表单。
- 写回表单用 `formOperate.patchField(...)`。
