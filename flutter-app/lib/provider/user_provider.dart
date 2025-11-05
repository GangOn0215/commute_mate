import 'package:commute_mate/models/user.dart';
import 'package:commute_mate/services/user_service.dart';
import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService = UserService();

  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

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
