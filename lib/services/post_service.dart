import 'package:commute_mate/models/post.dart';
import 'package:dio/dio.dart';

class PostService {
  // 싱글톤 인스턴스
  static final PostService _instance = PostService._internal();

  factory PostService() {
    return _instance;
  }

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://soft41500.store/api/',
      connectTimeout: Duration(seconds: 3),
      receiveTimeout: Duration(seconds: 3),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  PostService._internal() {
    // You can add interceptors or other configurations here if needed
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // 요청 전에 수행할 작업
          print('REQUEST[${options.method}] => PATH: ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // 응답을 받은 후에 수행할 작업
          print('RESPONSE[${response.statusCode}] => DATA: ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          // 오류가 발생했을 때 수행할 작업
          print('ERROR[${e.response?.statusCode}] => MESSAGE: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  Future<List<Post>> getPosts() async {
    try {
      print('Fetching posts from API...');
      final response = await _dio.get('/posts/list');
      // Handle the response data
      print('Posts fetched successfully:');
      // print(response.data);

      // 서버가 { "posts": [...] } 형태로 보내는 경우
      if (response.data is Map) {
        List<dynamic> data =
            response.data['posts'] ?? response.data['data'] ?? [];
        return data.map((json) => Post.fromJson(json)).toList();
      }

      // 서버가 [...] 형태로 보내는 경우
      if (response.data is List) {
        List<dynamic> data = response.data;
        return data.map((json) => Post.fromJson(json)).toList();
      }

      // 예상치 못한 응답 형태의 경우 빈 리스트 반환
      return [];
    } catch (e) {
      // Handle error
      print('Error fetching posts: $e');
      return [];
    }
  }

  // 게시글 상세 조회 (GET)
  Future<Post> getPost(int id) async {
    try {
      final response = await _dio.get('/posts/$id');
      return Post.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Post> createdPost(Post post) async {
    try {
      final response = await _dio.post('/posts/create', data: post.toJson());
      return Post.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // 게시글 수정 (PUT)
  Future<Post> updatePost(int id, Post post) async {
    try {
      final response = await _dio.put('/posts/$id', data: post.toJson());
      return Post.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // 게시글 삭제 (DELETE)
  Future<void> deletePost(int id) async {
    try {
      await _dio.delete('/posts/$id');
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
