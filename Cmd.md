# Flutter Workspace 批量命令

## 💻 跨平台支持

本项目提供了跨平台的批量执行脚本，支持：
- ✅ **macOS / Linux** - 使用 `.sh` 脚本
- ✅ **Windows** - 使用 `.bat` 脚本

**自动选择**：根据你的操作系统使用对应的脚本即可！

## 🚀 快捷命令（推荐）

这些脚本会**自动**读取 `pubspec.yaml` 中的 workspace 配置，对所有模块（包括根目录）执行命令。
**新增模块无需修改脚本**，自动生效！

### macOS / Linux

```bash
# 所有模块执行 pub get
./scripts/pub_get_all.sh

# 所有模块生成国际化文件
./scripts/gen_l10n_all.sh

# 所有模块执行 build_runner
./scripts/build_runner_all.sh

# 所有模块执行 clean
./scripts/clean_all.sh
```

### Windows

```cmd
REM 所有模块执行 pub get
scripts\pub_get_all.bat

REM 所有模块生成国际化文件
scripts\gen_l10n_all.bat

REM 所有模块执行 build_runner
scripts\build_runner_all.bat

REM 所有模块执行 clean
scripts\clean_all.bat
```

### 通用命令

**macOS / Linux:**
```bash
# 自定义命令（适用于任何 Flutter/Dart 命令）
./scripts/run_all.sh "你的命令"

# 示例：
./scripts/run_all.sh "flutter analyze"
./scripts/run_all.sh "flutter test"
./scripts/run_all.sh "dart format ."
```

**Windows:**
```cmd
REM 自定义命令（适用于任何 Flutter/Dart 命令）
scripts\run_all.bat "你的命令"

REM 示例：
scripts\run_all.bat "flutter analyze"
scripts\run_all.bat "flutter test"
scripts\run_all.bat "dart format ."
```

---

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

---

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

---

## 📦 当前 Workspace 模块

脚本会自动识别以下模块（从 `pubspec.yaml` 读取）：
- base
- lib_module/fast
- lib_module/form_extra
- lib_module/db_base
- feature/mix
- feature/component
- feature/auth
- feature/welcome
- feature/bizapi
- business/user
- business/system
- business/biz_main

**添加新模块时**：只需在根 `pubspec.yaml` 的 `workspace:` 中添加路径即可！

---

## 💡 高级用法

### 组合命令

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

### 条件执行
```bash
# 只对有 l10n.yaml 的模块执行
./scripts/run_all.sh "[ -f l10n.yaml ] && flutter gen-l10n || echo 'Skip: no l10n.yaml'"
```

### 调试模式
```bash
# 添加 -x 查看详细执行过程
bash -x ./scripts/run_all.sh "flutter pub get"
```

---

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

---

## ❓ 常见问题

**Q: 为什么要用这些脚本？**  
A: 在 Workspace 模式下，根目录执行命令**不会自动**递归到子模块，需要手动对每个模块执行。

**Q: 新增模块后需要修改脚本吗？**  
A: **不需要**！脚本会自动从 `pubspec.yaml` 读取 workspace 配置。

**Q: 如果某个模块执行失败怎么办？**  
A: 脚本会继续执行其他模块，最后显示失败统计。可以根据红色错误信息定位问题。

**Q: 能否跳过某些模块？**  
A: 可以！修改对应模块的 `pubspec.yaml`，临时移除需要的命令配置（如删除 `l10n.yaml`），脚本会自动跳过。
