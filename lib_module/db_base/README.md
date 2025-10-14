# DB Base - 数据持久化基础库

> **Workspace 模块** | 路径: `lib_module/db_base`

## 📦 模块概述

DB Base 模块是一个轻量级的数据持久化基础库，提供了统一的数据存储和访问机制。它封装了 `SharedPreferences` 和数据库操作，为应用提供简单易用的本地数据持久化方案。

## ✨ 主要功能

### 💾 数据持久化 (`db_base/data_persistence.dart`)
- **统一接口** - 提供统一的数据存储和读取接口
- **类型安全** - 支持多种数据类型的存储和读取
- **异步操作** - 基于 Future 的异步数据操作
- **生命周期管理** - 自动管理数据库的初始化和关闭

### 🔧 SharedPreferences 封装 (`db_base/db_sp.dart`)
- **简化操作** - 简化 SharedPreferences 的使用
- **类型支持** - 支持 String、int、double、bool、List 等类型
- **同步读取** - 提供同步和异步两种读取方式
- **批量操作** - 支持批量存储和删除

### 📦 持久化管理器 (`db_base/dp_manager.dart`)
- **统一管理** - 统一管理应用的所有持久化数据
- **初始化控制** - 提供初始化和清理方法
- **单例模式** - 确保全局只有一个实例

## 🔗 依赖关系

**主要第三方依赖：**
- `boxes_flutter` - MVVM 基础框架
- `shared_preferences` - 本地存储
- `sqflite` - SQLite 数据库（可选）

## 📖 使用示例

### DpManager 持久化管理器使用示例

查看业务模块中如何使用持久化管理器：

- **用户配置存储**: `feature/bizapi/lib/user/repository/local/user_config.dart`
  - 继承 `DpManager` 实现用户配置的持久化
  - 保存和读取用户登录信息（租户ID、账号、密码、自动登录等）
  - 使用 `getDp().putValue()` 存储数据
  - 使用 `getDp().getString()` / `getDp().getBool()` 读取数据

### 核心使用方法

**存储数据**
- `saveIsSavePassword(bool value)` - 保存是否记住密码
- `saveIsAutoLogin(bool value)` - 保存是否自动登录
- `saveTenantId(String? tenantId)` - 保存租户ID
- `saveAccount(String? account)` - 保存账号
- `savePassword(String? password)` - 保存密码

**读取数据**
- `isSavePassword()` - 读取是否记住密码
- `isAutoLogin()` - 读取是否自动登录
- `getTenantId()` - 读取租户ID
- `getAccount()` - 读取账号
- `getPassword()` - 读取密码

## 🎯 核心类说明

| 类名 | 路径 | 说明 |
|-----|------|-----|
| `DataPersistence` | `db_base/data_persistence.dart` | 数据持久化基类 |
| `DbSp` | `db_base/db_sp.dart` | SharedPreferences 封装 |
| `DpManager` | `db_base/dp_manager.dart` | 持久化管理器 |

## 🎨 核心 API

### DpManager 主要方法

**数据操作**
- `getDp().putValue(String key, dynamic value)` - 存储数据
- `getDp().getString(String key)` - 读取字符串
- `getDp().getInt(String key)` - 读取整数
- `getDp().getBool(String key, {bool? defValue})` - 读取布尔值
- `getDp().getDouble(String key)` - 读取浮点数

查看完整实现：`feature/bizapi/lib/user/repository/local/user_config.dart`

## 🚀 使用方式

在根目录 `pubspec.yaml` 中已配置为 workspace 成员，其他模块可直接引用：

```yaml
dependencies:
  db_base:  # 自动使用 workspace 版本
```

## 📝 开发命令

```bash
# 进入模块目录
cd lib_module/db_base

# 获取依赖
flutter pub get
```

**或使用项目根目录的批量脚本：**

```bash
./scripts/pub_get_all.sh       # 所有模块获取依赖
```

## 🏗️ 模块结构

```
db_base/
├── lib/
│   └── db_base/
│       ├── data_persistence.dart    # 数据持久化基类
│       ├── db_sp.dart              # SharedPreferences 封装
│       └── dp_manager.dart         # 持久化管理器
└── pubspec.yaml                    # 模块配置
```

## 🔄 与其他模块的关系

```
db_base (本模块)
 ├─ 被依赖: base, fast, bizapi, auth, system, user
 ├─ 依赖: boxes_flutter, shared_preferences
 └─ 作用: 为所有模块提供统一的数据持久化能力
```

## 💡 最佳实践

1. **应用启动时初始化** - 在 main 函数中调用 `DbSp.init()` 或 `DpManager.instance.init()`
2. **使用有意义的键名** - 使用常量定义键名，避免硬编码
3. **处理空值** - 读取数据时总是检查返回值是否为 null
4. **敏感数据加密** - 对于敏感信息，结合加密工具进行存储
5. **及时清理** - 不再需要的数据及时删除，避免占用空间
6. **继承 DpManager** - 为不同业务创建独立的配置管理类

## 🔐 安全建议

- 不要直接存储密码等敏感信息，应使用加密后再存储
- Token 等认证信息建议设置过期时间
- 重要数据建议做备份和校验

---

*本模块是 Flutter Workspace 架构的一部分，依赖版本统一在根目录 `pubspec.yaml` 管理。*
