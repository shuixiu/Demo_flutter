

import 'package:json_annotation/json_annotation.dart';
part 'ResultData.g.dart';
@JsonSerializable()
class ResultData {
  var data;
  bool result;
  int code;
  var headers;

  ResultData(this.data, this.result, this.code, {this.headers});

  //不同的类使用不同的mixin即可
  factory ResultData.fromJson(Map<String, dynamic> json) =>
      _$ResultDataFromJson(json);

  Map<String, dynamic> toJson() => _$ResultDataToJson(this);

}