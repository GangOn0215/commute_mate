import 'package:commute_mate/models/post.dart';
import 'package:commute_mate/models/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

class UserService {
  // 싱글톤 인스턴스
  static final UserService _instance = UserService._internal();

  factory UserService() {
    return _instance;
  }

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "${dotenv.env['API_URL']}",
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 5),
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
      print('로그인 요청 시작: $userId');

      final response = await _dio.post(
        '/user/login',
        data: {'userId': userId, 'password': password},
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) {
            // 200과 401은 정상 응답으로 처리
            return status == 200 || status == 401;
          },
        ),
      );

      print('응답 수신: ${response.statusCode}');
      print('응답 데이터: ${response.data}');

      // 🎯 여기가 핵심! statusCode 체크
      if (response.statusCode == 200) {
        print('로그인 성공, User 파싱');
        return User.fromJson(response.data);
      } else if (response.statusCode == 401) {
        print('로그인 실패 (401)');
        return null;
      } else {
        print('예상치 못한 상태 코드: ${response.statusCode}');
        return null;
      }
    } on DioException catch (e) {
      // validateStatus로 허용하지 않은 다른 에러들 (500, 네트워크 에러 등)
      print('DioException 발생');
      print('에러 타입: ${e.type}');
      print('상태 코드: ${e.response?.statusCode}');
      print('에러 메시지: ${e.message}');
      rethrow;
    } catch (e) {
      print('예상치 못한 에러: $e');
      rethrow;
    }
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

  // 회원 정보 수정 (PUT)
  Future<User> updateUser(User user) async {
    try {
      final response = await _dio.put(
        '/user/${user.id}',
        data: user.toJson(),
      );
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ✅ 프로필 이미지 업로드
  Future<Map<String, dynamic>> uploadProfileImage(
    int userId,
    XFile imageFile,
  ) async {
    try {
      FormData formData;

      if (kIsWeb) {
        // 웹: 바이트 사용
        final bytes = await imageFile.readAsBytes();
        formData = FormData.fromMap({
          'image': MultipartFile.fromBytes(bytes, filename: imageFile.name),
        });
      } else {
        // 모바일: 파일 경로 사용
        formData = FormData.fromMap({
          'image': await MultipartFile.fromFile(
            imageFile.path,
            filename: 'profile.jpg',
          ),
        });
      }

      final response = await _dio.post(
        '/user/$userId/profile_image',
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
          // ✅ 업로드는 시간이 더 걸릴 수 있으므로
          sendTimeout: Duration(seconds: 30),
          receiveTimeout: Duration(seconds: 30),
        ),
        onSendProgress: (sent, total) {
          double progress = (sent / total * 100);
          print('업로드 진행률: ${progress.toStringAsFixed(0)}%');
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'imageUrl': response.data['fileUrl'],
          'message': response.data['message'] ?? '이미지 업로드 성공',
        };
      } else {
        throw Exception('업로드 실패: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ✅ 프로필 이미지 삭제
  Future<bool> deleteProfileImage(int userId) async {
    try {
      final response = await _dio.delete('/users/$userId/profile-image');

      if (response.statusCode == 200) {
        return true;
      }
      return false;
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
