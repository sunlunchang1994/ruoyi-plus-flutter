# db_base

`db_base` 是轻量本地持久化基础包，目前只封装 `SharedPreferencesWithCache`，不包含 SQLite、异步数据库、单例生命周期管理。

## 当前真实能力

- `DataPersistence`：定义 int、double、bool、String、List<String> 的读写接口。
- `DbSp`：基于 `SharedPreferencesWithCache` 实现命名空间隔离，真实 key 格式为 `spName:key`。
- `DpManager`：业务配置管理类的基类，默认创建 `DbSp`。

## 启动前提

`DbSp` 依赖 `boxes_flutter` 的 `SpCacheUtil.getSp()`。应用启动任务必须先初始化 `SpCacheUtil`，否则 `DbSp` 构造时会因为 `getSp()!` 崩溃。

标准使用方式：

```dart
class UserConfig extends DpManager {
  UserConfig() : super('user');

  void saveAccount(String? value) {
    getDp().putValue('account', value);
  }

  String? getAccount() {
    return getDp().getString('account');
  }
}
```

## 读默认值的副作用

`getInt()`、`getDouble()`、`getString()`、`getStringList()` 在传入非空默认值时，默认会把缺失 key 的默认值写回本地存储。这个设计适合初始化配置，但读取操作会产生写入副作用。

如果只想读取默认值、不想写回：

```dart
getDp().getString('apiAddress', defValue: '', autoSaveDefValue: false);
```

`getBool()` 当前默认 `autoSaveDefValue` 为 `false`，和其他类型不同，业务上需要写回时要显式传入。

## 兼容性说明

- `putValue(key, null)` 表示删除 key，并返回当前 `DataPersistence`，保持链式调用。
- `clear()` 只删除当前 `spName:` 前缀下的 key，不会清空其他命名空间。
- `DataPersistence.checkValueType()` 只允许 SharedPreferences 支持的基础类型。

## 依赖规则

`db_base` 直接 import 的依赖必须在自己的 `pubspec.yaml` 声明：

- `boxes_flutter`
- `shared_preferences`

## 不包含的能力

当前包不包含 SQLite、加密存储、token 过期策略、异步批处理。敏感信息如果要落盘，应由业务层先加密或另建专用安全存储模块。
