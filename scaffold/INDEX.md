# RuoYi Flutter Plus 脚手架标准入口

这个目录是项目级脚手架资料，供人和 AI 共同读取。`.codex/skills` 只做触发和导航，标准写法、模板、清理清单都放在这里。

## 先读顺序

1. `standards/project-architecture.md`：模块分层、依赖边界、`boxes_flutter` 关系。
2. `standards/startup-and-config.md`：启动任务、环境配置、全局 VM、初始化顺序。
3. `standards/lib-module.md`：`fast`、`db_base`、`form_extra` 基础包职责和兼容规则。
4. `standards/state-provider-lifecycle.md`：Provider、VM、资源释放、`initVm()` 幂等。
5. `standards/network.md`：Dio、Retrofit、Repository、错误处理、取消请求。
6. `standards/routing-messaging.md`：路由注册、参数、返回值、页面间刷新。
7. `standards/page-patterns.md`：Tab、列表、搜索、表单、详情、WebView、选择器。
8. `standards/storage-i18n-theme-permission.md`：本地存储、国际化、主题、权限、字典。

## 模板

- `templates/crud/entity.dart.tpl`：实体模板。
- `templates/infrastructure/api_repository.dart.tpl`：Retrofit API + Repository 模板。
- `templates/crud/page_list.dart.tpl`：分页列表页模板。
- `templates/crud/page_vd.dart.tpl`：列表 item、搜索抽屉、分页 VmSub 模板。
- `templates/crud/page_add_edit.dart.tpl`：新增/编辑表单页模板。
- `templates/crud/page_detail.dart.tpl`：详情页模板。
- `templates/infrastructure/config_manager.dart.tpl`：本地配置模板。
- `templates/infrastructure/startup_task.dart.tpl`：启动任务模板。
- `templates/infrastructure/route_registration.dart.tpl`：路由注册模板。
- `templates/infrastructure/module_pubspec.yaml.tpl`：Workspace 子模块 pubspec 模板。

## 清理脚手架

- `checklists/new-module.md`：新增模块/功能检查清单。
- `checklists/clean-scaffold.md`：整理成干净脚手架检查清单。

## 原则

- 基础 Flutter 能力优先看 `boxes_flutter`，不要把业务语义写进基础盒子。
- ruoyi 脚手架通用能力放 `base`、`lib_module/*`、`feature/component`。
- 业务功能放 `business/*` 或新建业务 package。
- 任何标准写法先落在 `scaffold/`，skill 只引用，不复制大段模板。
