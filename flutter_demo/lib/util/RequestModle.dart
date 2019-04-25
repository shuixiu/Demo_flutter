import 'dart:convert';
import 'dart:io';

import 'package:flutter_demo/api/Api.dart';
import 'package:flutter_demo/model/AuthMsmData.dart';
import 'package:flutter_demo/model/LoginData.dart';
import 'package:flutter_demo/util/HttpRequest.dart';

class RequestModle {
  static getVerifyCode(String param) async {
    var res = await HttpRequest.post(Api.AUOTH, param);
    if (res != null) {
      AuthMsmData entity = AuthMsmData.fromJson(json.decode(res.data));
      return entity;
    } else {
      return null;
    }
  }

  static getLogin(Map param) async {
    var res = await HttpRequest.post(Api.LOGIN, param);
    if (res != null) {
      LoginData loginData = LoginData.fromJson(json.decode(res.data));

      return loginData;
    } else {
      return null;
    }
  }

  static getAuthToken(Map param) async {
    var res = await HttpRequest.post(Api.TOKENAUOTH, param);
    if (res != null) {
      LoginData loginData = LoginData.fromJson(json.decode(res.data));

      return loginData;
    } else {
      return null;
    }
  }

}
