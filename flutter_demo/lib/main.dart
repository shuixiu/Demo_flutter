import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/pages/NewLoginPage.dart';

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
        '/login': (BuildContext context) => new NewLoginPage()
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

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/login');
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