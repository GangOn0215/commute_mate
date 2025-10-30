// lib/services/kakao_login_service.dart
import 'package:commute_mate/services/api/kakao_auth_service.dart';

class KakaoLoginService {
  final KakaoAuthService _kakaoAuth = KakaoAuthService();

  // 로그인 상태 확인
  Future<bool> checkLoginStatus() async {
    return await _kakaoAuth.isLoggedIn();
  }

  // 로그인 URL 가져오기
  Future<String> getLoginUrl() async {
    return await _kakaoAuth.getLoginUrl();
  }

  // 인증 코드로 로그인
  Future<Map<String, dynamic>> loginWithCode(String code) async {
    return await _kakaoAuth.loginWithCode(code);
  }

  // 로그아웃
  Future<void> logout() async {
    await _kakaoAuth.logout();
  }
}
