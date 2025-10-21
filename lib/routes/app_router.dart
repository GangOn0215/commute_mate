import 'package:flutter/material.dart';
import 'package:commute_mate/screens/account_screen.dart';
import 'package:commute_mate/screens/community_screen.dart';
import 'package:commute_mate/screens/login_kakao.dart';
import 'package:commute_mate/screens/login_intro_screen.dart';
import 'package:commute_mate/screens/statistics_screen.dart';
import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/timer_screen.dart';
import '../common/footer_navigation.dart';
import 'app_routes.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => SplashScreen()),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => LoginIntroScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: const FooterNavigation(),
        );
      },
      routes: [
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => HomeScreen(),
        ),
        GoRoute(
          path: AppRoutes.statistics,
          builder: (context, state) => StatisticsPage(),
        ),
        GoRoute(
          path: AppRoutes.community,
          builder: (context, state) => CommunityScreen(),
        ),
        GoRoute(
          path: AppRoutes.timer,
          builder: (context, state) => TimerScreen(),
        ),
        GoRoute(
          path: AppRoutes.account,
          builder: (context, state) => AccountScreen(),
        ),
        GoRoute(
          path: AppRoutes.kakaoLogin,
          builder: (context, state) => KakaoLogin(),
        ),
      ],
    ),
  ],
);
