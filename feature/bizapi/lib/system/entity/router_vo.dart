import 'package:json_annotation/json_annotation.dart';

import 'meta_vo.dart';

part 'router_vo.g.dart';

///@author sunlunchang
///路由配信息
@JsonSerializable()
class RouterVo {
  ///路由名字
  String? name;

  ///路由地址
  String? path;

  ///是否隐藏路由，当设置 true 的时候该路由不会再侧边栏出现
  bool? hidden;

  ///重定向地址，当设置 noRedirect 的时候该路由在面包屑导航中不可被点击
  String? redirect;

  ///组件地址
  String? component;

  ///路由参数：如 {"id": 1, "name": "ry"}
  String? query;

  ///当你一个路由下面的 children 声明的路由大于1个时，自动会变成嵌套的模式--如组件页面
  bool? alwaysShow;

  ///其他元素
  MetaVo? meta;

  ///子路由
  List<RouterVo>? children;

  RouterVo(
      {this.name,
      this.path,
      this.hidden,
      this.redirect,
      this.component,
      this.query,
      this.alwaysShow,
      this.meta,
      this.children});

  factory RouterVo.fromJson(Map<String, dynamic> json) =>
      _$RouterVoFromJson(json);

  Map<String, dynamic> toJson() => _$RouterVoToJson(this);

  ///获取路由title
  String getRouterTitle(){
    return meta?.title ?? name ?? "";
  }
}
