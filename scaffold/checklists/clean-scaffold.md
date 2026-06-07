# 干净脚手架整理检查清单

## 先保留

- 保留 `scaffold/` 全目录。
- 保留 `.codex/skills` 导航。
- 保留 `base`、`lib_module/*`、必要 `feature/component`。
- 清理业务前确认 `scaffold/standards` 和 `scaffold/templates` 足够覆盖被删范式。

## 可删除/改造

- 默认 RuoYi 业务页面：`business/user`、`business/system`、`business/biz_main`。
- 真实认证：按目标保留或改 mock。
- 真实菜单/字典/租户 API：按目标保留或改 mock。

## 必须同步

- `lib/code/route/app_router.dart`
- `lib/code/page/main_page.dart`
- `RootPage.localizationsDelegates`
- 根 `pubspec.yaml` workspace 和 dependencies
- 各 package import
- l10n、assets gen、build_runner 生成物

## 校验

```bash
git diff --check
rg -n "package:user|package:system|package:biz_main|RoleList|SysConfig|Tenant|DictType" lib base feature business lib_module
```

工具链可用时：

```bash
dart format .
flutter analyze
flutter test
```
