import 'package:flutter/material.dart';
import 'package:commute_mate/config/secrets/secrets.dart';
import 'package:commute_mate/core/work_config.dart';
import 'package:commute_mate/theme/app_theme.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'routes/app_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WorkConfig.instance.load(); // 저장된 값 불러오기

  KakaoSdk.init(nativeAppKey: kakaoNativeKey, javaScriptAppKey: kakaoJsKey);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,

      // 전역으로 적용할 테마
      theme: AppTheme.light,
    );
  }
}
