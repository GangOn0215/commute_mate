import 'package:dio/dio.dart';
import 'base_api_service.dart';

class AuthApiService extends BaseApiService {
  /// 카카오 로그인 URL 가져오기
  Future<String> getKakaoLoginUrl() async {
    try {
      final response = await dio.get('/kakao/login');

      return handleResponse<String>(response, (data) {
        if (data['status'] == 'success') {
          return data['login_url'] as String;
        }
        throw Exception('로그인 URL을 가져올 수 없습니다');
      });
    } catch (e) {
      print('getKakaoLoginUrl 에러: $e');
      throw Exception('카카오 로그인 URL 요청 실패: ${getErrorMessage(e)}');
    }
  }

  /// 카카오 인가 코드로 토큰 및 사용자 정보 받기
  Future<Map<String, dynamic>> kakaoCallback(String code) async {
    try {
      print('📞 카카오 콜백 요청 - code: $code');

      final response = await dio.get(
        '/api/kakao/callback',
        queryParameters: {'code': code},
        options: Options(
          headers: {
            'Accept': 'application/json, text/plain, */*',
            'User-Agent': 'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36',
            'X-Requested-With': 'XMLHttpRequest',
          },
          responseType: ResponseType.json,
        ),
      );

      return handleResponse<Map<String, dynamic>>(response, (data) {
        print('✅ 파싱된 데이터: $data');

        if (data['status'] == 'success') {
          // 서버 응답 구조: {status, token, user}
          final userInfo = data['user'] as Map<String, dynamic>;
          final tokenInfo = data['token'] as Map<String, dynamic>;

          // Flutter 앱에서 사용할 형태로 재구성
          return {
            'kakao_id': userInfo['id'].toString(),
            'nickname': userInfo['properties']['nickname'],
            'profile_image': userInfo['properties']['profile_image'],
            'access_token': tokenInfo['access_token'],
            'refresh_token': tokenInfo['refresh_token'],
          };
        } else {
          throw Exception(data['message'] ?? '카카오 로그인 실패');
        }
      });
    } catch (e) {
      print('❌ kakaoCallback 에러: $e');
      throw Exception('카카오 콜백 실패: ${getErrorMessage(e)}');
    }
  }

  /// 로그아웃 (서버에 토큰 무효화 요청)
  Future<void> logout(String accessToken) async {
    try {
      await dio.post(
        '/api/kakao/logout',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
    } catch (e) {
      print('로그아웃 에러: $e');
      // 로그아웃 실패해도 로컬 데이터는 삭제
    }
  }

  /// 토큰 갱신
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      final response = await dio.post(
        '/api/kakao/refresh',
        data: {'refresh_token': refreshToken},
      );

      return handleResponse<Map<String, dynamic>>(response, (data) {
        if (data['status'] == 'success') {
          return {
            'access_token': data['access_token'],
            'refresh_token': data['refresh_token'],
          };
        }
        throw Exception('토큰 갱신 실패');
      });
    } catch (e) {
      print('토큰 갱신 에러: $e');
      throw Exception('토큰 갱신 실패: ${getErrorMessage(e)}');
    }
  }
}
