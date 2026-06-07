# 网络访问标准

## 分层

页面不直接访问 Dio。

标准链路：

```text
Page -> AppBaseVm/VmSub -> Repository -> Retrofit Api -> BaseDio -> ResultEntity -> UI
```

## Dio 全局配置

- `BaseDio` 是 Dio 单例入口。
- `ApiConfig().getServiceApiAddress()` 提供 baseUrl。
- Header、加密等全局行为放 interceptor。
- 未授权统一走 `BaseDio.handlerUnauthorized`，弹窗前要判断 `BaseRouter.navigatorKey.currentContext` 非空。

## Retrofit API 写法

使用 `templates/infrastructure/api_repository.dart.tpl`。

规则：

- API 类用 `@RestApi()`。
- factory 中默认 `BaseDio.getInstance().getDio()`。
- baseUrl 默认 `ApiConfig().getServiceApiAddress()`。
- 每个请求都带 `@CancelRequest() CancelToken cancelToken`。
- 查询参数用 `@Queries() Map<String, dynamic>?`。
- 新增/编辑用 `@Body()`。
- 删除多个 ID 时，用逗号拼接，参考 `TextUtil.comma`。

## Repository 写法

- Repository 对页面暴露静态方法。
- 列表返回 `Future<IntensifyEntity<PageModel<T>>>`。
- 详情返回 `Future<IntensifyEntity<T>>`。
- 保存返回 `Future<IntensifyEntity<dynamic>>` 或具体实体。
- 用 `successMap2Single`、`successIeMap2Single` 转换和错误检查。
- 分页查询用 `RequestUtils.toPageQuery(search?.toJson(), offset, size)`。
- 结果转换用 `event.toPage2Intensify(...)`、`event.toIntensify(...)`。

## 页面错误处理

标准：

```dart
Repository.submit(body, defCancelToken).then((value) {
  dismissLoading();
  finish(result: body);
}, onError: BaseDio.errProxyFunc(onError: (error) {
  dismissLoading();
}));
```

规则：

- loading 成对出现：`showLoading` 后必须在成功和错误都 `dismissLoading`。
- 未授权错误通常直接 return，不重复 toast 或 finish。
- 主动取消请求不提示 toast。
- 列表页的错误状态由 VmSub/VD 处理，不在 UI 里解析异常。

## 分页 API

分页 VmSub 中写：

```dart
@override
Future<DataWrapper<PageModel<Demo>>> onLoadMore(LoadMoreFormat<Demo> loadMoreFormat) {
  return DemoRepository
      .list(loadMoreFormat.offset, loadMoreFormat.pageSize, currentSearch, defCancelToken)
      .then(DataTransformUtils.entity2LDWrapper);
}
```

不要在页面组件中拼 offset、pageSize 或解析后端分页结构。
