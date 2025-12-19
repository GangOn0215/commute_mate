import 'package:commute_mate/models/user.dart';
import 'package:commute_mate/services/auth_service.dart';
import 'package:commute_mate/services/user_service.dart';
import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService = UserService();
  final AuthService _authService = AuthService();

  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;

  Future<void> fetchUser(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners(); // ← 로딩 상태 전달

    try {
      _user = await _userService.getUserById(id);
      print('✅ [UserProvider] 불러온 사용자: ${_user?.name}');
    } catch (e) {
      print('❌ [UserProvider] 오류: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners(); // ← 로딩 상태 전달
    }
  }

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  /// 로그인 및 로그인 정보 저장
  Future<void> loginAndSave(User user) async {
    try {
      _user = user;
      if (user.id != null) {
        await _authService.saveLoginInfo(user.id!);
      }
      notifyListeners();
      print('✅ [UserProvider] 로그인 및 정보 저장 완료');
    } catch (e) {
      print('❌ [UserProvider] 로그인 정보 저장 실패: $e');
      rethrow;
    }
  }

  /// 자동 로그인 시도
  Future<bool> tryAutoLogin() async {
    try {
      final userId = await _authService.getSavedUserId();

      if (userId == null) {
        print('✅ [UserProvider] 저장된 로그인 정보 없음');
        return false;
      }

      print('✅ [UserProvider] 자동 로그인 시도: userId=$userId');
      await fetchUser(userId);

      return _user != null;
    } catch (e) {
      print('❌ [UserProvider] 자동 로그인 실패: $e');
      return false;
    }
  }

  /// 로그아웃
  Future<void> logout() async {
    try {
      await _authService.logout();
      _user = null;
      _error = null;
      notifyListeners();
      print('✅ [UserProvider] 로그아웃 완료');
    } catch (e) {
      print('❌ [UserProvider] 로그아웃 실패: $e');
      rethrow;
    }
  }

  Future<void> refreshUser(int id) async {
    await fetchUser(id);
  }

  Future<User> getUser(int id) async {
    try {
      User user = await _userService.getUserById(id);
      return user;
    } catch (e) {
      print('❌ [UserProvider] 사용자 상세 조회 오류: $e');
      rethrow;
    }
  }

  Future<void> createUser(User user) async {
    try {
      User newUser = (await _userService.signup(user)) as User;
      _user = newUser; // 새 사용자를 맨 앞에 추가

      notifyListeners();
    } catch (e) {
      print('❌ [UserProvider] 사용자 생성 오류: $e');
      rethrow;
    }
  }
}
