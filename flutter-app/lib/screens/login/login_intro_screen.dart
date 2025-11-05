import 'dart:async';

import 'package:commute_mate/models/user.dart';
import 'package:commute_mate/screens/login/signup_screen.dart';
import 'package:commute_mate/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:commute_mate/screens/login/login_kakao_webview.dart';
import 'package:commute_mate/services/api/kakao_auth_service.dart';
import 'package:commute_mate/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class LoginIntroScreen extends StatefulWidget {
  const LoginIntroScreen({super.key});

  @override
  State<LoginIntroScreen> createState() => _LoginIntroScreenState();
}

class _LoginIntroScreenState extends State<LoginIntroScreen> {
  final KakaoAuthService _kakaoAuth = KakaoAuthService();
  TextEditingController userIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  UserService userService = UserService();
  User? user;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    userIdController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  Future<void> _loginWithKakao() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final loginUrl = await _kakaoAuth.getLoginUrl();

      if (!mounted) return;

      print('2단계: 웹뷰 열기');

      final code = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (context) => KakaoLoginWebView(loginUrl: loginUrl),
        ),
      );

      if (code == null) {
        print('로그인 취소됨');
        setState(() => _isLoading = false);
        return;
      }

      print('3단계: 로그인 처리 및 데이터 저장');
      final userData = await _kakaoAuth.loginWithCode(code);
      print('로그인 성공! 회원: ${userData['nickname']}');

      if (!mounted) return;

      // 환영 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${userData['nickname']} 님! 👋 반가워요!'),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Timer(const Duration(seconds: 2), () {
        if (mounted) {
          context.go('/home');
        }
      });
    } catch (e) {
      print('로그인 실패: $e');

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('로그인 실패: $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _login() async {
    if (userIdController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('이메일과 패스워드를 모두 입력해주세요.'),
          duration: const Duration(seconds: 1),
        ),
      );
      return;
    }

    user = await userService.getUserByLoginByIdPw(
      userIdController.text,
      passwordController.text,
    );

    if (!mounted) return;

    if (user != null) {
      context.read<UserProvider>().setUser(user!);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${user!.name}님 환영합니다!'),
          duration: const Duration(seconds: 1),
        ),
      );

      Timer(const Duration(seconds: 2), () {
        if (mounted) {
          context.go('/home');
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('로그인에 실패했습니다. 아이디와 패스워드를 확인해주세요.'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 30),
            child: Column(
              children: [
                Center(
                  child: Text(
                    '나만의 출퇴근 메이트',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    '퇴근냥이',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 45,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Jua',
                    ),
                  ),
                ),

                SizedBox(height: 24),
                TextField(
                  controller: userIdController,
                  decoration: InputDecoration(
                    hintText: '아이디를 입력하세요.',
                    filled: true,
                    fillColor: Colors.white,
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: '패스워드를 입력하세요.',
                    filled: true,
                    fillColor: Colors.white,
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                /**
                 * 아이디 & 패스워드 & 회원가입
                 */
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => (SignupScreen()),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.background,
                        foregroundColor: Color(0XFF757575),
                        overlayColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                      ),
                      child: Text('회원가입'),
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.background,
                            foregroundColor: Color(0XFF757575),
                            overlayColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            elevation: 0,
                          ),
                          child: Text('아이디 찾기'),
                        ),
                        SizedBox(width: 10),
                        Text('|', style: TextStyle(color: Color(0XFF757575))),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.background,
                            foregroundColor: Color(0XFF757575),
                            // 모든 효과 제거!
                            overlayColor: Colors.transparent, // 이게 핵심!
                            shadowColor: Colors.transparent, // 그림자도 제거
                            elevation: 0, // 높이도 0
                          ),
                          child: Text('패스워드 찾기'),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                //// 로그인 버튼
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Text(
                      '로그인',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ),

                //
                SizedBox(height: 40),
                Text('간편 로그인'),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(25),
                      child: SizedBox(
                        child: Image.asset(
                          'assets/images/naver_circle_icon.png',
                          width: 50,
                          height: 50,
                          cacheWidth: 50, // 디코딩할 너비
                          cacheHeight: 50, // 디코딩할 높이
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    InkWell(
                      onTap: () {
                        _loginWithKakao();
                      },
                      borderRadius: BorderRadius.circular(25),
                      child: SizedBox(
                        child: Image.asset(
                          'assets/images/kakao_circle_icon.png',
                          width: 50,
                          height: 50,
                          cacheWidth: 50, // 디코딩할 너비
                          cacheHeight: 50, // 디코딩할 높이
                        ),
                      ),
                    ),
                    SizedBox(width: 15),

                    InkWell(
                      onTap: () {
                        print('구글 클릭');
                      },
                      borderRadius: BorderRadius.circular(25),
                      child: SizedBox(
                        child: Image.asset(
                          'assets/images/google_circle_icon.png',
                          width: 50,
                          height: 50,
                          cacheWidth: 50, // 디코딩할 너비
                          cacheHeight: 50, // 디코딩할 높이
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
