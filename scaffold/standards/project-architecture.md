# 项目架构标准

## 模块分层

- 根应用 `lib/`：启动、RootPage、MainPage、路由表、根主题、根 l10n。
- `base/`：Dio、ResultEntity、ApiConfig、BaseRouter、AppBaseVm、GlobalVm、启动任务。
- `lib_module/fast/`：列表/分页 VD、VmSub、selector、Toast、Widget 工具、请求取消。
- `lib_module/db_base/`：`DpManager`、`DbSp`、SharedPreferences 命名空间封装。
- `lib_module/form_extra/`：FormBuilder 增强控件、输入装饰、表单操作封装。
- `feature/bizapi/`：跨业务 DTO、用户/租户/字典/OSS/菜单公共 API、共享 VM。
- `feature/component/`：通用 UI 组件，如字典 UI、树选择、附件、WebView、404。
- `feature/auth`、`feature/welcome`、`feature/mix`：认证、欢迎启动、原生混合能力。
- `business/*`：具体业务页面、业务 repository、业务 l10n。

## 与 flutter_slc_boxes 的关系

- 源码目录叫 `flutter_slc_boxes`，Dart 包名是 `boxes_flutter`。
- 本项目通过 `package:boxes_flutter/flutter/slc/...` 使用基础盒子。
- `boxes_flutter` 放通用 MVVM、router、dialog、status、adapter、theme、sp cache、common util。
- RuoYi 租户、权限、字典、用户、接口地址、业务 DTO 不进入 `flutter_slc_boxes`。

## Workspace 规则

- 新增 package 时，同时更新根 `pubspec.yaml` 的 `workspace:`。
- 子 package 若直接 import `boxes_flutter`，自己的 `pubspec.yaml` 要声明依赖。
- 子 package 的业务依赖不要反向依赖根应用。
- 生成代码、l10n、assets gen 要在对应 package 内保持路径一致。

## 放置规则

- 业务页面：`business/<domain>/lib/<domain>/ui/...`
- 业务 API：`business/<domain>/lib/<domain>/repository/remote/...`
- 跨业务 DTO/API：`feature/bizapi/lib/...`
- 通用组件：`feature/component/lib/component/...`
- 业务无关工具：`lib_module/fast` 或 `base`
- 本地配置：`base/repository/local` 或对应 feature 的 `repository/local`
