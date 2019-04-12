import 'dart:io';

import 'package:dio/dio.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_demo/model/Code.dart';

import 'dart:collection';

import 'package:flutter_demo/model/ResultData.dart';
import 'package:flutter_demo/util/MSSessionManager.dart';
import 'package:flutter_demo/util/config.dart';
import 'package:flutter_demo/util/local_storage.dart';

enum Method {
  GET,
  POST,
  UPLOAD,
  DOWNLOAD,
}

///http请求管理类，可单独抽取出来
class HttpRequest {
  static String _baseUrl;
  static const CONTENT_TYPE_JSON = "application/json";
  static const CONTENT_TYPE_FORM = "application/x-www-form-urlencoded";
  static Map optionParams = {
    "timeoutMs": 15000,
    "token": null,
    "authorizationCode": null,
  };

  static setBaseUrl(String baseUrl){
    _baseUrl = baseUrl;
  }

  static get(url,param) async{
    return await request(_baseUrl+url, param, null, new Options(method:"GET"));
  }

  static post(url,param) async{

    print("url----"+url);
//    return await request(url,param , {"Accept": 'application/vnd.github.VERSION.full+json'}, new Options(method: 'POST'));
    return await request(url, param, {"Accept": 'application/x-www-form-urlencoded'}, new Options(method: 'POST'));
  }

  static delete(url,param) async{
    return await request(_baseUrl+url, param, null, new Options(method: 'DELETE'));
  }

  static put(url,param) async{
    return await request(_baseUrl+url, param, null, new Options(method: "PUT", contentType: ContentType.text));
  }


  ///发起网络请求
  ///[ url] 请求url
  ///[ params] 请求参数
  ///[ header] 外加头
  ///[ option] 配置
  static request(url, params, Map<String, String> header, Options option, {noTip = false}) async {

    //没有网络
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return new ResultData(Code.errorHandleFunction(Code.NETWORK_ERROR, "", noTip), false, Code.NETWORK_ERROR);
    }

    Map<String, String> headers = new HashMap();
    if (header != null) {
      headers.addAll(header);
    }

    //授权码
    if (optionParams["authorizationCode"] == null) {
      var authorizationCode = await getAuthorization();
      if (authorizationCode != null) {
        optionParams["authorizationCode"] = authorizationCode;
      }
    }

    headers["Authorization"] = optionParams["authorizationCode"];
    // 设置 baseUrl

    if (option != null) {
      option.headers = headers;
    } else{
      option = new Options(method: "get");
      option.headers = headers;
    }

    ///超时
    option.connectTimeout = 15000;

    Dio dio = new Dio();

    // 添加拦截器
    if (Config.DEBUG) {
      dio.interceptors.add(InterceptorsWrapper(
          onRequest: (RequestOptions options){
            print("\n================== 请求数据 ==========================");
            print("url = ${options.uri.toString()}");
            print("headers = ${options.headers}");
            print("params = ${options.data}");
          },
          onResponse: (Response response){
            print("\n================== 响应数据 ==========================");
            print("code = ${response.statusCode}");
            print("data = ${response.data}");
            print("\n");
          },
          onError: (DioError e){
            print("\n================== 错误响应数据 ======================");
            print("type = ${e.type}");
            print("message = ${e.message}");
            print("stackTrace = ${e.stackTrace}");
            print("\n");
          }
      ));
    }

    Response response;

    try {
      print("response1");
      response = await dio.request(url, data: params, options: option);
      print("response2");
    } on DioError catch (e) {
      // 请求错误处理
      Response errorResponse;
      if (e.response != null) {
        errorResponse = e.response;
      } else {
        errorResponse = new Response(statusCode: 666);
      }
      if (e.type == DioErrorType.CONNECT_TIMEOUT) {
        errorResponse.statusCode = Code.NETWORK_TIMEOUT;
      }
      if (Config.DEBUG) {
        print('请求异常: ' + e.toString());
        print('请求异常 url: ' + url);
      }
      return new ResultData(Code.errorHandleFunction(errorResponse.statusCode, e.message, noTip), false, errorResponse.statusCode);
    }

    try {
      if (option.contentType != null && option.contentType.primaryType == "text") {
        return new ResultData(response.data, true, Code.SUCCESS);
      } else {
        var responseJson = response.data;
        if (response.statusCode == 201 && responseJson["token"] != null) {
          optionParams["authorizationCode"] = 'token ' + responseJson["token"];
          await LocalStorage.save(Config.TOKEN_KEY, optionParams["authorizationCode"]);
        }
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ResultData(response.data, true, Code.SUCCESS, headers: response.headers);
      }
    } catch (e) {
      print(e.toString() + url);
      return ResultData(response.data, false, response.statusCode, headers: response.headers);
    }
    return new ResultData(Code.errorHandleFunction(response.statusCode, "", noTip), false, response.statusCode);
  }

  ///清除授权
  static clearAuthorization() {
    optionParams["authorizationCode"] = null;
    LocalStorage.remove(Config.TOKEN_KEY);
  }

  ///获取授权token
  static getAuthorization() async {
    String token = await LocalStorage.get(Config.TOKEN_KEY);
    if (token == null) {
      String basic = await LocalStorage.get(Config.USER_BASIC_CODE);
      if (basic == null) {
        //提示输入账号密码
      } else {
        //通过 basic 去获取token，获取到设置，返回token
        return "Basic $basic";
      }
    } else {
      optionParams["authorizationCode"] = token;
      return token;
    }
  }

















  /// 附件上传
  upLoad (List files, String url, {Object params,}) async{
    return await request1(url,
        method: Method.UPLOAD,params: params, files: files);
  }
  /// 附件下载 附件下载需要传入保存地址
  download (String url, String savePath) async{
    return await request1(url, method: Method.DOWNLOAD, fileSavePath: savePath);
  }

  ///  请求部分
  request1(String url,
      {Method method, Object params, List files, String fileSavePath}) async {
    try {
      Response response;

      MSSessionManager sessionManager = MSSessionManager();
      var headers = await getHeaders();
      if (headers != null) {
        sessionManager.options.headers = headers;
      }
      var baseUrl = await getBasicUrl();
      sessionManager.options.baseUrl = baseUrl;

      switch (method) {
        case Method.GET:
          response = await sessionManager.get(url,queryParameters: params);
          break;
        case Method.POST:
          response = await sessionManager.post(url,data: params);
          break;
        case Method.UPLOAD:
          {
            List uploadFiles = List();
            for (int i=0; i<files.length; i++)  {
              uploadFiles.add(new UploadFileInfo.fromBytes(files[i], '${i}.png'));
              FormData formData = new FormData.from(params);
              formData.add("files", uploadFiles);
              response = await sessionManager.post(url,data: formData);
            }
            break;
          }
        case Method.DOWNLOAD:
          response = await sessionManager.download(url, fileSavePath);
          break;
      }
      return await handleDataSource(response, method);
    } catch (exception) {
      return ResultData(exception.toString(), false,Code.NETWORK_ERROR);
    }
  }
  /// 数据处理
  static handleDataSource (Response response, Method method){
    String errorMsg = "";
    int statusCode;
    statusCode = response.statusCode;
    if (method == Method.DOWNLOAD) {
      if (statusCode == 200) {
        /// 下载成功
        return ResultData('下载成功', true,Code.SUCCESS);
      }else{
        /// 下载失败
        return ResultData('下载失败', false,Code.NETWORK_ERROR);
      }
    }
    //处理错误部分
    if (statusCode < 0) {
      errorMsg = "网络请求错误,状态码:" + statusCode.toString();
      return ResultData(errorMsg, false,Code.NETWORK_ERROR);

    }
//    try {
//      Map data = json.decode(response.data);
//      if (data['code'] == 0 ) {
//        try {
//          return DataResult(data['data'], true);
//        }catch (exception){
//          return DataResult('暂无数据', false);
//        }
//      }else{
//        return DataResult(data['msg'], false);
//      }
//    }catch(exception){
//      List data = json.decode(response.data);
//      return DataResult(data, true);
//    }
  }
  getHeaders () {
    return null;
  }

  getBasicUrl (){
    return null;
  }
}
