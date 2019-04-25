import 'package:flutter_demo/util/local_storage.dart';

class Api {
  static String webHost = "https://tst.oil66.com/user/";
  static String webHostUpdate = "https://tst.oil66.com/supplier/";

//  static final String CLINETYPE = "3"+"&openid="+LocalStorage.get("openid");
//  static final String OPENID = LocalStorage.get("openid");
//  static final String TOKEN = LocalStorage.get("token");

  //发送验证码
  static final String AUOTH=webHost + "ApiUser/send_auth";
  //登录
  static final String LOGIN=  webHost + "ApiUser/user_register";

  //token 校验
  static final String TOKENAUOTH =  webHost + "ApiUser/update_app_login_token";

  //banner 获取
  static final String HOMEBANNER =  webHost + "ApiOther/get_banner_list";

  //首页今日现货商品搜索条件列表接口
  static final String HOMETYPEGOODS =  webHost + "ApiGood/get_today_goods_search_list";

  //首页推荐列表
  static final String HOMEGOODSLIST =  webHost + "ApiGood/get_today_goods_list";











}
