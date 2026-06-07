## 提示

本项目使用Flutter v3.27.4开发，后续持续跟进官方最新版本

## 💡 简介

**RuoYi-Flutter-Plus** 是一个基于 **Flutter 3.27.4** 开发的**企业级全平台应用框架**，完美对接 [RuoYi-Vue-Plus](https://gitee.com/dromara/RuoYi-Vue-Plus) 后端系统。项目采用**现代化 Workspace 架构**，实现模块化开发、依赖统一管理，为企业应用开发提供开箱即用的解决方案。

### ⭐ 核心亮点

- 🎯 **真正的全平台支持** - Android、iOS、Windows、Linux、macOS、Web 六端统一
- 🏗️ **Workspace 架构** - 模块化设计，依赖版本统一管理，开发效率倍增
- 🔐 **完整的 RBAC 权限体系** - 用户、角色、部门、岗位、菜单权限全覆盖
- 🏢 **多租户 SaaS 架构** - 开箱即用的多租户管理能力
- 📊 **丰富的业务功能** - 30+ 业务模块，涵盖系统管理、日志监控、文件管理等
- 🎨 **Material 3 设计** - 支持明暗主题，跟随系统主题自动切换
- 🌍 **国际化支持** - 内置中英文，易于扩展其他语言
- 📦 **开箱即用** - 提供完整的脚本工具，一键构建、部署

## 🏗️ 项目架构

项目采用 **Flutter Workspace** 模块化架构设计，将功能划分为多个独立模块，职责清晰、松耦合、易维护。

### 📁 模块结构总览

```
ruoyi-flutter-plus/
├── .codex/skills/             # Codex 技能入口，负责触发和导航
├── scaffold/                  # 脚手架标准、模板、检查清单
├── 📦 基础设施层
│   ├── base/                    # 核心基础模块
│   └── lib_module/              # 工具库模块
│       ├── fast/                # 快速开发工具
│       ├── db_base/             # 数据持久化
│       └── form_extra/          # 表单扩展
├── 🔌 功能特性层
│   └── feature/
│       ├── auth/                # 认证授权
│       ├── bizapi/              # 业务 API
│       ├── component/           # 通用组件
│       ├── welcome/             # 欢迎页
│       └── mix/                 # 原生混合
└── 💼 业务应用层
    └── business/
        ├── biz_main/            # 主业务入口
        ├── system/              # 系统管理
        └── user/                # 用户管理
```

### 🎯 模块详细介绍

#### 📦 基础设施层

**核心模块**
- **[Base - 基础核心模块](base/README.md)** 🔧  
  提供网络请求、路由管理、MVVM 架构、全局配置等基础设施，是所有模块的基石

**工具库模块**
- **[Fast - 快速开发工具](lib_module/fast/README.md)** ⚡  
  视图驱动（VD）组件、Provider 扩展、权限管理、Toast 提示，让开发飞起来
  
- **[DB Base - 数据持久化](lib_module/db_base/README.md)** 💾  
  轻量 SharedPreferences 命名空间封装，提供 `DpManager` 配置管理基类
  
- **[Form Extra - 表单扩展](lib_module/form_extra/README.md)** 📝  
  基于 flutter_form_builder 的文本输入、选择输入、表单操作、标签流和单图选择扩展

#### 🔌 功能特性层

- **[Auth - 认证授权](feature/auth/README.md)** 🔐  
  完整的登录认证、Token 管理、多租户支持、权限验证
  
- **[BizAPI - 业务 API](feature/bizapi/README.md)** 🌐  
  按业务领域组织的 API 接口层，类型安全的 Retrofit 接口定义
  
- **[Component - 通用组件](feature/component/README.md)** 🎨  
  字典选择、树形选择、文件上传、图片裁剪、WebView 等可复用业务组件
  
- **[Welcome - 欢迎页](feature/welcome/README.md)** 👋  
  应用启动屏、引导页、版本检查
  
- **[Mix - 原生混合](feature/mix/README.md)** 🔗  
  Flutter 与原生平台交互，支持混合开发场景

#### 💼 业务应用层

- **[BizMain - 主业务入口](business/biz_main/README.md)** 🏠  
  应用主框架、导航结构、数据仪表盘，整合所有业务模块
  
- **[System - 系统管理](business/system/README.md)** ⚙️  
  租户管理、字典管理、菜单管理、参数配置、日志监控、文件管理、在线用户、缓存监控等完整的后台管理功能
  
- **[User - 用户管理](business/user/README.md)** 👥  
  用户管理、部门管理、岗位管理、角色管理、个人中心、权限分配

## 🔗 配套后端系统

本项目完美对接以下后端系统：

| 后端系统 | 版本 | 仓库地址 | 说明 |
|---------|------|---------|------|
| RuoYi-Vue-Plus | 5.X | [Gitee](https://gitee.com/dromara/RuoYi-Vue-Plus) | 单体架构（推荐） |
| RuoYi-Cloud-Plus | 2.X | [Gitee](https://gitee.com/dromara/RuoYi-Cloud-Plus) | 微服务架构 |

> ⚠️ **注意**：请确保后端版本匹配，建议使用 RuoYi-Vue-Plus 5.X 版本

## 🚀 快速开始

### 环境要求

- Flutter SDK >= 3.27.4
- Dart SDK >= 3.6.0
- IDE: Android Studio / VS Code / IntelliJ IDEA

### 一键安装依赖

```bash
# macOS / Linux
./scripts/pub_get_all.sh

# Windows
scripts\pub_get_all.bat
```

### 构建运行

```bash
# 生成国际化文件
./scripts/gen_l10n_all.sh        # macOS/Linux
scripts\gen_l10n_all.bat         # Windows

# 生成代码（API、实体等）
./scripts/build_runner_all.sh    # macOS/Linux
scripts\build_runner_all.bat     # Windows

# 运行应用
flutter run
```

### 更多脚本命令

查看完整的脚本使用说明：[scripts/README.md](scripts/README.md)

### 脚手架标准与模板

项目级标准写法和模板统一放在 [scaffold/INDEX.md](scaffold/INDEX.md)，包括启动任务、网络访问、Provider/MVVM、路由、列表、搜索、表单、详情、本地持久化、国际化、主题、权限、字典和清理成干净脚手架的检查清单。

### Codex 技能入口

项目内置的 Codex 技能放在 [.codex/skills](.codex/skills)，用于让 AI 在后续开发时先读取项目规则，不偏离当前架构。

| 技能 | 使用场景 |
|------|----------|
| [flutter-slc-boxes](.codex/skills/flutter-slc-boxes/SKILL.md) | 处理 `flutter_slc_boxes` / `boxes_flutter` 基础盒子边界、MVVM、路由、状态页、分页、国际化代理和依赖解析问题 |
| [ruoyi-flutter-plus](.codex/skills/ruoyi-flutter-plus/SKILL.md) | 处理本项目页面开发、Provider/MVVM、路由、列表、搜索、表单、网络、本地持久化、国际化、主题和权限规则 |
| [ruoyi-clean-scaffold](.codex/skills/ruoyi-clean-scaffold/SKILL.md) | 将当前项目整理成干净脚手架时使用；清理前必须先保留页面、网络、表单、路由、权限等范例知识 |

说明：技能只负责触发和导航，详细标准、模板和检查清单以 [scaffold/INDEX.md](scaffold/INDEX.md) 为准。

## 📱 在线体验

**测试账号**: admin / admin123

- **Android APK 下载**: [发布页面](https://gitee.com/sunlunchang/ruoyi-plus-flutter/releases)

## 🛠️ 技术栈

### 核心框架

| 技术 | 版本 | 说明 |
|-----|------|------|
| Flutter | 3.27.4 | Google 跨平台 UI 框架 |
| Dart | 3.6.0 | 现代化编程语言 |
| Material 3 | Latest | Google Material Design 3 |

### 主要依赖

| 库名 | 功能 |
|-----|------|
| [boxes_flutter](https://pub.dev/packages/boxes_flutter) | MVVM 架构基础框架 |
| [provider](https://pub.dev/packages/provider) | 状态管理 |
| [retrofit](https://pub.dev/packages/retrofit) + [dio](https://pub.dev/packages/dio) | 网络请求 |
| [easy_refresh](https://pub.dev/packages/easy_refresh) | 下拉刷新 / 上拉加载 |
| [flutter_form_builder](https://pub.dev/packages/flutter_form_builder) | 表单构建 |
| [fl_chart](https://pub.dev/packages/fl_chart) | 数据图表 |
| [cached_network_image](https://pub.dev/packages/cached_network_image) | 图片缓存 |
| [webview_flutter](https://pub.dev/packages/webview_flutter) | WebView |
| [shared_preferences](https://pub.dev/packages/shared_preferences) | 本地存储 |
| [permission_handler](https://pub.dev/packages/permission_handler) | 权限管理 |

> 📚 完整依赖列表请查看 [pubspec.yaml](pubspec.yaml)

## ✨ 架构特色

### 🏗️ Workspace 模块化架构

- **依赖统一管理** - 所有模块依赖版本在根目录统一配置
- **模块独立开发** - 每个模块可独立开发、测试
- **按需加载** - 灵活的模块组合，按需引入
- **清晰的分层** - 基础设施层、功能层、业务层职责分明

### 🎨 MVVM 架构模式

- **View（视图）** - 负责 UI 展示
- **ViewModel（视图模型）** - 负责业务逻辑和状态管理
- **Model（模型）** - 负责数据定义和存储
- **Repository（仓库）** - 负责数据获取（远程 API / 本地数据库）

### 🔄 视图驱动（VD）组件

- **ListDataVD** - 列表数据自动管理（加载、刷新、空数据、错误处理）
- **PageDataVD** - 分页数据自动管理（上拉加载更多）
- **减少 90% 的列表页样板代码**

## 📋 功能列表

基于 [RuoYi-Vue-Plus 5.X](https://gitee.com/dromara/RuoYi-Vue-Plus) 并结合移动端特性实现：

| 业务         | 功能说明                                                      | 本项目是否实现 | 后续是否实现或更新 |
| ------------ | ------------------------------------------------------------- | -------------- | ------------------ |
| 主题切换     | 支持Material 3 白天/黑夜主题切换，默认跟随系统主题            | 是             | 是                 |
| 系统登录     | 通过系统给定的账号密码进行登录                                | 是             | 是                 |
| 租户管理     | 系统内租户的管理 如:租户套餐、过期时间、用户数量、企业信息等  | 是             | 是                 |
| 租户套餐管理 | 系统内租户所能使用的套餐管理 如:套餐内所包含的菜单等          | 是             | 是                 |
| 用户管理     | 用户的管理配置 如:新增用户、分配用户所属部门、角色、岗位等    | 是             | 是                 |
| 部门管理     | 配置系统组织机构（公司、部门、小组） 树结构展现支持数据权限   | 是             | 是                 |
| 岗位管理     | 配置系统用户所属担任职务                                      | 是             | 是                 |
| 菜单管理     | 配置系统菜单、操作权限、按钮权限标识等                        | 是             | 是                 |
| 角色管理     | 角色菜单权限分配、设置角色按机构进行数据范围权限划分          | 是             | 是                 |
| 字典管理     | 对系统中经常使用的一些较为固定的数据进行维护                  | 是             | 是                 |
| 参数管理     | 对系统动态配置常用参数                                        | 是             | 是                 |
| 通知公告     | 系统通知公告信息发布维护                                      | 仅支持查看     | 是                 |
| 操作日志     | 系统正常操作日志记录和查询 系统异常信息日志记录和查询         | 是             | 是                 |
| 登录日志     | 系统登录日志记录查询包含登录异常                              | 是             | 是                 |
| 文件管理     | 系统文件展示、上传、下载、删除等管理                          | 是             | 是                 |
| 文件配置管理 | 系统文件上传、下载所需要的配置信息动态添加、修改、删除等管理  | 是             | 是                 |
| 在线用户管理 | 已登录系统的在线用户信息监控与强制踢出操作                    | 是             | 是                 |
| 代码生成     | 多数据源前后端代码的生成（java、html、xml、sql）支持CRUD下载  | 否             | 否                 |
| 缓存监控     | 对系统的缓存信息查询，命令统计等。                            | 是             | 是                 |
| 服务监控     | 监视集群系统CPU、内存、磁盘、堆栈、在线日志、Spring相关配置等 | 否             | 否                 |
| 定时任务     | 运行报表、任务管理(添加、修改、删除)、日志管理、执行器管理等  | 否             | 否                 |
| 在线构建器   | 拖动表单元素生成相应的Flutter代码。                           | 否             | 否                 |
| WebView      | App内打开网页                                                 | 是             | 是                 |
| 使用案例     | 系统的一些功能案例                                            | 是             | 是                 |
| 工作流       | 系统工作流模块业务功能                                        | 否             | 是                 |
| 我的任务     | 系统我的任务模块业务功能                                      | 否             | 是                 |

## 📖 开发指南

### 批量执行脚本

本项目提供了完整的批量执行脚本，支持 macOS、Linux 和 Windows：

```bash
# 获取所有模块依赖
./scripts/pub_get_all.sh         # macOS/Linux
scripts\pub_get_all.bat          # Windows

# 生成国际化文件
./scripts/gen_l10n_all.sh        # macOS/Linux
scripts\gen_l10n_all.bat         # Windows

# 代码生成（Retrofit、JsonSerializable）
./scripts/build_runner_all.sh    # macOS/Linux
scripts\build_runner_all.bat     # Windows

# 清理构建产物
./scripts/clean_all.sh           # macOS/Linux
scripts\clean_all.bat            # Windows
```

📚 **详细使用说明**: [scripts/README.md](scripts/README.md)

### 添加新模块

1. 在对应目录下创建新模块
2. 在根目录 `pubspec.yaml` 的 `workspace:` 中添加模块路径
3. 运行 `./scripts/pub_get_all.sh` 初始化

### 代码规范

- 遵循 [Effective Dart](https://dart.dev/guides/language/effective-dart) 规范
- 使用 `flutter analyze` 检查代码质量
- 使用 `dart format .` 格式化代码

## 🤝 参与贡献

欢迎提交 Issue 和 Pull Request！

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交您的更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 提交 Pull Request

## 📄 开源协议

本项目基于 MIT 协议开源

## 💖 捐献作者
感谢每一位支持者的慷慨相助！您的每一份贡献都是对我莫大的鼓励。

|                                                                          |                                                                           |
|--------------------------------------------------------------------------|---------------------------------------------------------------------------|
| ![输入图片说明](screenshot/94e00d3610816730d689567fe904464c_origin.png '微信收款') | ![输入图片说明](screenshot/5ede006d8b15ba913588e66ed89fd68a_origin.jpg '支付宝收款') |

## 演示图例

|                                                                                            |                                                                                            |                                                                                                |
|--------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------|
| ![输入图片说明](screenshot/Screenshot_20250321_114430_android.slc.ruoyi_plus_flutter.jpg '屏幕截图') | ![输入图片说明](screenshot/Screenshot_20250321_114446_android.slc.ruoyi_plus_flutter.jpg '屏幕截图') | ![输入图片说明](screenshot/Screenshot_20250321_114500_android.slc.ruoyi_plus_flutter.jpg '屏幕截图') | 
| ![输入图片说明](screenshot/Screenshot_20250321_114507_android.slc.ruoyi_plus_flutter.jpg '屏幕截图') | ![输入图片说明](screenshot/Screenshot_20250321_114513_android.slc.ruoyi_plus_flutter.jpg '屏幕截图') | ![输入图片说明](screenshot/Screenshot_20250321_114520_android.slc.ruoyi_plus_flutter.jpg '屏幕截图') |
| ![输入图片说明](screenshot/Screenshot_20250321_114527_android.slc.ruoyi_plus_flutter.jpg '屏幕截图') | ![输入图片说明](screenshot/Screenshot_20250321_114534_android.slc.ruoyi_plus_flutter.jpg '屏幕截图') | ![输入图片说明](screenshot/Screenshot_20250321_114540_android.slc.ruoyi_plus_flutter.jpg '屏幕截图') |
| ![输入图片说明](screenshot/Screenshot_20250321_114544_android.slc.ruoyi_plus_flutter.jpg '屏幕截图') | ![输入图片说明](screenshot/Screenshot_20250321_114551_android.slc.ruoyi_plus_flutter.jpg '屏幕截图') | ![输入图片说明](screenshot/Screenshot_20250321_114556_android.slc.ruoyi_plus_flutter.jpg '屏幕截图') |
| ![输入图片说明](screenshot/Screenshot_20250321_114603_android.slc.ruoyi_plus_flutter.jpg '屏幕截图') | ![输入图片说明](screenshot/Screenshot_20250321_114618_android.slc.ruoyi_plus_flutter.jpg '屏幕截图') | ![输入图片说明](screenshot/Screenshot_20250321_114639_android.slc.ruoyi_plus_flutter.jpg '屏幕截图') |
| ![输入图片说明](screenshot/Screenshot_20250321_114647_android.slc.ruoyi_plus_flutter.jpg '屏幕截图') | ![输入图片说明](screenshot/Screenshot_20250321_114656_android.slc.ruoyi_plus_flutter.jpg '屏幕截图') | ![输入图片说明](screenshot/Screenshot_20250321_114707_android.slc.ruoyi_plus_flutter.jpg '屏幕截图') |
| ![输入图片说明](screenshot/Screenshot_20250321_114711_android.slc.ruoyi_plus_flutter.jpg '屏幕截图') | ![输入图片说明](screenshot/Screenshot_20250321_115955_android.slc.ruoyi_plus_flutter.jpg '屏幕截图') | ![输入图片说明](screenshot/Screenshot_20250321_114917_android.slc.ruoyi_plus_flutter.jpg '屏幕截图') |
| ![输入图片说明](screenshot/Screenshot_20250321_114923_android.slc.ruoyi_plus_flutter.jpg '屏幕截图') |
