import 'package:flutter/material.dart';
import 'package:commute_mate/screens/kakao_login_webview.dart';
import 'package:commute_mate/services/api/kakao_auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final KakaoAuthService _kakaoAuth = KakaoAuthService();
  bool _isLoading = false;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final isLoggedIn = await _kakaoAuth.isLoggedIn();

    if (mounted) {
      setState(() {
        _isLoggedIn = isLoggedIn;
      });
    }
  }

  Future<void> _loginWithKakao() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      print('1단계: 로그인 URL 요청');
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
      setState(() {
        _isLoggedIn = true;
      });
    } catch (e, stackTrace) {
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

  Future<void> _logout() async {
    setState(() => _isLoading = true);

    try {
      await _kakaoAuth.logout();

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoggedIn = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('로그아웃 완료')));
    } catch (e) {
      print('로그아웃 실패: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isLoggedIn ? '로그인 상태' : '카카오로 시작하기',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : (_isLoggedIn ? _logout : _loginWithKakao),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFEE500),
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      _isLoggedIn ? '로그아웃' : '카카오 로그인',
                      style: const TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
