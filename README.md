## 提示

本项目使用Flutter v3.27.1开发，后续持续跟进官方最新版本

`支持Android、IOS、Windows、Linux、MacOS、Web全平台`

`UI界面暂时只有移动端样式`

## 简介

## 平台简介

- 基于RuoYi-Vue-Plus Api的[Flutter](https://flutter.dev/)客户端项目

- 配套后端代码仓库地址
- [RuoYi-Vue-Plus 5.X(注意版本号)](https://gitee.com/dromara/RuoYi-Vue-Plus)
- [RuoYi-Cloud-Plus 2.X(注意版本号)](https://gitee.com/dromara/RuoYi-Cloud-Plus)

## 预览

admin 账号: admin admin123

[请在发布页下载Apk安装预览](https://gitee.com/sunlunchang/ruoyi-plus-flutter/releases)

## 相关文档
[点击查看Wiki](https://gitee.com/sunlunchang/ruoyi-plus-flutter/wikis)

```bash
# 克隆项目
git clone https://gitee.com/slcpublic/ruoyi-plus-flutter.git

# 配置Flutter环境变量
# 建议使用https://fvm.app/

# 安装依赖
flutter pub get

```

## 基于[RuoYi-Vue-Plus 5.X](https://gitee.com/dromara/RuoYi-Vue-Plus)版本并结合移动端特性，本项目实现了以下业务功能：

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

## 本项目使用到的第三方库：

| 名称                                                                                  | 功能说明                                   |
|-------------------------------------------------------------------------------------|----------------------------------------|
| [flutter_slc_boxes](https://pub.dev/packages/flutter_slc_boxes)                     | 本人开发的基于mvvm设计模式的基础框架，附带路由页面状态，工具库      |
| route                      | 未使用第三方路由，使用flutter官方路由，无入侵式的提供了快速操作api |
| [provider](https://pub.dev/packages/provider)                                       | 状态管理                                   |
| [cupertino_icons](https://pub.dev/packages/cupertino_icons)                         | 图表库                                    |
| [flutter_localizations](https://pub.dev/packages/flutter_localization)              | 国际化                                    |
| [easy_refresh](https://pub.dev/packages/easy_refresh)                               | 下拉刷新上拉加载                               |
| [flutter_svg](https://pub.dev/packages/flutter_svg)                                 | SVG图加载                                 |
| [extended_nested_scroll_view](https://pub.dev/packages/extended_nested_scroll_view) | 扩展NestedScrollView                     |
| [fl_chart](https://pub.dev/packages/fl_chart)                                       | 图表UI库                                  |
| [cached_network_image](https://pub.dev/packages/cached_network_image)               | 图片加载缓存                                 |
| [json_annotation](https://pub.dev/packages/json_annotation)                         | Json序列化反序列化                            |
| [retrofit](https://pub.dev/packages/retrofit)                                       | 基于dio的网络请求库，简化编码                       |
| [rxdart](https://pub.dev/packages/rxdart)                                           | 扩展了 Dart Streams                       |
| [encrypt](https://pub.dev/packages/encrypt)                                         | 加解密                                    |
| [image_picker](https://pub.dev/packages/image_picker)                               | 图片选择                                   |
| [image_gallery_saver](https://pub.dev/packages/image_gallery_saver)                 | 将图片保存到图片库                              |
| [crop_your_image](https://pub.dev/packages/crop_your_image)                         | 图片裁剪                                   |
| [file_picker](https://pub.dev/packages/file_picker)                                 | 文件选择                                   |
| [path_provider](https://pub.dev/packages/path_provider)                             | 获取系统相关路径                               |
| [open_file](https://pub.dev/packages/open_file)                                     | 通过系统应用打开指定文件路径                         |
| [shared_preferences](https://pub.dev/packages/shared_preferences)                   | 简单数据封装特定于平台的持久性存储                      |
| [permission_handler](https://pub.dev/packages/permission_handler)                   | 权限申请                                   |
| [uuid](https://pub.dev/packages/uuid)                                               | 生成uuid                                 |
| [keyboard_avoider](https://pub.dev/packages/keyboard_avoider)                       | 解决键盘遮挡                                 |
| [package_info_plus](https://pub.dev/packages/package_info_plus)                     | 查询应用程序包信息                              |
| [flutter_form_builder系列](https://pub.dev/packages/flutter_form_builder)             | 表单相关                                   |
| [webview_flutter](https://pub.dev/packages/webview_flutter)                         | Webview                                |
| [flutter_markdown](https://pub.dev/packages/flutter_markdown)                       | Markdown控件                             |
| [interactive_json_preview](https://pub.dev/packages/interactive_json_preview)       | Json格式化                                |

## 捐献作者
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
