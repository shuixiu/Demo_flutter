import 'package:json_annotation/json_annotation.dart';
part 'AuthMsmData.g.dart';

@JsonSerializable()
class AuthMsmData extends Object {
  @JsonKey(name: 'return_code')
  String return_code;
  @JsonKey(name: 'return_msg')
  String return_msg;

  AuthMsmData(this.return_code, this.return_msg);

//不同的类使用不同的mixin即可
  factory AuthMsmData.fromJson(Map<String, dynamic> json) =>
      _$AuthMsmDataFromJson(json);

  Map<String, dynamic> toJson() => _$AuthMsmDataToJson(this);
}
