# Component - 业务通用组件库

> **Workspace 模块** | 路径: `feature/component`

## 📦 模块概述

Component 模块是应用的业务通用 UI 组件库，提供可复用的业务级组件，包括字典选择、树形选择、文件上传、图片裁剪、WebView 等功能组件，为各业务模块提供统一的 UI 交互体验。

## ✨ 主要功能

### 📖 字典组件 (`dict/`)
- **字典数据实体** (`tree_dict`, `tree_dict_wrap`) - 树形字典数据结构
- **字典 UI 工具** (`dict_ui_utils`) - 字典选择、展示等 UI 工具
- **字典共享状态** (`dict_share_vm`) - 字典数据的全局状态管理

### 🌲 树形组件 (`tree/`)
- **树形导航实体** (`slc_tree_nav`) - 树形导航数据结构
- **树形列表视图** (`tree_data_list_vd`) - 树形数据列表展示组件

### 📎 附件管理 (`attachment/`)
- **上传进度** (`progress`) - 文件上传进度实体
- **附件配置** (`attachment_config`) - 附件上传配置管理
- **附件工具** (`attachment_utils`) - 文件上传、下载工具
- **媒体类型** (`media_type_constant`) - 媒体文件类型常量

### ✂️ 图片裁剪 (`crop/`)
- **图片裁剪组件** (`crop_image`) - 图片裁剪功能封装

### 🌐 WebView (`webview/`)
- **WebView 页面** (`app_web_view_page`) - 应用内网页浏览
- **WebView 工具** (`web_view_util`) - WebView 功能封装

### 🎛️ 适配器 (`adapter/`)
- **选择框适配** (`app_select_box`) - 统一的选择框适配器

### 🚫 404 页面 (`fof/`)
- **404 页面** (`no_found_page`) - 路由未找到页面

## 🔗 依赖关系

**依赖的 workspace 模块：**
- `base` - 基础核心模块
- `form_extra` - 表单扩展库

**主要第三方依赖：**
- `webview_flutter` - WebView 支持
- `crop_your_image` - 图片裁剪
- `file_picker` - 文件选择
- `image_picker` - 图片选择

## 📖 代码参考

### 字典功能

查看字典相关实现：
- **字典工具**: `lib/component/dict/utils/dict_ui_utils.dart`
- **字典状态**: `lib/component/dict/vm/dict_share_vm.dart`
- **字典实体**: `lib/component/dict/entity/tree_dict.dart`

### 树形组件

查看树形组件实现：
- **树形列表**: `lib/component/tree/vd/tree_data_list_vd.dart`
- **树形导航**: `lib/component/tree/entity/slc_tree_nav.dart`

### 附件管理

查看附件管理实现：
- **附件工具**: `lib/component/attachment/utils/attachment_utils.dart`
- **附件配置**: `lib/component/attachment/repository/local/attachment_config.dart`
- **媒体类型**: `lib/component/attachment/utils/media_type_constant.dart`

### WebView

查看 WebView 实现：
- **WebView 页面**: `lib/component/webview/app_web_view_page.dart`
- **WebView 工具**: `lib/component/webview/web_view_util.dart`

### 图片裁剪

查看图片裁剪实现：
- **裁剪组件**: `lib/component/crop/crop_image.dart`

## 🎯 核心类说明

| 类名 | 路径 | 说明 |
|-----|------|-----|
| `DictUiUtils` | `component/dict/utils/dict_ui_utils.dart` | 字典 UI 工具 |
| `DictShareVm` | `component/dict/vm/dict_share_vm.dart` | 字典共享状态 |
| `TreeDataListVD` | `component/tree/vd/tree_data_list_vd.dart` | 树形列表视图 |
| `AttachmentUtils` | `component/attachment/utils/attachment_utils.dart` | 附件工具 |
| `AppWebViewPage` | `component/webview/app_web_view_page.dart` | WebView 页面 |
| `CropImage` | `component/crop/crop_image.dart` | 图片裁剪 |
| `NoFoundPage` | `component/fof/no_found_page.dart` | 404 页面 |

## 🚀 使用方式

在根目录 `pubspec.yaml` 中已配置为 workspace 成员，其他模块可直接引用：

```yaml
dependencies:
  component:  # 自动使用 workspace 版本
```

## 📝 开发命令

```bash
# 进入模块目录
cd feature/component

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
component/
├── lib/
│   ├── component/
│   │   ├── adapter/             # 适配器
│   │   ├── attachment/          # 附件管理
│   │   │   ├── entity/          # 实体
│   │   │   ├── repository/      # 配置
│   │   │   └── utils/           # 工具
│   │   ├── crop/                # 图片裁剪
│   │   ├── dict/                # 字典组件
│   │   │   ├── entity/          # 实体
│   │   │   ├── utils/           # 工具
│   │   │   └── vm/              # 状态管理
│   │   ├── fof/                 # 404 页面
│   │   ├── tree/                # 树形组件
│   │   │   ├── entity/          # 实体
│   │   │   └── vd/              # 视图驱动
│   │   └── webview/             # WebView
│   └── gen/                     # 生成的代码
│       └── l10n/                # 国际化
└── pubspec.yaml                 # 模块配置
```

## 🔄 与其他模块的关系

```
component (本模块)
 ├─ 被依赖: bizapi, system, user, biz_main
 ├─ 依赖: base, form_extra
 └─ 作用: 为业务模块提供可复用的 UI 组件
```

## 💡 组件特点

1. **高度可复用** - 组件设计通用化，适配多种业务场景
2. **配置灵活** - 支持丰富的配置选项
3. **状态管理** - 使用 Provider 进行状态管理
4. **样式统一** - 遵循 Material Design 设计规范
5. **国际化支持** - 所有组件支持多语言

---

*本模块是 Flutter Workspace 架构的一部分，依赖版本统一在根目录 `pubspec.yaml` 管理。*
