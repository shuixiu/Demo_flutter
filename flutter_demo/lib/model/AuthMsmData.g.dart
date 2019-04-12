// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AuthMsmData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthMsmData _$AuthMsmDataFromJson(Map<String, dynamic> json) {
  return AuthMsmData(
      json['return_code'] as String, json['return_msg'] as String);
}

Map<String, dynamic> _$AuthMsmDataToJson(AuthMsmData instance) =>
    <String, dynamic>{
      'return_code': instance.return_code,
      'return_msg': instance.return_msg
    };
