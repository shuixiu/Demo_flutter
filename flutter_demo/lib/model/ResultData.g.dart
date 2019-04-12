// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ResultData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResultData _$ResultDataFromJson(Map<String, dynamic> json) {
  return ResultData(json['data'], json['result'] as bool, json['code'] as int,
      headers: json['headers']);
}

Map<String, dynamic> _$ResultDataToJson(ResultData instance) =>
    <String, dynamic>{
      'data': instance.data,
      'result': instance.result,
      'code': instance.code,
      'headers': instance.headers
    };
