# Form Extra - 表单扩展库

> **Workspace 模块** | 路径: `lib_module/form_extra`

## 📦 模块概述

Form Extra 模块是基于 `flutter_form_builder` 的表单组件扩展库，提供了增强的表单组件和功能，简化表单开发流程，提供更丰富的表单交互体验。

## ✨ 主要功能

### 📝 增强表单组件
- **扩展字段类型** - 在 flutter_form_builder 基础上提供更多字段类型
- **自定义验证器** - 提供常用的表单验证规则
- **主题定制** - 统一的表单样式和主题
- **国际化支持** - 内置多语言支持

### 🎨 定制化组件
- **日期时间选择器** - 增强的日期时间选择组件
- **下拉选择器** - 支持单选、多选的下拉组件
- **文件上传** - 集成文件选择和上传功能
- **富文本编辑器** - 支持富文本内容编辑

### ✅ 表单验证
- **内置验证规则** - 常用验证规则（必填、邮箱、手机号等）
- **自定义验证** - 支持自定义验证逻辑
- **实时验证** - 支持实时和提交时验证
- **错误提示** - 友好的错误信息展示

### 🔄 数据绑定
- **双向绑定** - 表单字段与数据模型的双向绑定
- **初始化值** - 便捷的表单初始值设置
- **数据转换** - 自动处理数据类型转换

## 🔗 依赖关系

**依赖的 workspace 模块：**
- `fast` - 快速开发工具

**主要第三方依赖：**
- `flutter_form_builder` - 表单构建器
- `form_builder_validators` - 表单验证器
- `intl` - 国际化支持

## 📖 使用示例

### FormBuilder 表单使用示例

查看业务模块中如何使用表单组件：

- **字典数据编辑表单**: `business/system/lib/system/ui/dict/data/dict_data_add_edit_page.dart`
  - 使用 `FormBuilder` 构建表单
  - 使用 `MyFormBuilderTextField` 创建文本字段
  - 使用 `FormBuilderValidators.required()` 进行必填验证
  - 表单数据绑定和提交

- **字典类型编辑表单**: `business/system/lib/system/ui/dict/type/dict_type_add_edit_page.dart`
  - 使用 `FormBuilder` 管理表单状态
  - 使用 `MyFormBuilderTextField` 实现字段输入
  - 使用验证器组合进行多重验证

- **参数配置编辑表单**: `business/system/lib/system/ui/config/config_add_edit_page.dart`
  - 使用 `FormBuilder` 构建配置表单
  - 使用 `autovalidateMode` 设置验证时机
  - 使用 `onChanged` 监听字段变化

- **菜单编辑表单**: `business/system/lib/system/ui/menu/menu_add_edit_page.dart`
  - 使用 `FormBuilder` 构建复杂表单
  - 动态表单字段展示
  - 表单数据的保存和提交

- **在线用户搜索表单**: `business/system/lib/system/ui/monitor/online/user_online_list_page_vd.dart`
  - 使用 `FormBuilder` 构建搜索表单
  - 结合 `FormOperateWithProvider` 管理表单操作
  - 表单重置和提交功能

- **通知公告编辑表单**: `business/system/lib/system/ui/notice/notice_add_edit_page.dart`
  - 使用 `FormBuilder` 构建公告表单
  - 多种字段类型的综合使用

- **OSS配置编辑表单**: `business/system/lib/system/ui/oss/config/oss_config_add_edit_page.dart`
  - 使用 `FormBuilder` 构建OSS配置表单

- **客户端管理表单**: `business/system/lib/system/ui/client/sys_client_add_edit_page.dart`
  - 使用 `FormBuilder` 构建客户端信息表单

- **租户套餐表单**: `business/system/lib/system/ui/tenant/package/tenant_package_add_edit_page.dart`
  - 使用 `FormBuilder` 构建租户套餐配置表单

### 常用表单模式

- **搜索表单**: `business/system/lib/system/ui/dict/data/dict_data_list_page_vd.dart`
  - 结合 `FormOperateWithProvider` 管理搜索表单
  - 表单重置和搜索功能

- **配置搜索表单**: `business/system/lib/system/ui/config/config_list_page_vd.dart`
  - 使用 `FormOperateWithProvider` 管理表单操作

- **客户端搜索表单**: `business/system/lib/system/ui/client/sys_client_list_page_vd.dart`
  - 表单字段与搜索条件绑定

## 🎯 常用验证器

| 验证器 | 说明 |
|-------|------|
| `required` | 必填验证 |
| `email` | 邮箱格式验证 |
| `url` | URL 格式验证 |
| `numeric` | 数字验证 |
| `min` | 最小值验证 |
| `max` | 最大值验证 |
| `minLength` | 最小长度验证 |
| `maxLength` | 最大长度验证 |
| `match` | 正则匹配验证 |
| `equal` | 相等验证 |

完整验证器列表请查看 [form_builder_validators 文档](https://pub.dev/packages/form_builder_validators)

## 🚀 使用方式

在根目录 `pubspec.yaml` 中已配置为 workspace 成员，其他模块可直接引用：

```yaml
dependencies:
  form_extra:  # 自动使用 workspace 版本
```

## 📝 开发命令

```bash
# 进入模块目录
cd lib_module/form_extra

# 获取依赖
flutter pub get
```

**或使用项目根目录的批量脚本：**

```bash
./scripts/pub_get_all.sh       # 所有模块获取依赖
```

## 🏗️ 模块结构

```
form_extra/
├── lib/
│   ├── form_extra/            # 表单扩展组件
│   │   ├── validators/        # 自定义验证器（如存在）
│   │   ├── fields/            # 扩展字段组件（如存在）
│   │   └── utils/             # 工具类（如存在）
│   └── l10n/                  # 国际化
└── pubspec.yaml               # 模块配置
```

## 🔄 与其他模块的关系

```
form_extra (本模块)
 ├─ 被依赖: component, system, user
 ├─ 依赖: fast, flutter_form_builder
 └─ 作用: 为业务模块提供强大的表单功能
```

## 💡 最佳实践

1. **使用 GlobalKey 管理表单** - 便于表单验证和数据获取
2. **组合验证器** - 使用 `FormBuilderValidators.compose` 组合多个验证规则
3. **合理使用 initialValue** - 编辑场景下设置初始值
4. **统一错误提示** - 自定义错误文案，提供更友好的用户体验
5. **表单字段命名规范** - 使用有意义的字段名，便于数据处理
6. **结合 FormOperateWithProvider** - 统一管理表单操作和状态

## 📚 相关资源

- [flutter_form_builder 官方文档](https://pub.dev/packages/flutter_form_builder)
- [form_builder_validators 官方文档](https://pub.dev/packages/form_builder_validators)

---

*本模块是 Flutter Workspace 架构的一部分，依赖版本统一在根目录 `pubspec.yaml` 管理。*
