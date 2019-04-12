// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LoginData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginData _$LoginDataFromJson(Map<String, dynamic> json) {
  return LoginData(
      json['return_code'] as String,
      json['return_msg'] as String,
      json['data'] == null
          ? null
          : UserData.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$LoginDataToJson(LoginData instance) => <String, dynamic>{
      'return_code': instance.return_code,
      'return_msg': instance.return_msg,
      'data': instance.data
    };

UserData _$UserDataFromJson(Map<String, dynamic> json) {
  return UserData(json['token'] as String, json['user_id'] as String,
      json['jump_to'] as String);
}

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'token': instance.token,
      'user_id': instance.user_id,
      'jump_to': instance.jump_to
    };
