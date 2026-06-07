# 本地存储、国际化、主题、权限标准

## 本地持久化

- 配置类继承 `DpManager`。
- 构造时传入唯一 `spName`，底层 key 格式为 `spName:key`。
- `RunAppBeforeTask` 必须先初始化 `SpCacheUtil`。
- 只持久化 `int`、`double`、`bool`、`String`、`List<String>` 或 `null`。

模板：`templates/infrastructure/config_manager.dart.tpl`。

## 国际化

- 每个 package 使用自己的 `l10n.yaml` 和 `gen/*_l10n.dart` 包装。
- 新增模块后同步：
  - 模块 `l10n.yaml`
  - arb 文件
  - 生成文件
  - `RootPage.localizationsDelegates`
  - 必要的 import
- 用户可见文案优先 l10n。
- 后端字典值显示用字典模块转换，不直接硬编码中文。
- 当前历史代码里多个 package 使用 `intl_en.arb` 承载中文文案，这是兼容现状，不是新模块标准。不要只局部把某个 package 改成 `zh`，否则 delegate 和 `supportedLocales` 会不一致；需要国际化语义修正时，按全项目专项迁移。

## 主题和样式

- 根主题来自 `lib/res/styles.dart`。
- 基础尺寸优先 `SlcDimens` 和模块 `Dimens`。
- 通用样式放根或基础模块，业务特有样式放业务模块 `res/styles.dart`。
- 不在页面里大面积散落颜色和尺寸魔法值。

## 权限

- 使用 `UserShareVm().hasPermiAny(...)`、`hasPermiEvery(...)`、`widgetWithPermiAny(...)`。
- 权限只控制对应 action，不隐藏整个页面主体。
- 保存、删除、同步、强退等操作都要按后端权限标识包裹。

## 字典

- 字典查询使用 `DictShareVm`。
- 字典选择使用 `DictUiUtils.showSelectDialog(...)`。
- 表单 radio/select options 使用 `DictUiUtils.dictList2FromOption(...)`。
- 选中后同时更新实体字段和表单字段。
