# Flutter Workspace 批量执行脚本

## 💻 跨平台支持

本项目提供了跨平台的批量执行脚本，支持：
- ✅ **macOS / Linux** - 使用 `.sh` 脚本
- ✅ **Windows** - 使用 `.bat` 脚本

**自动选择**：根据你的操作系统使用对应的脚本即可！

## 🚀 快速开始

### 基本用法

#### macOS / Linux

```bash
# 基本用法
./scripts/run_all.sh "<你的命令>"

# 或使用快捷脚本
./scripts/pub_get_all.sh
./scripts/gen_l10n_all.sh
./scripts/build_runner_all.sh
```

#### Windows

```cmd
REM 基本用法
scripts\run_all.bat "你的命令"

REM 或使用快捷脚本
scripts\pub_get_all.bat
scripts\gen_l10n_all.bat
scripts\build_runner_all.bat
```

## 📜 脚本列表

### 核心脚本

**`run_all.sh` / `run_all.bat`** - 通用批量执行脚本
- 自动从 `pubspec.yaml` 读取 workspace 配置
- 对所有模块（包括根目录）执行指定命令
- 支持任意 Flutter/Dart 命令
- 彩色输出（Bash版本），清晰的状态提示

### 快捷脚本（推荐）

这些脚本会**自动**读取 `pubspec.yaml` 中的 workspace 配置，对所有模块（包括根目录）执行命令。
**新增模块无需修改脚本**，自动生效！

**`pub_get_all`** - 批量执行 `flutter pub get`

macOS/Linux: `./scripts/pub_get_all.sh`  
Windows: `scripts\pub_get_all.bat`

**`gen_l10n_all`** - 批量生成国际化文件

macOS/Linux: `./scripts/gen_l10n_all.sh`  
Windows: `scripts\gen_l10n_all.bat`

**`build_runner_all`** - 批量执行代码生成

macOS/Linux: `./scripts/build_runner_all.sh`  
Windows: `scripts\build_runner_all.bat`

**`clean_all`** - 批量清理

macOS/Linux: `./scripts/clean_all.sh`  
Windows: `scripts\clean_all.bat`

### 通用命令

#### macOS / Linux

```bash
# 自定义命令（适用于任何 Flutter/Dart 命令）
./scripts/run_all.sh "你的命令"

# 示例：
./scripts/run_all.sh "flutter analyze"
./scripts/run_all.sh "flutter test"
./scripts/run_all.sh "dart format ."
```

#### Windows

```cmd
REM 自定义命令（适用于任何 Flutter/Dart 命令）
scripts\run_all.bat "你的命令"

REM 示例：
scripts\run_all.bat "flutter analyze"
scripts\run_all.bat "flutter test"
scripts\run_all.bat "dart format ."
```

## 🌟 特性

### ✅ 自动发现模块
脚本会自动从根目录的 `pubspec.yaml` 读取 `workspace:` 配置，无需手动维护模块列表。

**示例 pubspec.yaml：**
```yaml
workspace:
  - base
  - lib_module/fast
  - feature/auth
  # 新增模块，脚本自动识别！
  - feature/new_module
```

### ✅ 智能跳过
- 自动跳过不存在的目录
- 自动跳过没有 `pubspec.yaml` 的目录
- 失败时继续执行其他模块

### ✅ 详细报告
```
========================================
执行完成
========================================
总模块数: 12
成功: 13 (包含根目录)
失败: 0
跳过: 0
```

### ✅ 彩色输出
- 🔵 蓝色：标题和摘要
- 🟢 绿色：成功信息
- 🟡 黄色：警告和跳过
- 🔴 红色：错误信息

## 📦 当前 Workspace 模块

脚本会自动处理以下模块（从 pubspec.yaml 读取）：

```
根目录
├── base
├── lib_module/
│   ├── fast
│   ├── form_extra
│   └── db_base
├── feature/
│   ├── mix
│   ├── component
│   ├── auth
│   ├── welcome
│   └── bizapi
└── business/
    ├── user
    ├── system
    └── biz_main
```

**添加新模块时**：只需在根 `pubspec.yaml` 的 `workspace:` 中添加路径即可！

## 💡 常见场景

### 完整构建流程

#### macOS/Linux

```bash
# 1. 清理
./scripts/clean_all.sh

# 2. 获取依赖
./scripts/pub_get_all.sh

# 3. 生成国际化
./scripts/gen_l10n_all.sh

# 4. 生成代码
./scripts/build_runner_all.sh

# 或一行执行
./scripts/clean_all.sh && ./scripts/pub_get_all.sh && ./scripts/gen_l10n_all.sh && ./scripts/build_runner_all.sh
```

#### Windows

```cmd
REM 1. 清理
scripts\clean_all.bat

REM 2. 获取依赖
scripts\pub_get_all.bat

REM 3. 生成国际化
scripts\gen_l10n_all.bat

REM 4. 生成代码
scripts\build_runner_all.bat

REM 或一行执行
scripts\clean_all.bat && scripts\pub_get_all.bat && scripts\gen_l10n_all.bat && scripts\build_runner_all.bat
```

### 代码质量检查

#### macOS/Linux

```bash
# 分析所有模块
./scripts/run_all.sh "flutter analyze"

# 格式化所有代码
./scripts/run_all.sh "dart format ."

# 运行测试
./scripts/run_all.sh "flutter test"
```

#### Windows

```cmd
REM 分析所有模块
scripts\run_all.bat "flutter analyze"

REM 格式化所有代码
scripts\run_all.bat "dart format ."

REM 运行测试
scripts\run_all.bat "flutter test"
```

### 依赖管理

#### macOS/Linux

```bash
# 检查过时的依赖
./scripts/run_all.sh "flutter pub outdated"

# 升级依赖
./scripts/run_all.sh "flutter pub upgrade"
```

#### Windows

```cmd
REM 检查过时的依赖
scripts\run_all.bat "flutter pub outdated"

REM 升级依赖
scripts\run_all.bat "flutter pub upgrade"
```

## 📝 单模块命令

如果只想对某个模块执行命令：

```bash
# 根目录
flutter pub get
flutter gen-l10n
dart run build_runner build

# 指定模块
cd base && flutter pub get
cd lib_module/fast && flutter gen-l10n
cd business/user && dart run build_runner build
```

## 🔧 自定义

### 创建新的快捷脚本

#### macOS/Linux

1. 复制模板：
```bash
cp scripts/pub_get_all.sh scripts/my_command.sh
```

2. 编辑命令：
```bash
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"$SCRIPT_DIR/run_all.sh" "你的命令"
```

3. 添加执行权限：
```bash
chmod +x scripts/my_command.sh
```

#### Windows

1. 复制模板：
```cmd
copy scripts\pub_get_all.bat scripts\my_command.bat
```

2. 编辑命令：
```cmd
@echo off
"%~dp0run_all.bat" "你的命令"
```

### 高级用法

#### 组合命令

**macOS / Linux:**
```bash
# 清理后重新获取依赖
./scripts/clean_all.sh && ./scripts/pub_get_all.sh

# 完整的代码生成流程
./scripts/pub_get_all.sh && ./scripts/gen_l10n_all.sh && ./scripts/build_runner_all.sh
```

**Windows:**
```cmd
REM 清理后重新获取依赖
scripts\clean_all.bat && scripts\pub_get_all.bat

REM 完整的代码生成流程
scripts\pub_get_all.bat && scripts\gen_l10n_all.bat && scripts\build_runner_all.bat
```

#### 条件执行

```bash
# 只对有 l10n.yaml 的模块执行
./scripts/run_all.sh "[ -f l10n.yaml ] && flutter gen-l10n || echo 'Skip: no l10n.yaml'"
```

#### 执行多个命令

```bash
./scripts/run_all.sh "flutter pub get && flutter gen-l10n"
```

#### 调试模式

```bash
# 添加 -x 查看详细执行过程
bash -x ./scripts/run_all.sh "flutter pub get"
```

## 🛠️ 工作原理

`run_all.sh` 脚本会：
1. 自动从根 `pubspec.yaml` 读取 `workspace:` 配置
2. 提取所有模块路径
3. 依次进入每个模块目录执行命令
4. 显示执行结果和统计信息

**优势：**
- ✅ 自动发现模块，新增模块无需修改脚本
- ✅ 彩色输出，清晰显示执行状态
- ✅ 错误处理，失败时显示详细信息
- ✅ 执行统计，显示成功/失败/跳过数量

## 🔧 脚本目录结构

```
scripts/
├── run_all.sh           # 核心脚本 (macOS/Linux)
├── run_all.bat          # 核心脚本 (Windows)
├── pub_get_all.sh       # 快捷方式：pub get (macOS/Linux)
├── pub_get_all.bat      # 快捷方式：pub get (Windows)
├── gen_l10n_all.sh      # 快捷方式：gen-l10n (macOS/Linux)
├── gen_l10n_all.bat     # 快捷方式：gen-l10n (Windows)
├── build_runner_all.sh  # 快捷方式：build_runner (macOS/Linux)
├── build_runner_all.bat # 快捷方式：build_runner (Windows)
├── clean_all.sh         # 快捷方式：clean (macOS/Linux)
├── clean_all.bat        # 快捷方式：clean (Windows)
└── README.md            # 详细说明文档
```

## 🐛 故障排除

### 权限问题 (macOS/Linux)
```bash
chmod +x scripts/*.sh
```

### 查看详细执行过程

#### macOS/Linux
```bash
bash -x scripts/run_all.sh "flutter pub get"
```

#### Windows
```cmd
REM 在脚本第二行添加 @echo on 可以看到详细执行过程
```

### 单独测试某个命令
```bash
# 只执行根目录
flutter pub get

# 只执行某个模块
cd base && flutter pub get
```

## 📝 注意事项

1. **在根目录执行**：所有脚本都应该在项目根目录执行
2. **命令需要引号**：多个单词的命令需要用引号包裹
3. **失败不中断**：某个模块失败不会影响其他模块
4. **相对路径**：脚本使用相对路径，可以重命名项目目录

## ❓ 常见问题

**Q: 为什么要用这些脚本？**  
A: 在 Workspace 模式下，根目录执行命令**不会自动**递归到子模块，需要手动对每个模块执行。

**Q: 新增模块后需要修改脚本吗？**  
A: **不需要**！脚本会自动从 `pubspec.yaml` 读取 workspace 配置。

**Q: 如果某个模块执行失败怎么办？**  
A: 脚本会继续执行其他模块，最后显示失败统计。可以根据红色错误信息定位问题。

**Q: 能否跳过某些模块？**  
A: 可以！修改对应模块的 `pubspec.yaml`，临时移除需要的命令配置（如删除 `l10n.yaml`），脚本会自动跳过。

## 🤝 贡献

如果您创建了有用的脚本，欢迎添加到 `scripts/` 目录！