# Fast - 快速开发工具库

> **Workspace 模块** | 路径: `lib_module/fast`

## 📦 模块概述

Fast 模块是一个强大的快速开发工具库，提供了基于 MVVM 架构的视图驱动（VD）组件、Provider 状态管理扩展、权限管理、适配器模式以及各种实用工具类。该模块旨在加速应用开发，减少重复代码。

## ✨ 主要功能

### 📋 视图驱动组件 (`fast/vd/`)
提供强大的列表和分页数据加载解决方案，内置刷新、加载更多、空数据、错误处理等状态管理。

- **列表数据驱动 (ListDataVD)** - 管理列表数据的加载、刷新和状态
- **分页数据驱动 (PageDataVD)** - 支持分页加载的列表数据管理
- **数据组件 (ListDataComponent)** - 可复用的列表视图组件
- **下拉刷新/上拉加载** - 基于 `easy_refresh` 的完整刷新组件
  - `ContentEmpty` - 空数据视图
  - `Loading` - 加载中视图
  - `LoadMoreError` - 加载失败视图
  - `LoadMoreSucceed` - 加载成功视图
  - `NoMore` - 没有更多数据视图
- **请求 Token 管理** - 防止重复请求的 Token 管理器

### 🔄 Provider 扩展 (`fast/provider/`)
- **FastSelect** - 优化的 Provider Selector，减少不必要的重建
- **ShouldSetState** - 智能的状态更新判断

### 🔐 权限管理 (`fast/permission/`)
- **PermissionCompat** - 跨平台的权限请求和检查工具
- 统一的权限申请接口
- 支持多权限批量申请

### 🎨 自定义组件 (`fast/widget/`)
- **ImageSuitableView** - 自适应图片视图
- **SlcCheckedPopupMenuItem** - 带选中状态的弹出菜单项

### 🔧 工具类 (`fast/utils/`)
- **AppToast** - 统一的 Toast 提示工具
- **BarUtils** - 状态栏、导航栏工具
- **WidgetUtils** - Widget 相关工具方法

### 🌐 Retrofit 扩展 (`fast/retrofit/`)
- **RetrofitExpand** - Retrofit 的功能扩展

### 🌍 国际化支持
- 中文、英文等多语言本地化

## 🔗 依赖关系

**主要第三方依赖：**
- `boxes_flutter` - MVVM 基础框架
- `provider` - 状态管理
- `easy_refresh` - 下拉刷新和上拉加载
- `permission_handler` - 权限管理

## 📖 使用示例

### 分页列表使用示例

查看业务模块中如何使用分页组件：

- **字典数据列表**: `business/system/lib/system/ui/dict/data/dict_data_list_page_vd.dart`
  - 使用 `FastBasePageDataVmSub` 和 `FastBaseListDataVmSub`
  
- **参数配置列表**: `business/system/lib/system/ui/config/config_list_page_vd.dart`
  - 使用 `FastBasePageDataVmSub` 实现分页加载

- **文件管理列表**: `business/system/lib/system/ui/oss/oss_list_page_vd.dart`
  - 使用 `FastBasePageDataVmSub` 管理OSS文件列表

- **通知公告列表**: `business/system/lib/system/ui/notice/notice_list_page_vd.dart`
  - 使用 `FastBasePageDataVmSub` 实现公告列表分页

- **租户管理列表**: `business/system/lib/system/ui/tenant/tenant_list_page_vd.dart`
  - 使用 `FastBasePageDataVmSub` 管理租户列表

- **操作日志列表**: `business/system/lib/system/ui/log/sys_oper_log_list_page_vd.dart`
  - 使用 `FastBasePageDataVmSub` 实现日志分页查询

- **菜单管理列表**: `business/system/lib/system/ui/menu/menu_list_page_vd.dart`
  - 使用 `FastBaseListDataVmSub` 管理菜单树形数据

### Toast 提示使用示例

查看认证模块中如何使用 Toast：

- **登录页面**: `feature/auth/lib/auth/ui/login_page.dart`
  - 使用 `AppToastUtil.showToast()` 显示各种提示信息

### 状态栏工具使用示例

- **登录页面**: `feature/auth/lib/auth/ui/login_page.dart`
  - 使用 `BarUtils.showEnabledSystemUI()` 控制系统UI显示

## 🎯 核心类说明

| 类名 | 路径 | 说明 |
|-----|------|-----|
| `PageDataVD` | `fast/vd/page_data_vd.dart` | 分页数据视图驱动基类 |
| `ListDataVD` | `fast/vd/list_data_vd.dart` | 列表数据视图驱动基类 |
| `ListDataComponent` | `fast/vd/list_data_component.dart` | 列表数据组件 |
| `PageDataVmSub` | `fast/vd/page_data_vm_sub.dart` | 分页 ViewModel 子类 |
| `ListDataVmSub` | `fast/vd/list_data_vm_sub.dart` | 列表 ViewModel 子类 |
| `PermissionCompat` | `fast/permission/permission_compat.dart` | 权限兼容工具 |
| `AppToast` | `fast/utils/app_toast.dart` | Toast 工具 |
| `FastSelect` | `fast/provider/fast_select.dart` | Provider 选择器 |
| `RequestTokenManager` | `fast/vd/request_token_manager.dart` | 请求 Token 管理 |

## 🚀 使用方式

在根目录 `pubspec.yaml` 中已配置为 workspace 成员，其他模块可直接引用：

```yaml
dependencies:
  fast:  # 自动使用 workspace 版本
```

## 📝 开发命令

```bash
# 进入模块目录
cd lib_module/fast

# 获取依赖
flutter pub get

# 生成国际化文件
flutter gen-l10n
```

**或使用项目根目录的批量脚本：**

```bash
./scripts/pub_get_all.sh       # 所有模块获取依赖
./scripts/gen_l10n_all.sh      # 所有模块国际化生成
```

## 🏗️ 模块结构

```
fast/
├── lib/
│   ├── fast/
│   │   ├── adapter/          # 适配器模式
│   │   ├── permission/       # 权限管理
│   │   ├── provider/         # Provider 扩展
│   │   ├── retrofit/         # Retrofit 扩展
│   │   ├── utils/            # 工具类
│   │   ├── vd/               # 视图驱动组件
│   │   │   ├── refresh/      # 刷新组件
│   │   │   ├── list_data_vd.dart
│   │   │   ├── page_data_vd.dart
│   │   │   └── ...
│   │   └── widget/           # 自定义组件
│   ├── gen/                  # 生成的代码
│   │   └── l10n/             # 国际化
│   └── l10n/                 # 国际化源文件
└── pubspec.yaml              # 模块配置
```

## 🔄 与其他模块的关系

```
fast (本模块)
 ├─ 被依赖: base, form_extra, component, bizapi, auth, system, user
 ├─ 依赖: boxes_flutter, provider, easy_refresh
 └─ 作用: 为所有模块提供快速开发工具和组件
```

## 💡 最佳实践

1. **使用 PageDataVD 处理分页列表** - 自动管理加载状态、空数据、错误处理
2. **使用 FastSelect 优化性能** - 避免不必要的 Widget 重建
3. **统一使用 AppToast** - 保持应用提示风格一致
4. **使用 PermissionCompat** - 简化权限请求流程
5. **继承 ListDataVmSub/PageDataVmSub** - 快速实现列表/分页功能

---

*本模块是 Flutter Workspace 架构的一部分，依赖版本统一在根目录 `pubspec.yaml` 管理。*
