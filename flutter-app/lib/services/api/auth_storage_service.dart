import 'package:commute_mate/services/storage_service.dart';

class AuthStorageService {
  final StorageService _storage = StorageService();

  // 키 상수
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userInfoKey = 'user_info';
  static const String _kakaoIdKey = 'kakao_id';

  /// 로그인 데이터 저장
  Future<void> saveLoginData(Map<String, dynamic> data) async {
    await _storage.setString(_accessTokenKey, data['access_token']);
    await _storage.setString(_refreshTokenKey, data['refresh_token']);
    await _storage.setString(_kakaoIdKey, data['kakao_id']);

    // 사용자 정보는 JSON으로 저장
    final userInfo = {
      'nickname': data['nickname'],
      'profile_image': data['profile_image'],
    };
    await _storage.setJson(_userInfoKey, userInfo);
  }

  /// Access Token 가져오기
  Future<String?> getAccessToken() async {
    return await _storage.getString(_accessTokenKey);
  }

  /// Refresh Token 가져오기
  Future<String?> getRefreshToken() async {
    return await _storage.getString(_refreshTokenKey);
  }

  /// 사용자 정보 가져오기
  Future<Map<String, dynamic>?> getUserInfo() async {
    return await _storage.getJson(_userInfoKey);
  }

  /// 카카오 ID 가져오기
  Future<String?> getKakaoId() async {
    return await _storage.getString(_kakaoIdKey);
  }

  /// 로그인 데이터 삭제 (로그아웃)
  Future<void> clearLoginData() async {
    await _storage.removeMultiple([
      _accessTokenKey,
      _refreshTokenKey,
      _userInfoKey,
      _kakaoIdKey,
    ]);
  }

  /// 로그인 여부 확인
  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
