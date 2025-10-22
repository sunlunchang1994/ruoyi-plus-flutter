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
# 常用快捷脚本
./scripts/pub_get_all.sh        # 获取所有依赖
./scripts/gen_l10n_all.sh       # 生成国际化文件
./scripts/build_runner_all.sh   # 执行代码生成
./scripts/clean_all.sh          # 清理所有模块

# 基本用法（自定义命令）
./scripts/run_all.sh "<你的命令>"
```

#### Windows

```cmd
REM 常用快捷脚本
scripts\pub_get_all.bat         REM 获取所有依赖
scripts\gen_l10n_all.bat        REM 生成国际化文件
scripts\build_runner_all.bat    REM 执行代码生成
scripts\clean_all.bat           REM 清理所有模块

REM 基本用法（自定义命令）
scripts\run_all.bat "你的命令"
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

## 📦 打包应用

### 打包脚本

所有打包脚本都会自动执行完整的清理和构建流程，确保打包包含最新的代码更改。

**脚本列表：**

| 平台 | macOS/Linux 脚本 | Windows 脚本 | 输出路径 |
|------|-----------------|-------------|---------|
| Android APK | `./scripts/build_apk.sh` | `scripts\build_apk.bat` | `build/app/outputs/flutter-apk/app-release.apk` |
| Web 应用 | `./scripts/build_web.sh` | `scripts\build_web.bat` | `build/web/` |
| Windows 桌面 | `./scripts/build_windows.sh` | `scripts\build_windows.bat` | `build/windows/x64/runner/Release/` |
| macOS 桌面 | `./scripts/build_macos.sh` | - | `build/macos/Build/Products/Release/*.app` |
| Linux 桌面 | `./scripts/build_linux.sh` | - | `build/linux/x64/release/bundle/` |

### 使用方法

#### macOS/Linux

```bash
# 打包移动端
./scripts/build_apk.sh      # Android APK

# 打包 Web
./scripts/build_web.sh       # Web 应用

# 打包桌面应用
./scripts/build_windows.sh   # Windows 桌面应用
./scripts/build_macos.sh     # macOS 桌面应用
./scripts/build_linux.sh     # Linux 桌面应用
```

#### Windows

```cmd
REM 打包移动端
scripts\build_apk.bat        REM Android APK

REM 打包 Web
scripts\build_web.bat         REM Web 应用

REM 打包桌面应用
scripts\build_windows.bat     REM Windows 桌面应用
```

### 打包流程说明

**交互式选择：**

所有打包脚本在执行前会**先询问**你是否需要执行以下可选步骤，并提供详细的提示信息帮助你做出选择：

```
========================================
可选步骤配置
========================================
是否需要清理所有子模块？
  提示: 只清理根目录通常已足够，清理所有子模块会花费更多时间
  (y/n，默认n): 

是否需要生成国际化文件？
  提示: 如果项目中已存在国际化文件且未修改，可跳过此步骤以加快打包速度
  (y/n，默认y): 

是否需要执行代码生成 (build_runner)？
  提示: 如果项目中已存在生成的代码且未修改相关注解，可跳过此步骤
  (y/n，默认y): 
```

**执行流程：**

> ⚠️ **重要**：打包会自动执行以下步骤，确保打包包含最新的代码更改：
> 
> **询问阶段（在执行前配置）：**
> - 💬 询问是否清理所有子模块（默认只清理根目录）
> - 💬 询问是否生成国际化文件
> - 💬 询问是否执行代码生成
>
> **执行阶段：**
> 1. ✅ **清理缓存** - **必须**
>    - 选择 `n`（默认）：只清理根目录 - **推荐，速度快**
>    - 选择 `y`：清理所有模块（根目录 + 子模块）- **完整清理，较慢**
> 2. ✅ **获取依赖** - **必须**
>    - 选择 `n`（默认）：只获取根目录依赖 - **快速**
>    - 选择 `y`：获取所有模块依赖（`pub_get_all`）- **完整**
> 3. ⚠️ 生成国际化文件（`gen_l10n_all`）- **根据你的选择执行或跳过**
> 4. ⚠️ 执行代码生成（`build_runner_all`）- **根据你的选择执行或跳过**
> 5. ✅ 打包应用（`flutter build`）- **必须**
>
> 💡 **提示**：
> - **清理子模块**：默认为 `n`，只清理根目录通常已足够
> - **获取依赖**：自动根据清理选择智能执行
>   - 如果选择清理子模块（`y`）：会对所有模块执行 `pub get`
>   - 如果不清理子模块（`n`）：只对根目录执行 `pub get`
> - **国际化和代码生成**：默认为 `y`，直接按回车执行
> - 如果输入 `n`，会跳过对应步骤以加快打包速度
> - 这是因为 Flutter 的构建缓存机制可能导致打包时不包含最新的代码更改

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
├── build_apk.sh         # 一键打包 Android APK (macOS/Linux) ⭐
├── build_apk.bat        # 一键打包 Android APK (Windows) ⭐
├── build_web.sh         # 一键打包 Web (macOS/Linux) ⭐
├── build_web.bat        # 一键打包 Web (Windows) ⭐
├── build_windows.sh     # 一键打包 Windows 桌面 (macOS/Linux) ⭐
├── build_windows.bat    # 一键打包 Windows 桌面 (Windows) ⭐
├── build_macos.sh       # 一键打包 macOS 桌面 (macOS/Linux) ⭐
├── build_linux.sh       # 一键打包 Linux 桌面 (macOS/Linux) ⭐
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

**Q: 为什么打包前需要 clean？** ⭐  
A: **这是 Flutter 构建缓存的已知问题**。如果不执行 `flutter clean`，打包后的应用可能不包含最新的代码更改。原因是：
- Flutter 的增量编译会缓存之前的构建结果
- 某些代码生成的文件（如国际化、build_runner生成的代码）可能使用旧缓存
- 资源文件的更新可能不被正确识别

**解决方案**：使用打包脚本（`build_apk.sh` / `build_web.sh` / `build_windows.sh` 等），它们会自动：
1. ✅ 清理所有模块的构建缓存
2. ✅ 重新获取依赖
3. ⚠️ 重新生成国际化文件（可选，失败不中断）
4. ⚠️ 重新执行代码生成（可选，失败不中断）
5. ✅ 确保打包包含最新代码

**手动打包（不推荐）**：
```bash
# 如果要手动打包，请务必先执行：
./scripts/clean_all.sh
./scripts/pub_get_all.sh
./scripts/gen_l10n_all.sh      # 可选
./scripts/build_runner_all.sh  # 可选
# 然后再打包
flutter build apk --release      # Android
flutter build web --release      # Web
flutter build windows --release  # Windows
flutter build macos --release    # macOS
flutter build linux --release    # Linux
```

**Q: 步骤3和步骤4为什么是可选的？**  
A: 国际化文件生成（gen-l10n）和代码生成（build_runner）是可选步骤，原因是：
- 如果项目中已经存在这些生成的文件，重新生成不是必须的
- 某些模块可能没有配置国际化或代码生成
- 即使这两步失败，也不应该阻止打包流程
- 脚本会显示警告但继续执行，让你知道发生了什么

**Q: 打包时如何配置清理和可选步骤？**  
A: 所有打包脚本在执行前会**交互式询问**并提供详细的提示信息：

```bash
========================================
可选步骤配置
========================================
是否需要清理所有子模块？
  提示: 只清理根目录通常已足够，清理所有子模块会花费更多时间
  (y/n，默认n): n    # 默认只清理根目录（推荐）

是否需要生成国际化文件？
  提示: 如果项目中已存在国际化文件且未修改，可跳过此步骤以加快打包速度
  (y/n，默认y):      # 直接回车执行（默认）

是否需要执行代码生成 (build_runner)？
  提示: 如果项目中已存在生成的代码且未修改相关注解，可跳过此步骤
  (y/n，默认y):      # 直接回车执行（默认）
```

**选择说明：**
- 输入 `y` 或直接回车：执行该步骤
- 输入 `n`：跳过该步骤

**什么时候可以跳过？**
- **清理子模块**：通常只清理根目录就够了，除非子模块有更新
  - 💡 选择不清理子模块（`n`）时，会自动跳过子模块的 `pub get`，进一步加快速度
- **国际化文件**：如果你没有修改 `l10n.yaml` 或 `.arb` 文件
- **代码生成**：如果你没有修改使用了注解的代码（如 `@JsonSerializable`、`@freezed` 等）

**快速打包推荐配置：**
```
清理子模块: n (默认)  ← 只清理根目录，自动跳过子模块pub get
国际化文件: n         ← 如已存在，跳过
代码生成:   n         ← 如已存在，跳过
```
这样可以显著加快打包速度！⚡

**完整打包配置（首次或子模块有更新）：**
```
清理子模块: y         ← 清理所有模块，自动对所有模块执行pub get
国际化文件: (回车)    ← 执行（默认）
代码生成:   (回车)    ← 执行（默认）
```

**Q: 支持哪些平台的打包？**  
A: 支持 Flutter 的所有主流平台：
- 📱 **移动端**: Android APK (`build_apk`)
- 🌐 **Web**: Web 应用 (`build_web`)
- 🖥️ **桌面端**: Windows (`build_windows`)、macOS (`build_macos`)、Linux (`build_linux`)

注意：
- iOS 打包需要 macOS 系统和 Xcode，暂不提供脚本（可以手动执行 `flutter build ios`）
- Windows 桌面打包需要 Windows 环境或配置了交叉编译
- macOS 桌面打包需要 macOS 系统

## 🤝 贡献

如果您创建了有用的脚本，欢迎添加到 `scripts/` 目录！