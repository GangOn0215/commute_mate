import 'package:commute_mate/models/post.dart';
import 'package:commute_mate/models/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserService {
  // 싱글톤 인스턴스
  static final UserService _instance = UserService._internal();

  factory UserService() {
    return _instance;
  }

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "${dotenv.env['API_URL']}",
      connectTimeout: Duration(seconds: 3),
      receiveTimeout: Duration(seconds: 3),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  UserService._internal() {
    // You can add interceptors or other configurations here if needed
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // 요청 전에 수행할 작업
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // 응답을 받은 후에 수행할 작업
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          // 오류가 발생했을 때 수행할 작업
          return handler.next(e);
        },
      ),
    );
  }

  Future<User> getUserById(int id) async {
    try {
      final response = await _dio.get('/user/$id');
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<User?> getUserByLoginByIdPw(String userId, String password) async {
    try {
      final response = await _dio.post(
        '/user/login',
        data: {'userId': userId, 'password': password},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print(response);

      return User.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // 에러 메시지 추출
        String errorMessage =
            e.error?.toString() ??
            e.response?.data['message'] ??
            'Login failed';

        // UI에 표시
        print('Login Error: $errorMessage');

        return null;
      }
    }
    return null;
  }

  // 회원 생성 (POST)
  Future<Post> signup(User user) async {
    try {
      final response = await _dio.post('/user/signup', data: user.toJson());
      return Post.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // 에러 핸들링
  String _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return '연결 시간 초과';
      case DioExceptionType.sendTimeout:
        return '전송 시간 초과';
      case DioExceptionType.receiveTimeout:
        return '응답 시간 초과';
      case DioExceptionType.badResponse:
        return '서버 오류: ${e.response?.statusCode}';
      case DioExceptionType.cancel:
        return '요청 취소됨';
      default:
        return '네트워크 오류: ${e.message}';
    }
  }
}
