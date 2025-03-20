# ruoyi-plus-flutter
[![license](https://gitee.com/slcpublic/ruoyi-plus-flutter/screenshot/LICENSE.svg)](LICENSE)

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
| 租户管理    | 系统内租户的管理 如:租户套餐、过期时间、用户数量、企业信息等         | 是       | 无         |
| 租户套餐管理  | 系统内租户所能使用的套餐管理 如:套餐内所包含的菜单等             | 是       | 无         |
| 用户管理    | 用户的管理配置 如:新增用户、分配用户所属部门、角色、岗位等          | 是       | 支持        |
| 部门管理    | 配置系统组织机构（公司、部门、小组） 树结构展现支持数据权限          | 是       | 支持        |
| 岗位管理    | 配置系统用户所属担任职务                            | 是       | 支持        |
| 菜单管理    | 配置系统菜单、操作权限、按钮权限标识等                     | 是       | 支持        |
| 角色管理    | 角色菜单权限分配、设置角色按机构进行数据范围权限划分              | 是       | 支持        |
| 字典管理    | 对系统中经常使用的一些较为固定的数据进行维护                  | 是       | 支持        |
| 参数管理    | 对系统动态配置常用参数                             | 是       | 支持        |
| 通知公告    | 系统通知公告信息发布维护                            | 进支持查看   | 支持        |
| 操作日志    | 系统正常操作日志记录和查询 系统异常信息日志记录和查询             | 是       | 支持        |
| 登录日志    | 系统登录日志记录查询包含登录异常                        | 是       | 支持        |
| 文件管理    | 系统文件展示、上传、下载、删除等管理                      | 是       | 无         |
| 文件配置管理  | 系统文件上传、下载所需要的配置信息动态添加、修改、删除等管理          | 是       | 无         |
| 在线用户管理  | 已登录系统的在线用户信息监控与强制踢出操作                   | 是       | 支持        |
| 代码生成    | 多数据源前后端代码的生成（java、html、xml、sql）支持CRUD下载 | 否       | 仅支持单数据源   |
| 缓存监控    | 对系统的缓存信息查询，命令统计等。                       | 是       | 支持        |
| 服务监控    | 监视集群系统CPU、内存、磁盘、堆栈、在线日志、Spring相关配置等     | 否       | 否         |
| 定时任务    | 运行报表、任务管理(添加、修改、删除)、日志管理、执行器管理等         | 否       | 否         |
| 在线构建器   | 拖动表单元素生成相应的Flutter代码。                   | 否       | 否         |
| WebView | App内打开网页                                | 是       | 是         |
| 使用案例    | 系统的一些功能案例                               | 是       | 是         |
| 工作流     | 系统工作流模块业务功能                             | 否       | 是         |
| 我的任务    | 系统我的任务模块业务功能                            | 否       | 是         |

## 演示图例

|                                                                                                      |                                                                                                      |
| ---------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------- |
| ![输入图片说明](https://foruda.gitee.com/images/1680077524361362822/270bb429_1766278.png '屏幕截图') | ![输入图片说明](https://foruda.gitee.com/images/1680077619939771291/989bf9b6_1766278.png '屏幕截图') |
| ![输入图片说明](https://foruda.gitee.com/images/1680077681751513929/1c27c5bd_1766278.png '屏幕截图') | ![输入图片说明](https://foruda.gitee.com/images/1680077721559267315/74d63e23_1766278.png '屏幕截图') |
| ![输入图片说明](https://foruda.gitee.com/images/1680077765638904515/1b75d4a6_1766278.png '屏幕截图') | ![输入图片说明](https://foruda.gitee.com/images/1680078026375951297/eded7a4b_1766278.png '屏幕截图') |
| ![输入图片说明](https://foruda.gitee.com/images/1680078237104531207/0eb1b6a7_1766278.png '屏幕截图') | ![输入图片说明](https://foruda.gitee.com/images/1680078254306078709/5931e22f_1766278.png '屏幕截图') |
| ![输入图片说明](https://foruda.gitee.com/images/1680078287971528493/0b9af60a_1766278.png '屏幕截图') | ![输入图片说明](https://foruda.gitee.com/images/1680078308138770249/8d3b6696_1766278.png '屏幕截图') |
| ![输入图片说明](https://foruda.gitee.com/images/1680078352553634393/db5ef880_1766278.png '屏幕截图') | ![输入图片说明](https://foruda.gitee.com/images/1680078378238393374/601e4357_1766278.png '屏幕截图') |
| ![输入图片说明](https://foruda.gitee.com/images/1680078414983206024/2aae27c1_1766278.png '屏幕截图') | ![输入图片说明](https://foruda.gitee.com/images/1680078446738419874/ecce7d59_1766278.png '屏幕截图') |
| ![输入图片说明](https://foruda.gitee.com/images/1680078475971341775/149e8634_1766278.png '屏幕截图') | ![输入图片说明](https://foruda.gitee.com/images/1680078491666717143/3fadece7_1766278.png '屏幕截图') |
| ![输入图片说明](https://foruda.gitee.com/images/1680078558863188826/fb8ced2a_1766278.png '屏幕截图') | ![输入图片说明](https://foruda.gitee.com/images/1680078574561685461/ae68a0b2_1766278.png '屏幕截图') |
| ![输入图片说明](https://foruda.gitee.com/images/1680078594932772013/9d8bfec6_1766278.png '屏幕截图') | ![输入图片说明](https://foruda.gitee.com/images/1680078626493093532/fcfe4ff6_1766278.png '屏幕截图') |
| ![输入图片说明](https://foruda.gitee.com/images/1680078643608812515/0295bd4f_1766278.png '屏幕截图') | ![输入图片说明](https://foruda.gitee.com/images/1680078685196286463/d7612c81_1766278.png '屏幕截图') |
| ![输入图片说明](https://foruda.gitee.com/images/1680078703877318597/56fce0bc_1766278.png '屏幕截图') | ![输入图片说明](https://foruda.gitee.com/images/1680078716586545643/b6dbd68f_1766278.png '屏幕截图') |
| ![输入图片说明](https://foruda.gitee.com/images/1680078734103217688/eb1e6aa6_1766278.png '屏幕截图') | ![输入图片说明](https://foruda.gitee.com/images/1680078759131415480/73c525d8_1766278.png '屏幕截图') |
| ![输入图片说明](https://foruda.gitee.com/images/1680078779416197879/75e3ed02_1766278.png '屏幕截图') | ![输入图片说明](https://foruda.gitee.com/images/1680078802329118061/77e10915_1766278.png '屏幕截图') |
| ![输入图片说明](https://foruda.gitee.com/images/1680078893627848351/34a1c342_1766278.png '屏幕截图') | ![输入图片说明](https://foruda.gitee.com/images/1680078928175016986/f126ec4a_1766278.png '屏幕截图') |
| ![输入图片说明](https://foruda.gitee.com/images/1680078941718318363/b68a0f72_1766278.png '屏幕截图') | ![输入图片说明](https://foruda.gitee.com/images/1680078963175518631/3bb769a1_1766278.png '屏幕截图') |
| ![输入图片说明](https://foruda.gitee.com/images/1680078982294090567/b31c343d_1766278.png '屏幕截图') | ![输入图片说明](https://foruda.gitee.com/images/1680079000642440444/77ca82a9_1766278.png '屏幕截图') |
| ![输入图片说明](https://foruda.gitee.com/images/1680079020995074177/03b7d52e_1766278.png '屏幕截图') | ![输入图片说明](https://foruda.gitee.com/images/1680079039367822173/76811806_1766278.png '屏幕截图') |
| ![输入图片说明](https://foruda.gitee.com/images/1680079274333484664/4dfdc7c0_1766278.png '屏幕截图') | ![输入图片说明](https://foruda.gitee.com/images/1680079290467458224/d6715fcf_1766278.png '屏幕截图') |
