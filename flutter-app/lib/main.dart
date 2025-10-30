import 'package:commute_mate/provider/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:commute_mate/config/secrets/secrets.dart';
import 'package:commute_mate/models/work_config.dart';
import 'package:commute_mate/core/theme/app_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';
import 'routes/app_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WorkConfig.instance.load(); // 저장된 값 불러오기
  await dotenv.load(fileName: ".env");

  KakaoSdk.init(nativeAppKey: kakaoNativeKey, javaScriptAppKey: kakaoJsKey);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<PostProvider>(create: (_) => PostProvider()),
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
