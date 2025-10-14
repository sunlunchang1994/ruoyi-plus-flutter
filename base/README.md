# Base - 基础核心模块

> **Workspace 模块** | 路径: `base`

## 📦 模块概述

Base 模块是整个项目的基础核心模块，提供了应用开发所需的基础架构、网络请求、路由管理、全局配置等核心功能。所有业务模块都依赖于此模块。

## ✨ 主要功能

### 🌐 网络请求层 (`base/api/`)
- **API 配置管理** - 统一的 API 配置和环境管理
- **Dio 封装** - 基于 Retrofit 的网络请求封装
- **请求拦截器** - 自动添加请求头、Token、租户信息等
- **加密拦截器** - 支持请求/响应数据加密
- **统一异常处理** - API 异常的统一捕获和处理
- **数据转换** - JSON 序列化/反序列化的统一处理
- **结果封装** - 统一的 API 响应结果实体

### 🛣️ 路由管理 (`base/route/`)
- **路由基类** - 提供路由的基础定义和跳转能力
- **路由导航** - 支持命名路由和参数传递

### 🎨 UI 基础组件 (`base/ui/`)
- **MVVM 基类** - 提供 MVVM 架构的基础视图和 ViewModel
- **启动页组件** - 简单的应用启动视图
- **日期选择工具** - 日期时间选择的便捷方法
- **对话框工具** - 快速创建各类对话框
- **自定义组件** - 包含应用级通用 UI 组件

### 🔧 工具类 (`base/utils/`)
- **时间格式化** - 多种时间格式化工具
- **图片工具** - 图片处理相关工具
- **输入格式化** - 文本输入的格式限制

### 📦 实体定义 (`base/entity/`)
- **基础实体** - 通用的数据实体基类
- **租户实体** - 租户信息相关实体

### 🚀 启动任务 (`base/startup/`)
- **启动任务管理** - 应用启动时的初始化任务编排

### 🎯 全局状态 (`base/vm/`)
- **全局 ViewModel** - 管理应用级的全局状态

### 🌍 国际化支持 (`gen/l10n/`)
- **多语言支持** - 中文、英文等多语言本地化

## 🔗 依赖关系

**依赖的 workspace 模块：** 
- `fast` - 快速开发工具库
- `db_base` - 数据持久化基础

**主要第三方依赖：**
- `retrofit` - 网络请求框架
- `encrypt` - 数据加密
- `dio` - HTTP 客户端

## 📖 使用示例

### 1. 网络请求

```dart
import 'package:base/base/api/api.dart';
import 'package:base/base/api/result_entity.dart';

// 定义 API 接口
@RestApi()
abstract class UserApi {
  factory UserApi(Dio dio) = _UserApi;
  
  @GET("/user/info")
  Future<ResultEntity<UserInfo>> getUserInfo();
}

// 使用
final api = UserApi(BaseDio.instance);
final result = await api.getUserInfo();
if (result.isSuccess) {
  final userInfo = result.data;
  // 处理用户信息
}
```

### 2. 使用 MVVM 基类

```dart
import 'package:base/base/ui/app_mvvm.dart';

class MyViewModel extends ViewModel {
  String title = "Hello";
  
  void updateTitle(String newTitle) {
    title = newTitle;
    notifyListeners();
  }
}

class MyPage extends AppStatefulPage<MyViewModel> {
  @override
  MyViewModel createViewModel() => MyViewModel();
  
  @override
  Widget buildView(BuildContext context, MyViewModel vm) {
    return Text(vm.title);
  }
}
```

### 3. 路由跳转

```dart
import 'package:base/base/route/base_router.dart';

// 跳转到指定路由
BaseRouter.push(context, '/detail', arguments: {'id': 123});

// 替换当前路由
BaseRouter.replace(context, '/login');

// 返回上一页
BaseRouter.pop(context, result: 'success');
```

### 4. 使用全局配置

```dart
import 'package:base/base/repository/local/app_config.dart';

// 获取配置
final apiUrl = AppConfig.instance.apiBaseUrl;
final isDebug = AppConfig.instance.isDebugMode;

// 设置配置
AppConfig.instance.updateApiUrl('https://api.example.com');
```

## 🎯 核心类说明

| 类名 | 路径 | 说明 |
|-----|------|-----|
| `BaseDio` | `base/api/base_dio.dart` | Dio 实例的单例管理 |
| `ApiException` | `base/api/api_exception.dart` | API 异常定义 |
| `ResultEntity<T>` | `base/api/result_entity.dart` | API 响应结果封装 |
| `InterceptorHeader` | `base/api/interceptor_header.dart` | 请求头拦截器 |
| `InterceptorEncrypt` | `base/api/interceptor_encrypt.dart` | 加密拦截器 |
| `AppMvvm` | `base/ui/app_mvvm.dart` | MVVM 架构基类 |
| `GlobalVM` | `base/vm/global_vm.dart` | 全局状态管理 |
| `BaseRouter` | `base/route/base_router.dart` | 路由管理器 |

## 🚀 使用方式

在根目录 `pubspec.yaml` 中已配置为 workspace 成员，其他模块可直接引用：

```yaml
dependencies:
  base:  # 自动使用 workspace 版本
```

## 📝 开发命令

```bash
# 进入模块目录
cd base

# 获取依赖
flutter pub get

# 生成代码（Retrofit、JsonSerializable 等）
dart run build_runner build --delete-conflicting-outputs

# 生成国际化文件
flutter gen-l10n
```

**或使用项目根目录的批量脚本：**

```bash
./scripts/pub_get_all.sh       # 所有模块获取依赖
./scripts/build_runner_all.sh  # 所有模块代码生成
./scripts/gen_l10n_all.sh      # 所有模块国际化生成
```

## 🏗️ 模块结构

```
base/
├── lib/
│   ├── base/
│   │   ├── api/              # 网络请求层
│   │   ├── config/           # 配置常量
│   │   ├── entity/           # 基础实体
│   │   ├── repository/       # 数据仓库
│   │   ├── route/            # 路由管理
│   │   ├── startup/          # 启动任务
│   │   ├── ui/               # UI 基础组件
│   │   ├── utils/            # 工具类
│   │   └── vm/               # 全局 ViewModel
│   ├── gen/                  # 生成的代码
│   │   ├── l10n/             # 国际化
│   │   └── assets.gen.dart   # 资源文件
│   └── res/                  # 资源定义
│       └── colors.dart       # 颜色定义
├── assets/                   # 资源文件
├── l10n/                     # 国际化源文件
└── pubspec.yaml              # 模块配置
```

## 🔄 与其他模块的关系

```
base (本模块)
 ├─ 被依赖: bizapi, auth, component, system, user, biz_main
 ├─ 依赖: fast, db_base
 └─ 作用: 为所有业务模块提供基础设施
```

---

*本模块是 Flutter Workspace 架构的一部分，依赖版本统一在根目录 `pubspec.yaml` 管理。*
