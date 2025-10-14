# Mix - 原生混合功能模块

> **Workspace 模块** | 路径: `feature/mix`

## 📦 模块概述

Mix 模块提供 Flutter 与原生平台（Android/iOS）交互的相关功能。当 Flutter 模块作为原生应用的一部分集成时，该模块提供 UI 刷新机制和消息传递功能，实现 Flutter 与原生代码的双向通信。

## ✨ 主要功能

### 📱 原生集成支持
- **混合开发模式** - 支持 Flutter 作为原生应用的一部分集成
- **生命周期管理** - 处理 Flutter 模块的生命周期事件

### 🔄 双向通信
- **Flutter → 原生** - Flutter 调用原生代码
- **原生 → Flutter** - 原生代码触发 Flutter 刷新和更新

### 🎯 UI 刷新机制
- **消息通道** - 基于 MethodChannel 的消息传递
- **状态同步** - 原生和 Flutter 状态同步
- **事件分发** - 事件监听和分发机制

## 🔗 依赖关系

**依赖的 workspace 模块：**
- `base` - 基础核心模块

**主要功能：**
- `MethodChannel` - Flutter 平台通道
- `EventChannel` - 事件通道

## 📖 代码参考

查看具体实现：
- **混合功能**: `lib/mix/` 目录下的相关文件

## 🎯 适用场景

1. **原生应用集成 Flutter** - 在现有原生应用中集成 Flutter 模块
2. **混合开发** - Flutter 和原生代码协同开发
3. **特定功能模块** - 将 Flutter 作为特定功能模块嵌入原生应用
4. **渐进式迁移** - 逐步将原生应用迁移到 Flutter

## 🚀 使用方式

在根目录 `pubspec.yaml` 中已配置为 workspace 成员，其他模块可直接引用：

```yaml
dependencies:
  mix:  # 自动使用 workspace 版本
```

## 📝 开发命令

```bash
# 进入模块目录
cd feature/mix

# 获取依赖
flutter pub get
```

**或使用项目根目录的批量脚本：**

```bash
./scripts/pub_get_all.sh       # 所有模块获取依赖
```

## 🏗️ 模块结构

```
mix/
├── lib/
│   └── mix/                     # 混合功能
│       ├── channels/            # 平台通道
│       ├── handlers/            # 消息处理
│       └── utils/               # 工具类
└── pubspec.yaml                 # 模块配置
```

## 🔄 与其他模块的关系

```
mix (本模块)
 ├─ 被依赖: biz_main (可选)
 ├─ 依赖: base
 └─ 作用: 提供 Flutter 与原生平台的交互能力
```

## 💡 使用说明

- 该模块主要用于混合开发场景
- 如果应用纯 Flutter 开发，可不引用此模块
- 支持 Android 和 iOS 平台

---

*本模块是 Flutter Workspace 架构的一部分，依赖版本统一在根目录 `pubspec.yaml` 管理。*
