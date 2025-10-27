import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';

class BaseApiService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['API_URL'] ?? '',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  BaseApiService() {
    // 인터셉터 추가 - 응답 로깅
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('🌐 REQUEST[${options.method}] => PATH: ${options.path}');
          print('🌐 QUERY: ${options.queryParameters}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ RESPONSE[${response.statusCode}] => DATA: ${response.data}');
          return handler.next(response);
        },
        onError: (error, handler) {
          print(
            '❌ ERROR[${error.response?.statusCode}] => MESSAGE: ${error.message}',
          );
          print('❌ ERROR DATA: ${error.response?.data}');
          return handler.next(error);
        },
      ),
    );
  }

  /// 응답 처리 헬퍼 메서드
  T handleResponse<T>(Response response, T Function(dynamic data) parser) {
    print('🔍 handleResponse - statusCode: ${response.statusCode}');
    print('🔍 handleResponse - data type: ${response.data.runtimeType}');

    // HTML 응답 체크
    if (response.data is String) {
      final dataStr = response.data as String;
      if (dataStr.contains('<!doctype html>') || dataStr.contains('<html')) {
        throw Exception('서버가 HTML을 반환했습니다. API 엔드포인트를 확인하세요.');
      }
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        // response.data가 이미 Map이면 그대로 사용
        final data = response.data is Map
            ? response.data
            : {'data': response.data};
        return parser(data);
      } catch (e, stackTrace) {
        print('❌ parser 에러: $e');
        print('❌ stackTrace: $stackTrace');
        throw Exception('데이터 파싱 실패: $e');
      }
    } else {
      throw Exception('HTTP ${response.statusCode}: ${response.data}');
    }
  }

  /// 에러 메시지 추출
  String getErrorMessage(dynamic error) {
    if (error is DioException) {
      if (error.response != null) {
        final data = error.response?.data;
        if (data is Map && data.containsKey('message')) {
          return data['message'];
        }
        return error.response?.statusMessage ?? '알 수 없는 에러';
      }

      // 네트워크 에러 타입별 메시지
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return '연결 시간 초과';
        case DioExceptionType.sendTimeout:
          return '요청 전송 시간 초과';
        case DioExceptionType.receiveTimeout:
          return '응답 수신 시간 초과';
        case DioExceptionType.connectionError:
          return '네트워크 연결 실패';
        default:
          return error.message ?? '네트워크 에러';
      }
    }
    return error.toString();
  }
}
