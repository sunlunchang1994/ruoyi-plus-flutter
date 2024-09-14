import 'package:json_annotation/json_annotation.dart';

part 'captcha.g.dart';

///@Author sunlunchang
///验证码信息
@JsonSerializable()
class Captcha {
  ///是否开启验证码
  bool? captchaEnabled;

  String? uuid;

  String? img;

  Captcha(this.captchaEnabled, this.uuid, this.img);

  factory Captcha.fromJson(Map<String, dynamic> json) =>
      _$CaptchaFromJson(json);

  Map<String, dynamic> toJson() => _$CaptchaToJson(this);
}
