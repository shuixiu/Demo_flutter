import 'package:json_annotation/json_annotation.dart';
part 'LoginData.g.dart';
@JsonSerializable()
class LoginData extends Object {
  String return_code;
  String return_msg;
  UserData data;

  LoginData(this.return_code, this.return_msg,this.data);

//不同的类使用不同的mixin即可
  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);

  Map<String, dynamic> toJson() => _$LoginDataToJson(this);
}
@JsonSerializable()
class UserData extends Object{

  String token;
  String user_id;
  String jump_to;

  UserData(this.token,this.user_id,this.jump_to);

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);

}