# 模板使用说明

模板中的占位符使用 `{{Name}}` 形式。复制模板后按业务替换：

- `{{Module}}`：Dart package 名，如 `demo`。
- `{{Feature}}`：功能英文名，如 `Demo`。
- `{{feature}}`：小写功能名，如 `demo`。
- `{{Entity}}`：实体类名，如 `Demo`.
- `{{entity}}`：实体变量名，如 `demo`.
- `{{routeBase}}`：路由前缀，如 `/demo`.
- `{{PermissionPrefix}}`：权限前缀，如 `demo`.

使用顺序：

1. `infrastructure/module_pubspec.yaml.tpl`
2. `crud/entity.dart.tpl`
3. `infrastructure/api_repository.dart.tpl`
4. `crud/page_vd.dart.tpl`
5. `crud/page_list.dart.tpl`
6. `crud/page_add_edit.dart.tpl`
7. `crud/page_detail.dart.tpl`
8. `infrastructure/route_registration.dart.tpl`
