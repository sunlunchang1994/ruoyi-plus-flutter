import 'package:boxes_flutter/flutter/slc/adapter/select_box.dart';
import 'package:json_annotation/json_annotation.dart';

part '{{feature}}.g.dart';

@JsonSerializable()
class {{Entity}} with SelectBoxMixin<{{Entity}}> {
  BigInt? id;
  String? name;
  String? status;
  String? remark;

  {{Entity}}({
    this.id,
    this.name,
    this.status,
    this.remark,
  });

  factory {{Entity}}.fromJson(Map<String, dynamic> json) => _${{Entity}}FromJson(json);

  Map<String, dynamic> toJson() => _${{Entity}}ToJson(this);
}
