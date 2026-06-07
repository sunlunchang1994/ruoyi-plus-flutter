# lib_module 基础包标准

## 模块职责

- `lib_module/fast`：列表/分页 VD、VmSub、刷新状态、Provider Selector、Toast、权限、请求取消、少量通用 Widget。
- `lib_module/db_base`：SharedPreferences 命名空间封装和 `DpManager` 基类。
- `lib_module/form_extra`：FormBuilder 输入控件、输入装饰、表单操作、标签流、单图选择。

`lib_module` 只放业务无关能力。RuoYi 租户、角色、菜单、字典、用户、接口地址、ResultEntity 等业务或脚手架语义放 `base`、`feature/*`、`business/*`。

## 依赖声明

- 子包只要直接 `import 'package:xxx/...'`，自己的 `pubspec.yaml` 必须声明 `xxx`。
- 版本由根 workspace 管理；子包使用空版本声明，保持和现有 workspace 风格一致。
- 不允许靠传递依赖让代码“刚好能编译”。
- 子包 `analysis_options.yaml` 包含 `flutter_lints` 时，子包 `dev_dependencies` 要声明 `flutter_lints`。

## README 规则

- README 只写当前代码已经实现的能力。
- 没有实现的能力必须写到“不包含的能力”，不要用“可选”“支持”等词暗示已实现。
- README 的示例必须能对应到当前 API，不要写不存在的 `DbSp.init()`、异步数据库、富文本、文件上传等接口。

## 列表/分页规则

- 普通列表用 `FastBaseListDataVmSub`，必须配置 `setRefresh()`。
- 分页列表用 `FastBasePageDataVmSub`，必须配置 `setLoadData()`。
- 业务操作完成后优先 `sendRefreshEvent()`，让 VD 触发刷新链路。
- 不要直接依赖 `refreshAsync()` 刷 UI，它只负责异步更新 VmSub 数据。
- 选择模式批量操作只能通知一次，避免大列表重复重建。

## 表单规则

- 搜索和新增/编辑表单统一使用 `FormOperateWithProvider` 持有 form key。
- 清除按钮如果不传 `onPressed`，必须同时传 `formOperate` 和 `formFieldName`。
- 单图选择异步回写前要检查字段是否仍然 mounted，避免页面关闭后写入。

## 本地存储规则

- `DbSp` 使用前必须完成 `SpCacheUtil` 初始化。
- 读取默认值可能写回本地存储，业务上不想写回时传 `autoSaveDefValue: false`。
- `putValue(key, null)` 语义是删除 key。
