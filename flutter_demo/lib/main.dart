import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/api/Api.dart';
import 'package:flutter_demo/model/LoginData.dart';
import 'package:flutter_demo/pages/HomePage.dart';
import 'package:flutter_demo/pages/NewLoginPage.dart';
import 'package:flutter_demo/util/RequestModle.dart';
import 'package:flutter_demo/util/ToastUtils.dart';
import 'package:flutter_demo/util/local_storage.dart';
import 'package:package_info/package_info.dart';

//void main() {
//  runApp(new MyXiuClient());
//}

void main() => runApp(new MyXiuStartOne());


class MyXiuStartOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "",
      theme: new ThemeData(
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          platform: TargetPlatform.iOS),
      home: new MyXiuStart(),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => new NewLoginPage(),
        '/home':(BuildContext context) => new HomePage(),
      },
    );
  }


}
class MyXiuStart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SplashScreenState();

}

class _SplashScreenState extends State<MyXiuStart> {
  startTime() async {
    //设置启动图生效时间
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async{
    PackageInfo  packageInfo = await PackageInfo.fromPlatform();

    print("print=="+packageInfo.appName+"--"+packageInfo.buildNumber+"--"+packageInfo.packageName+"--"+packageInfo.version);
    String token = await LocalStorage.get("token");
    print(token);
    if(token==null){
      Navigator.of(context).pushReplacementNamed('/login');
    }else{
      Map param = {
        "client_type": 3,
        "openid": await LocalStorage.get("openid"),
        "token":await LocalStorage.get("token"),

        "version_id": packageInfo.version,
        "model_name":packageInfo.buildNumber,
      };
      LoginData data;
      RequestModle.getAuthToken(param).then((res) {
        data = res;
        if (data.return_code != null && data.return_code == '00000') {

          LocalStorage.save("token", data.data.token);
          Navigator.of(context).pushReplacementNamed('/home');
        } else {
          Toast.toast(context, data.return_msg);
        }
      });
    }



  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Image.asset('images/start_logo.png'),
      ),
      backgroundColor: Colors.white,
    );
  }

}