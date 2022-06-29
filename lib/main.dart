import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:wechat/utils/language_util_v2.dart';

import 'app_pages.dart';
import 'color/colors.dart';
import 'controller/chat_controller.dart';
import 'controller/user_controller.dart';
import 'language/translation_service.dart';
import 'package:leancloud_storage/leancloud.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(Platform.isIOS){
    BMFMapSDK.setApiKeyAndCoordType('请输入百度开放平台申请的iOS端API KEY', BMF_COORD_TYPE.BD09LL);
  }else if(Platform.isAndroid){// Android 目前不支持接口设置Apikey,
    BMFMapSDK.setCoordType(BMF_COORD_TYPE.BD09LL);
  }
  // LeanCloud.initialize('ugJfJQ7FWkwaPfex5af1R5Pb-gzGzoHsz', 'qHQJqjsXzj5XK9gwGLB59OYI',server: 'https://www.douyin.com', queryCache: LCQueryCache());
  LeanCloud.initialize('JN2Q4XReVkr7sQYEmma3bT6R-MdYXbMMI', 'pgktbsL98hKS2hzdi3OeJ8Pe', queryCache: LCQueryCache());

  await SpUtil.getInstance();
  runApp(const MyApp());
  if(Platform.isAndroid) {
    initAndroid();
  }
}

void initAndroid(){
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent,statusBarBrightness: Brightness.dark));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    Get.put(UserController(),permanent: true);
    Get.put(ChatController(),permanent: true);
    ///状态栏字体颜色
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  }

  @override
  Widget build(BuildContext context) {
    setDesignWHD(750.0, 1624);
    return GetMaterialApp(
      title: '微信',
      debugShowCheckedModeBanner: false,
      theme: Colours.themeData(),
      darkTheme: Colours.themeData(),
      initialRoute: '/',
      getPages: AppPages.routes,
      onGenerateRoute: (settings){
        print('onGenerateRoute ${settings.name}');
        return null;
      },
      supportedLocales: const [
        Locale('zh', 'CN'),
      ],
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: FlutterSmartDialog.init(
        // loadingBuilder: (context,child){
        //   return Container(
        //     decoration: Colours.c_212129.boxDecoration(borderRadius: 12.w),
        //     width: 200.w,
        //     height: 200.w
        //     child: Column(
        //       children: [
        //         Text('')
        //     ],
        //   ),
        //   );
        // }
      ),
      translations: TranslationService(),
      locale: LanguageUtilV2.initLanguage().toLocale(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
