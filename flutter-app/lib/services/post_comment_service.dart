import 'package:commute_mate/models/post.dart';
import 'package:commute_mate/models/post_comment.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PostCommentService {
  // 싱글톤 인스턴스
  static final PostCommentService _instance = PostCommentService._internal();

  factory PostCommentService() {
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

  PostCommentService._internal() {
    // You can add interceptors or other configurations here if needed
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // 응답을 받은 후에 수행할 작업
          // print('RESPONSE[${response.statusCode}] => DATA: ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          return handler.next(e);
        },
      ),
    );
  }

  Future<List<PostComment>> getPostComments() async {
    try {
      final response = await _dio.get('/post_comment');
      // Handle the response data

      if (response.data is List) {
        final List<dynamic> jsonList = response.data as List<dynamic>;
        final posts = jsonList
            .map((e) => PostComment.fromJson(e as Map<String, dynamic>))
            .toList();

        return posts;
      }

      return [];
    } catch (e) {
      // Handle error
      print('Error fetching posts: $e');
      return [];
    }
  }

  // 게시글 상세 조회 (GET)
  Future<Post> getPost(int id, int userId) async {
    try {
      final response = await _dio.post(
        '/posts/$id/view',
        queryParameters: {'userId': userId},
      );
      return Post.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // 게시글 생성 (POST)
  Future<PostComment> createdPostComment(PostComment postComment) async {
    try {
      final response = await _dio.post(
        '/post_comments',
        data: postComment.toJson(),
      );
      return PostComment.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // 게시글 수정 (PUT)
  Future<PostComment> updatePost(int id, PostComment postComment) async {
    try {
      final response = await _dio.put(
        '/post_comments/$id',
        data: postComment.toJson(),
      );
      return PostComment.fromJson(response.data);
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
