# 启动任务和配置标准

## 启动链路

标准顺序：

```dart
void main() async {
  TaskLoader.loadTasks();
  await TaskManager().execRunAppBeforeTask();
  runApp(const RootPage());
}
```

- `RunAppBeforeTask`：只能放 runApp 前必须完成的初始化，如 `WidgetsFlutterBinding.ensureInitialized()`、`SpCacheUtil.getInstance()`、应用名注册。
- `RootPage`：提供 `GlobalVm`、构建 `MaterialApp`、注册主题、路由、国际化。
- `RunAppAfterTask`：首帧后执行，放日志、屏幕工具、API 地址、附件地址、租户默认值等依赖 context 或非阻塞初始化的任务。

## RootPage 标准

- `RootPage` 用 `StatefulWidget`，启动后任务放 `initState + addPostFrameCallback`。
- 不要在 `build()` 里执行 `execRunAppAfterTask`。
- `GlobalVm()` 是工厂单例，使用 `ChangeNotifierProvider<GlobalVm>.value(value: GlobalVm())`。
- themeMode 用 `NqSelector<GlobalVm, ThemeMode>` 监听。

## 全局配置

- 环境接口地址从 `EnvConfig.getEnvConfig()` 设置到 `ApiConfig()`。
- 附件下载地址由 `AttachmentConfig()` 设置。
- 用户租户开关和默认租户由 `UserConfig()` 设置。
- 配置值需要持久化时使用 `DpManager`，不要直接散落调用 SharedPreferences。

## 新增启动任务模板

使用 `templates/infrastructure/startup_task.dart.tpl`。

注意：

- before task 不要访问还不存在的 Navigator context。
- after task 可以接收 `BuildContext? context`，但必须允许为空。
- 任务应幂等，避免热重载或 Root 重建后重复初始化造成副作用。
