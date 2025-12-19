import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _userIdKey = 'user_id';
  static const String _isLoggedInKey = 'is_logged_in';

  // 싱글톤 패턴
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  /// 로그인 정보 저장
  Future<void> saveLoginInfo(int userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_userIdKey, userId);
      await prefs.setBool(_isLoggedInKey, true);
      print('✅ [AuthService] 로그인 정보 저장 완료: userId=$userId');
    } catch (e) {
      print('❌ [AuthService] 로그인 정보 저장 실패: $e');
      rethrow;
    }
  }

  /// 저장된 사용자 ID 가져오기
  Future<int?> getSavedUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;

      if (!isLoggedIn) {
        return null;
      }

      final userId = prefs.getInt(_userIdKey);
      print('✅ [AuthService] 저장된 userId: $userId');
      return userId;
    } catch (e) {
      print('❌ [AuthService] userId 불러오기 실패: $e');
      return null;
    }
  }

  /// 로그인 상태 확인
  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
      print('✅ [AuthService] 로그인 상태: $isLoggedIn');
      return isLoggedIn;
    } catch (e) {
      print('❌ [AuthService] 로그인 상태 확인 실패: $e');
      return false;
    }
  }

  /// 로그아웃 (로그인 정보 삭제)
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userIdKey);
      await prefs.setBool(_isLoggedInKey, false);
      print('✅ [AuthService] 로그아웃 완료');
    } catch (e) {
      print('❌ [AuthService] 로그아웃 실패: $e');
      rethrow;
    }
  }

  /// 모든 로그인 정보 삭제
  Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      print('✅ [AuthService] 모든 저장 정보 삭제 완료');
    } catch (e) {
      print('❌ [AuthService] 저장 정보 삭제 실패: $e');
      rethrow;
    }
  }
}