import 'package:json_annotation/json_annotation.dart';

part 'avatar_vo.g.dart';

@JsonSerializable()
class AvatarVo {
  String? imgUrl;

  AvatarVo({this.imgUrl});

  factory AvatarVo.fromJson(Map<String, dynamic> json) => _$AvatarVoFromJson(json);

  Map<String, dynamic> toJson() => _$AvatarVoToJson(this);
}
