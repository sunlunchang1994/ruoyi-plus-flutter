# BizAPI - 业务 API 接口层

> **Workspace 模块** | 路径: `feature/bizapi`

## 📦 模块概述

BizAPI 模块是应用的业务 API 接口层，按业务领域划分组织 API 接口和数据实体。它作为前端与后端 RuoYi-Vue-Plus 系统交互的桥梁，提供类型安全的接口定义和数据模型。

## ✨ 主要功能

### 🔐 认证相关 (`auth/`)
- **登录结果实体** - 登录返回数据封装
- **用户认证信息** - Token、用户信息等数据结构

### 🗂️ 系统管理 API (`system/`)

#### 数据实体
- **字典管理** (`sys_dict_type`, `sys_dict_data`) - 字典类型和字典数据
- **菜单管理** (`sys_menu_tree`, `router_vo`, `meta_vo`) - 菜单树、路由配置
- **租户管理** (`sys_tenant`, `sys_tenant_package`) - 租户信息、租户套餐
- **配置管理** (`sys_config`) - 系统配置参数
- **文件管理** (`sys_oss_vo`, `sys_oss_upload_vo`) - OSS 文件上传下载

#### 远程接口
- **`PubDictDataApi`** - 公共字典数据接口
- **`PubMenuApi`** - 公共菜单接口
- **`PubTenantApi`** - 公共租户接口
- **`PubOssApi`** - 公共文件上传下载接口

#### 本地服务
- **`LocalDictLib`** - 本地字典缓存管理

### 👥 用户管理 API (`user/`)

#### 数据实体
- **用户信息** (`user`, `user_info_vo`, `my_user_info_vo`) - 用户基本信息
- **个人资料** (`profile_vo`, `avatar_vo`) - 用户个人资料、头像
- **组织架构** (`dept`, `post`, `role`) - 部门、岗位、角色
- **菜单选择** (`select_menu_result`) - 菜单选择结果

#### 远程接口
- **`PubUserApi`** - 公共用户接口
- **`PubUserProfileApi`** - 用户个人资料接口

#### 本地服务
- **`UserConfig`** - 用户配置管理

#### 状态管理
- **`UserShareVm`** - 用户共享状态 ViewModel

## 🔗 依赖关系

**依赖的 workspace 模块：**
- `component` - 业务组件
- `base` - 基础核心模块

**主要第三方依赖：**
- `retrofit` - API 接口定义
- `json_annotation` - JSON 序列化

## 📖 代码参考

### API 接口定义

查看具体的 API 接口实现：

- **字典 API**: `lib/system/repository/remote/pub_dict_data_api.dart`
- **菜单 API**: `lib/system/repository/remote/pub_menu_api.dart`
- **租户 API**: `lib/system/repository/remote/pub_tenant_api.dart`
- **文件 API**: `lib/system/repository/remote/pub_oss_api.dart`
- **用户 API**: `lib/user/repository/remote/pub_user_api.dart`
- **个人资料 API**: `lib/user/repository/remote/pub_user_profile_api.dart`

### 数据实体定义

查看具体的实体类实现：

- **系统实体**: `lib/system/entity/` 目录
- **用户实体**: `lib/user/entity/` 目录
- **认证实体**: `lib/auth/entity/` 目录

### 本地配置管理

查看本地配置和缓存管理：

- **字典缓存**: `lib/system/repository/local/local_dict_lib.dart`
- **用户配置**: `lib/user/repository/local/user_config.dart`

### 状态管理

查看共享状态管理：

- **用户共享状态**: `lib/user/vm/user_share_vm.dart`

## 🎯 核心类说明

### 系统 API

| 类名 | 路径 | 说明 |
|-----|------|-----|
| `PubDictDataApi` | `system/repository/remote/pub_dict_data_api.dart` | 字典数据接口 |
| `PubMenuApi` | `system/repository/remote/pub_menu_api.dart` | 菜单接口 |
| `PubTenantApi` | `system/repository/remote/pub_tenant_api.dart` | 租户接口 |
| `PubOssApi` | `system/repository/remote/pub_oss_api.dart` | 文件接口 |
| `LocalDictLib` | `system/repository/local/local_dict_lib.dart` | 字典缓存 |

### 用户 API

| 类名 | 路径 | 说明 |
|-----|------|-----|
| `PubUserApi` | `user/repository/remote/pub_user_api.dart` | 用户接口 |
| `PubUserProfileApi` | `user/repository/remote/pub_user_profile_api.dart` | 个人资料接口 |
| `UserConfig` | `user/repository/local/user_config.dart` | 用户配置 |
| `UserShareVm` | `user/vm/user_share_vm.dart` | 用户共享状态 |

## 🚀 使用方式

在根目录 `pubspec.yaml` 中已配置为 workspace 成员，其他模块可直接引用：

```yaml
dependencies:
  bizapi:  # 自动使用 workspace 版本
```

## 📝 开发命令

```bash
# 进入模块目录
cd feature/bizapi

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
bizapi/
├── lib/
│   ├── auth/                    # 认证相关
│   │   └── entity/              # 登录结果等实体
│   ├── system/                  # 系统管理
│   │   ├── config/              # 配置常量
│   │   ├── entity/              # 系统实体
│   │   └── repository/
│   │       ├── local/           # 本地缓存
│   │       └── remote/          # 远程 API
│   ├── user/                    # 用户管理
│   │   ├── config/              # 配置常量
│   │   ├── entity/              # 用户实体
│   │   ├── repository/
│   │   │   ├── local/           # 本地配置
│   │   │   └── remote/          # 远程 API
│   │   └── vm/                  # 状态管理
│   └── gen/                     # 生成的代码
│       └── l10n/                # 国际化
└── pubspec.yaml                 # 模块配置
```

## 🔄 与其他模块的关系

```
bizapi (本模块)
 ├─ 被依赖: auth, system, user, biz_main
 ├─ 依赖: component, base
 └─ 作用: 为业务模块提供类型安全的 API 接口
```

## 💡 设计特点

1. **领域驱动** - 按业务领域（auth/system/user）组织代码
2. **类型安全** - 使用 Retrofit 和 JsonSerializable 确保类型安全
3. **分层清晰** - entity、repository、vm 职责分明
4. **本地缓存** - 提供本地配置和缓存管理
5. **公共接口** - 所有 API 以 Pub 前缀标识公共接口

---

*本模块是 Flutter Workspace 架构的一部分，依赖版本统一在根目录 `pubspec.yaml` 管理。*
