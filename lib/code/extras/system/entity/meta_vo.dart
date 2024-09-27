import 'package:json_annotation/json_annotation.dart';

part 'meta_vo.g.dart';

///@Author sunlunchang
///路由显示信息
@JsonSerializable()
class MetaVo {
  ///设置该路由在侧边栏和面包屑中展示的名字
  String title;

  ///设置该路由的图标，对应路径src/assets/icons/svg
  String? icon;

  ///设置为true，则不会被 <keep-alive>缓存
  bool? noCache;

  ///内链地址（http(s)://开头）
  String? link;

  MetaVo(this.title, {this.icon, this.noCache, this.link});

  factory MetaVo.fromJson(Map<String, dynamic> json) =>
      _$MetaVoFromJson(json);

  Map<String, dynamic> toJson() => _$MetaVoToJson(this);
}
