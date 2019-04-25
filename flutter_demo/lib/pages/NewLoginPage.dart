import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/api/Api.dart';
import 'package:flutter_demo/model/AuthMsmData.dart';
import 'package:flutter_demo/model/LoginData.dart';
import 'package:flutter_demo/pages/HomePage.dart';
import 'package:flutter_demo/util/RequestModle.dart';
import 'package:flutter_demo/util/ThemeUtils.dart';
import 'package:flutter_demo/util/ToastUtils.dart';
import 'package:flutter_demo/util/local_storage.dart';
import 'package:flutter_demo/view/LoginFormCode.dart';
import 'package:uuid/uuid.dart';
import 'package:device_info/device_info.dart';

// 新的登录界面，隐藏WebView登录页面
class NewLoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new NewLoginPageState();
}

class NewLoginPageState extends State<NewLoginPage> {
  final usernameCtrl = new TextEditingController(text: '');
  final passwordCtrl = new TextEditingController(text: '');

  bool get isOnLogin => false;

  @override
  void initState() {
    super.initState();
  }

  bool phoneInit() {
    return usernameCtrl.text.trim().length > 10 ? true : false;
  }

  final TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    var loginBtn = new Builder(builder: (ctx) {
      return new MaterialButton(
          child: Text("确定"),
          textColor: Colors.white,
          color: Color(0xFF0083ff),
          // 按下的背景色
          splashColor: Colors.green,
          // 水波纹颜色
          padding: EdgeInsets.all(10),
          minWidth: MediaQuery.of(context).size.width,
          height: 50,
          onPressed: () {
            if (isOnLogin) return;

//            Navigator.of(context)
//                .pushReplacement(new MaterialPageRoute(builder: (context) {
//              return new HomePage();
//            }));

            // 拿到用户输入的账号密码
            String username = usernameCtrl.text.trim();
            String password = passwordCtrl.text.trim();
            if (username.isEmpty || password.isEmpty) {
              Scaffold.of(ctx).showSnackBar(new SnackBar(
                content: new Text("手机号和密码不能为空！"),
              ));
              return;
            }
            // 关闭键盘
            FocusScope.of(context).requestFocus(FocusNode());
            // 发送给webview，让webview登录后再取回token
            autoLogin(username, password);
          });
    });

    var authCode = new Builder(builder: (ctx) {
      return new LoginFormCode(
        phone: usernameCtrl.text.trim(),
        available: true,
        onTapCallback: autoCode,
      );
    });

    return new MaterialApp(
      title: "",
      theme: new ThemeData(primaryColor: ThemeUtils.currentColorTheme),
      home: Scaffold(
          appBar: new AppBar(
            title: new Text("登录", style: new TextStyle(color: Colors.white)),
            iconTheme: new IconThemeData(color: Colors.white),
          ),
          body: new SingleChildScrollView(
              padding: const EdgeInsets.all(40.0),
              child: new Column(children: <Widget>[
                new Center(
                    child: new Text(
                  "温馨提示：验证后可获得更多的服务",
                  style: new TextStyle(color: Colors.orange),
                )),
                new Container(height: 50.0),
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Image.asset('images/user_login_phone_icon.png',
                        width: 20.0, height: 20.0),
                    new Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                    ),
                    new Expanded(
                        child: new TextField(
                      controller: usernameCtrl,
                      decoration: new InputDecoration(
                        hintText: "请输入手机号",
                        hintStyle:
                            new TextStyle(color: const Color(0xFF808080)),
                        border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                                const Radius.circular(2.0))),
                        contentPadding: const EdgeInsets.all(10.0),
                      ),
                    ))
                  ],
                ),
                new Container(height: 20.0),
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Image.asset('images/user_login_auth_icon.png',
                        width: 20.0, height: 20.0),
                    new Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                    ),
                    new Expanded(
                        child: new TextField(
                      controller: passwordCtrl,
                      decoration: new InputDecoration(
                          hintText: "请输入验证码",
                          hintStyle:
                              new TextStyle(color: const Color(0xFF808080)),
                          border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                  const Radius.circular(2.0))),
                          contentPadding: const EdgeInsets.all(10.0)),
                    )),
                    new Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                    ),
                    authCode,
//                  new OutlineButton(
//                    borderSide:
//                        new BorderSide(color: Theme.of(context).primaryColor),
//                    child: new Text(
//                      "获取验证码",
//                      style: TextStyle(color: Theme.of(context).primaryColor),
//                    ),
//                    onPressed: () {
//                      String username = usernameCtrl.text.trim();
//                      if (username.isEmpty) {
//                        Scaffold.of(context).showSnackBar(new SnackBar(
//                          content: new Text("手机号不能为空！"),
//                        ));
//                        return;
//                      }
//                      autoCode(username);
//                    },
//                  )
                  ],
                ),
                new Container(height: 20.0),
                loginBtn,
              ]))),
    );
  }

  @override
  void dispose() {
    // 回收相关资源
    super.dispose();
  }

  void autoCode() {
    Map param = {
      "client_type": 3,
      "phone": usernameCtrl.text.trim(),
      "user_type": 1
    };
//    Dio dio = new Dio();
//    dio.options.connectTimeout = 5000; //5s
//    dio.options.receiveTimeout = 5000;
//    dio.options.headers = {
//      'user-agent': 'dio',
//      'common-header': 'xx',
//      'version': '1.0.1',
//      'Authorization': '_token',
//    };
//    dio.onHttpClientCreate  = (HttpClient client) {
//      client.findProxy = (uri) {
//
//      };
//    };
//    Response  response = await dio.post("http://www.dtworkroom.com/doris/1/2.0.0/test", data: param
//    Response response = await dio.post(
//      Api.AUOTH, data: param,
//      // Send data with "application/x-www-form-urlencoded" format
//      options: new Options(
//          contentType: ContentType.parse("application/x-www-form-urlencoded"),
//          responseType: ResponseType.json),
//    );
//    print("autoCode=" + response.data.toString());

    AuthMsmData data;
    RequestModle.getVerifyCode(json.encode(param)).then((res) {
      data = res;
      print("autoCode=" + res.toString());
      if (data.return_code != null && data.return_code == '00000') {
        Toast.toast(context, "验证码已发送，请注意查收！");
      }
    });
  }

  void sendMsm() {
    Scaffold.of(context)
        .showSnackBar(new SnackBar(content: new Text("验证码已发送")));
  }

  void autoLogin(String username, String password) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;

    var uuid = new Uuid();
/*    print('Running Uuid ${uuid.v1()}');
    print('Running Uuid ${uuid.v4()}');
    print('Running Uuid ${uuid.v5(Uuid.NAMESPACE_URL, 'www.google.com')}');
    print('Running on ${androidDeviceInfo.device}');
    print('Running on ${androidDeviceInfo.model}');
    print('Running on ${androidDeviceInfo.androidId}');
    print('Running on ${androidDeviceInfo.display}');

    int start = 1;
    int sum = 0;
    while (start <= 100) {
      sum += start;
      start++;
    }
    print('Running on $sum');*/


    var mParamuuid = uuid.v1();

    Map param = {
      "client_type": 3,
      "phone": usernameCtrl.text.trim(),
      "auth_code": passwordCtrl.text.trim(),
      "openid": mParamuuid,
      "version_id": 1,
      "model_name": androidDeviceInfo.model,
    };
    LoginData data;
    RequestModle.getLogin(param).then((res) {
      data = res;
      if (data.return_code != null && data.return_code == '00000') {
        Toast.toast(context, "登录成功");

        LocalStorage.save("token", data.data.token);
        LocalStorage.save("openid", mParamuuid);

        Navigator.of(context)
            .pushReplacement(new MaterialPageRoute(builder: (context) {
          return new HomePage();
        }));
      } else {
        Toast.toast(context, data.return_msg);
      }
    });
  }
}
