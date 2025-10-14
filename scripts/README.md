# Flutter Workspace 批量执行脚本

## 💻 跨平台支持

本脚本支持所有主流操作系统：
- ✅ **macOS** - 使用 `.sh` 脚本
- ✅ **Linux** - 使用 `.sh` 脚本  
- ✅ **Windows** - 使用 `.bat` 脚本

## 🎯 快速开始

### macOS / Linux

```bash
# 基本用法
./scripts/run_all.sh "<你的命令>"

# 或使用快捷脚本
./scripts/pub_get_all.sh
./scripts/gen_l10n_all.sh
./scripts/build_runner_all.sh
```

### Windows

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

**用法：**

macOS/Linux:
```bash
./scripts/run_all.sh "flutter pub get"
./scripts/run_all.sh "flutter analyze"
./scripts/run_all.sh "dart format ."
```

Windows:
```cmd
scripts\run_all.bat "flutter pub get"
scripts\run_all.bat "flutter analyze"
scripts\run_all.bat "dart format ."
```

### 快捷脚本

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

## 💡 常见场景

### 完整构建流程

**macOS/Linux:**
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

**Windows:**
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

**macOS/Linux:**
```bash
# 分析所有模块
./scripts/run_all.sh "flutter analyze"

# 格式化所有代码
./scripts/run_all.sh "dart format ."

# 运行测试
./scripts/run_all.sh "flutter test"
```

**Windows:**
```cmd
REM 分析所有模块
scripts\run_all.bat "flutter analyze"

REM 格式化所有代码
scripts\run_all.bat "dart format ."

REM 运行测试
scripts\run_all.bat "flutter test"
```

### 依赖管理

**macOS/Linux:**
```bash
# 检查过时的依赖
./scripts/run_all.sh "flutter pub outdated"

# 升级依赖
./scripts/run_all.sh "flutter pub upgrade"
```

**Windows:**
```cmd
REM 检查过时的依赖
scripts\run_all.bat "flutter pub outdated"

REM 升级依赖
scripts\run_all.bat "flutter pub upgrade"
```

## 🔧 自定义

### 创建新的快捷脚本

**macOS/Linux:**

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

**Windows:**

1. 复制模板：
```cmd
copy scripts\pub_get_all.bat scripts\my_command.bat
```

2. 编辑命令：
```cmd
@echo off
"%~dp0run_all.bat" "你的命令"
```

### 执行多个命令

```bash
./scripts/run_all.sh "flutter pub get && flutter gen-l10n"
```

### 条件执行

```bash
# 只在有 l10n.yaml 的模块执行
./scripts/run_all.sh "[ -f l10n.yaml ] && flutter gen-l10n || true"
```

## 🐛 故障排除

### 权限问题 (macOS/Linux)
```bash
chmod +x scripts/*.sh
```

### 查看详细执行过程

**macOS/Linux:**
```bash
bash -x scripts/run_all.sh "flutter pub get"
```

**Windows:**
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

## 🎓 工作原理

```
run_all.sh 脚本流程:
1. 解析 pubspec.yaml 的 workspace 配置
2. 提取所有模块路径
3. 首先在根目录执行命令
4. 依次进入每个模块目录
5. 执行指定命令
6. 收集执行结果
7. 显示统计摘要
```

## 🤝 贡献

如果您创建了有用的脚本，欢迎添加到 `scripts/` 目录！

---

**提示**：更多使用示例请参考项目根目录的 `CMD.md` 文件。

