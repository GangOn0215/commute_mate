import 'package:commute_mate/services/api/auth_api_service.dart';
import 'package:commute_mate/services/api/auth_storage_service.dart';

class KakaoAuthService {
  final AuthApiService _authApi = AuthApiService();
  final AuthStorageService _authStorage = AuthStorageService();

  /// 카카오 로그인 URL 가져오기
  Future<String> getLoginUrl() async {
    return await _authApi.getKakaoLoginUrl();
  }

  /// 인가 코드로 로그인 처리
  Future<Map<String, dynamic>> loginWithCode(String code) async {
    // 1. 서버에서 토큰과 사용자 정보 받기
    final userData = await _authApi.kakaoCallback(code);

    // 2. 로컬에 저장 (AuthStorageService 사용)
    await _authStorage.saveLoginData(userData);

    return userData;
  }

  /// 로그아웃
  Future<void> logout() async {
    // 서버 API 호출 제거
    // 로컬 데이터만 삭제
    await _authStorage.clearLoginData();
  }

  /// 로그인 여부 확인
  Future<bool> isLoggedIn() async {
    return await _authStorage.isLoggedIn();
  }

  /// 현재 사용자 정보 가져오기
  Future<Map<String, dynamic>?> getCurrentUser() async {
    return await _authStorage.getUserInfo();
  }

  /// Access Token 가져오기 (API 요청시 사용)
  Future<String?> getAccessToken() async {
    return await _authStorage.getAccessToken();
  }

  /// Refresh Token 가져오기
  Future<String?> getRefreshToken() async {
    return await _authStorage.getRefreshToken();
  }

  /// 카카오 ID 가져오기
  Future<String?> getKakaoId() async {
    return await _authStorage.getKakaoId();
  }
}
