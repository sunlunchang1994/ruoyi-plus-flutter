## 提示

本项目使用Flutter v3.27.1开发，后续持续跟进官方最新版本

`支持Android、IOS、Windows、Linux、MacOS、Web全平台`

`UI界面暂时只有移动端样式`

## 简介

## 平台简介

- 基于 [Flutter](https://flutter.dev/) 的 RuoYi-Vue-Plus 前端项目

- 配套后端代码仓库地址
- [RuoYi-Vue-Plus 5.X(注意版本号)](https://gitee.com/dromara/RuoYi-Vue-Plus)
- [RuoYi-Cloud-Plus 2.X(注意版本号)](https://gitee.com/dromara/RuoYi-Cloud-Plus)

## Android Studio运行

```bash
# 克隆项目
git clone https://gitee.com/slcpublic/ruoyi-plus-flutter.git

# 配置Flutter环境变量
# 建议使用https://fvm.app/

# 安装依赖
flutter pub get

```

## 基于[RuoYi-Vue-Plus 5.X](https://gitee.com/dromara/RuoYi-Vue-Plus)和移动端特性本项目已实现的业务

| 业务      | 功能说明                                    | 本项目是否实现 | 后续是否实现或更新 |
|---------|-----------------------------------------|---------|-----------|
| 主题切换    | 支持Material 3 白天/黑夜主题切换，默认跟随系统主题         | 是       | 是         |
| 系统登录    | 通过系统给定的账号密码进行登录                         | 是       | 是         |
| 租户管理    | 系统内租户的管理 如:租户套餐、过期时间、用户数量、企业信息等         | 是       | 是         |
| 租户套餐管理  | 系统内租户所能使用的套餐管理 如:套餐内所包含的菜单等             | 是       | 是         |
| 用户管理    | 用户的管理配置 如:新增用户、分配用户所属部门、角色、岗位等          | 是       | 是         |
| 部门管理    | 配置系统组织机构（公司、部门、小组） 树结构展现支持数据权限          | 是       | 是         |
| 岗位管理    | 配置系统用户所属担任职务                            | 是       | 是         |
| 菜单管理    | 配置系统菜单、操作权限、按钮权限标识等                     | 是       | 是         |
| 角色管理    | 角色菜单权限分配、设置角色按机构进行数据范围权限划分              | 是       | 是         |
| 字典管理    | 对系统中经常使用的一些较为固定的数据进行维护                  | 是       | 是         |
| 参数管理    | 对系统动态配置常用参数                             | 是       | 是         |
| 通知公告    | 系统通知公告信息发布维护                            | 仅支持查看   | 是         |
| 操作日志    | 系统正常操作日志记录和查询 系统异常信息日志记录和查询             | 是       | 是         |
| 登录日志    | 系统登录日志记录查询包含登录异常                        | 是       | 是         |
| 文件管理    | 系统文件展示、上传、下载、删除等管理                      | 是       | 是         |
| 文件配置管理  | 系统文件上传、下载所需要的配置信息动态添加、修改、删除等管理          | 是       | 是         |
| 在线用户管理  | 已登录系统的在线用户信息监控与强制踢出操作                   | 是       | 是         |
| 代码生成    | 多数据源前后端代码的生成（java、html、xml、sql）支持CRUD下载 | 否       | 否         |
| 缓存监控    | 对系统的缓存信息查询，命令统计等。                       | 是       | 是        |
| 服务监控    | 监视集群系统CPU、内存、磁盘、堆栈、在线日志、Spring相关配置等     | 否       | 否         |
| 定时任务    | 运行报表、任务管理(添加、修改、删除)、日志管理、执行器管理等         | 否       | 否         |
| 在线构建器   | 拖动表单元素生成相应的Flutter代码。                   | 否       | 否         |
| WebView | App内打开网页                                | 是       | 是         |
| 使用案例    | 系统的一些功能案例                               | 是       | 是         |
| 工作流     | 系统工作流模块业务功能                             | 否       | 是         |
| 我的任务    | 系统我的任务模块业务功能                            | 否       | 是         |

## 演示图例

|                                                                                            |                                                                                                       |
|--------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------|
| ![输入图片说明](screenshot/Screenshot_20250321_114430_android.slc.ruoyi_plus_flutter.jpg '屏幕截图') | ![输入图片说明](screenshot/Screenshot_20250321_114446_android.slc.ruoyi_plus_flutter.jpg '屏幕截图')            |
| ![输入图片说明](screenshot/Screenshot_20250321_114500_android.slc.ruoyi_plus_flutter.jpg '屏幕截图') | ![输入图片说明](screenshot/Screenshot_20250321_114507_android.slc.ruoyi_plus_flutter.jpg '屏幕截图')            |
| ![输入图片说明](screenshot/Screenshot_20250321_114513_android.slc.ruoyi_plus_flutter.jpg '屏幕截图') | ![输入图片说明](screenshot/Screenshot_20250321_114520_android.slc.ruoyi_plus_flutter.jpg '屏幕截图')            |
| ![输入图片说明](screenshot/Screenshot_20250321_114527_android.slc.ruoyi_plus_flutter.jpg '屏幕截图') | ![输入图片说明](screenshot/Screenshot_20250321_114534_android.slc.ruoyi_plus_flutter.jpg '屏幕截图')            |
| ![输入图片说明](screenshot/Screenshot_20250321_114540_android.slc.ruoyi_plus_flutter.jpg '屏幕截图') | ![输入图片说明](screenshot/Screenshot_20250321_114544_android.slc.ruoyi_plus_flutter.jpg '屏幕截图') |
| ![输入图片说明](screenshot/Screenshot_20250321_114551_android.slc.ruoyi_plus_flutter.jpg '屏幕截图') | ![输入图片说明](screenshot/Screenshot_20250321_114556_android.slc.ruoyi_plus_flutter.jpg '屏幕截图') |
| ![输入图片说明](screenshot/Screenshot_20250321_114603_android.slc.ruoyi_plus_flutter.jpg '屏幕截图') | ![输入图片说明](screenshot/Screenshot_20250321_114618_android.slc.ruoyi_plus_flutter.jpg '屏幕截图') |
| ![输入图片说明](screenshot/Screenshot_20250321_114639_android.slc.ruoyi_plus_flutter.jpg '屏幕截图') | ![输入图片说明](screenshot/Screenshot_20250321_114647_android.slc.ruoyi_plus_flutter.jpg '屏幕截图') |
| ![输入图片说明](screenshot/Screenshot_20250321_114656_android.slc.ruoyi_plus_flutter.jpg '屏幕截图') | ![输入图片说明](screenshot/Screenshot_20250321_114707_android.slc.ruoyi_plus_flutter.jpg '屏幕截图') |
| ![输入图片说明](screenshot/Screenshot_20250321_114711_android.slc.ruoyi_plus_flutter.jpg '屏幕截图') | ![输入图片说明](screenshot/Screenshot_20250321_114917_android.slc.ruoyi_plus_flutter.jpg '屏幕截图') |
| ![输入图片说明](screenshot/Screenshot_20250321_114923_android.slc.ruoyi_plus_flutter.jpg '屏幕截图') | 
