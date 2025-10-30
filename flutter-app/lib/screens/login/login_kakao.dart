import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:commute_mate/models/kakao_user.dart';
import 'package:commute_mate/utils/user_preferences.dart';
import 'package:commute_mate/widgets/components/button/kakao_login_button.dart';
import 'package:commute_mate/widgets/components/button/kakao_logout_button.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class KakaoLogin extends StatefulWidget {
  const KakaoLogin({super.key});

  @override
  State<KakaoLogin> createState() => _KakaoLoginState();
}

class _KakaoLoginState extends State<KakaoLogin> {
  bool _isLoading = false;
  bool _loginFailed = false;
  bool _isLogin = false;

  @override
  void initState() {
    super.initState();

    _checkLogin();
    // _initLogin();
  }

  Future<bool> _checkLogin() async {
    try {
      KakaoUser? user = await UserPreferences.loadUser();

      if (user != null) {
        setState(() {
          _isLogin = true;
        });

        return true;
      }
    } catch (error) {
      print(error);
      return false;
    }

    return false;
  }

  Future<void> _initLogin() async {
    KakaoUser? kakaoUser = await _checkKakaoLogin();

    if (!mounted) return;

    if (kakaoUser != null) {
      context.go('/home');
    } else {
      setState(() {
        _isLoading = false;
        _loginFailed = true;
      });
    }
  }

  Future<KakaoUser?> _checkKakaoLogin() async {
    try {
      User userInfo;
      OAuthToken token;

      if (await isKakaoTalkInstalled()) {
        print('Kakao App Login');
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        print('Kakao Login');
        token = await UserApi.instance.loginWithKakaoAccount();
      }

      print('Get Kakao user');
      userInfo = await UserApi.instance.me();

      KakaoUser userData = KakaoUser.fromJson(userInfo.toJson());
      userData.setToken(token);

      await UserPreferences.saveUser(userData);

      return userData;
    } catch (error) {
      print('❌ 로그인 실패: $error');

      if (error is PlatformException && error.code == 'CANCELED') {
        print('사용자가 로그인 취소');
        return null;
      }

      try {
        print('🔁 fallback: 카카오계정 로그인 재시도');
        await UserApi.instance.loginWithKakaoAccount();
        return null;
      } catch (error) {
        print('❌ fallback 실패: $error');
        return null;
      }
    }
  }

  Future<void> _onLoginButtonPressed() async {
    setState(() {
      _isLoading = true;
      _loginFailed = false;
    });

    await _initLogin();
  }

  Future<void> _onKakaoLogout() async {
    try {
      UserPreferences.removeUser();

      Fluttertoast.showToast(
        msg: "로그아웃 완료",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (error) {
      print(">>> ERROR >>>");
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/kakao_login_medium_wide.png',
              height: 50,
            ),
            const SizedBox(height: 16),
            KakaoLoginButton(onLoginButtonPressed: _onLoginButtonPressed),
            KakaoLogoutButton(onKakaoLogout: _onKakaoLogout),
            if (_loginFailed)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  '로그인에 실패 했습니다. 다시 시도해주세요.',
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
