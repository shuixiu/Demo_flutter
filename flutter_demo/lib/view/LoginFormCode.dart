import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final TextStyle _availableStyle = TextStyle(
  fontSize: 16.0,
  color: const Color(0xFF00CACE),
);

final TextStyle _unavailableStyle = TextStyle(
  fontSize: 16.0,
  color: const Color(0xFFCCCCCC),
);

class LoginFormCode extends StatefulWidget {
  /// 倒计时的秒数，默认60秒。
  final int countdown;

  /// 用户点击时的回调函数。
  final Function onTapCallback;

  /// 是否可以获取验证码，默认为`false`。
  final bool available;

  final String phone;

  LoginFormCode({
    this.countdown: 60,
    this.onTapCallback,
    this.available: false,
    this.phone: "",
  });

  @override
  _LoginFormCodeState createState() => _LoginFormCodeState();
}

class _LoginFormCodeState extends State<LoginFormCode> {
  /// 倒计时的计时器。
  Timer _timer;

  /// 当前倒计时的秒数。
  int _seconds;

  /// 当前墨水瓶（`InkWell`）的字体样式。
  TextStyle inkWellStyle = _availableStyle;

  /// 当前墨水瓶（`InkWell`）的文本。
  String _verifyStr = '获取验证码';

  @override
  void initState() {
    super.initState();
    _seconds = widget.countdown;
  }

  /// 启动倒计时的计时器。
  void _startTimer() {
    // 计时器（`Timer`）组件的定期（`periodic`）构造函数，创建一个新的重复计时器。
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        _cancelTimer();
        _seconds = widget.countdown;
        inkWellStyle = _availableStyle;
        setState(() {});
        return;
      }
      _seconds--;
      _verifyStr = '已发送$_seconds' + 's';
      setState(() {});
      if (_seconds == 0) {
        _verifyStr = '重新发送';
      }
    });
  }

  void phoneLength() {
    if (widget.phone.isEmpty) {
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text("手机号不能为空！"),
      ));
      return;
    }
  }

  void _cancelTimer() {
    // 计时器（`Timer`）组件的取消（`cancel`）方法，取消计时器。
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // 墨水瓶（`InkWell`）组件，响应触摸的矩形区域。
    return widget.available
        ? InkWell(
            child: Text(
              '  $_verifyStr  ',
              style: inkWellStyle,
            ),
            onTap: (_seconds == widget.countdown)
                ? () {
                    if (widget.phone.isEmpty) {
                      Scaffold.of(context).showSnackBar(new SnackBar(
                        content: new Text("手机号不能为空！"),
                      ));
                      return;
                    } else {
                      _startTimer();
                      inkWellStyle = _unavailableStyle;
                      _verifyStr = '已发送$_seconds' + 's';
                      setState(() {});
                      widget.onTapCallback();
                    }
                  }
                : null,
          )
        : InkWell(
            child: Text(
              '  获取验证码  ',
              style: _unavailableStyle,
            ),
          );
  }
}
