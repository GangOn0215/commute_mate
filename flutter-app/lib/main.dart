import 'package:commute_mate/core/theme/app_theme.dart';
import 'package:commute_mate/models/work_config.dart';
import 'package:commute_mate/provider/post_provider.dart';
import 'package:commute_mate/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';

import 'routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WorkConfig.instance.load(); // 저장된 값 불러오기
  await dotenv.load(fileName: ".env");

  KakaoSdk.init(
    nativeAppKey: dotenv.env['kakaoNativeKey'],
    javaScriptAppKey: dotenv.env['javaScriptAppKey'],
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<PostProvider>(create: (_) => PostProvider()),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        // 다른 Provider들도 여기에 추가
      ],
      child: MainApp(),
    ),
  );
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
