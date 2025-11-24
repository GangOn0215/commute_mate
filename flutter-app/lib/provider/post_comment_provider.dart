import 'package:commute_mate/models/post_comment.dart';
import 'package:commute_mate/services/post_comment_service.dart';
import 'package:flutter/foundation.dart';
import 'package:commute_mate/models/post.dart';

class PostCommentProvider extends ChangeNotifier {
  final PostCommentService _postCommentService = PostCommentService();

  List<PostComment> _postComments = [];
  bool _isLoading = false;
  String? _error;

  List<PostComment> get postComments => _postComments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchPosts() async {
    _isLoading = true;
    _error = null;
    notifyListeners(); // ← 로딩 상태 전달

    try {
      _postComments = await _postCommentService.getPostComments();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners(); // ← 로딩 상태 전달
    }
  }

  Future<void> refreshPosts() async {
    await fetchPosts();
  }

  Future<Post> getPost(int id, int userId) async {
    try {
      Post post = await _postCommentService.getPost(id, userId);
      return post;
    } catch (e) {
      print('[PostProvider] 게시글 상세 조회 오류: $e');
      rethrow;
    }
  }

  Future<void> createPost(PostComment postComment) async {
    try {
      PostComment newPostComment = await _postCommentService.createdPostComment(
        postComment,
      );
      _postComments.insert(0, newPostComment); // 새 게시글을 맨 앞에 추가

      notifyListeners();
    } catch (e) {
      print('[PostCommentProvider] 게시글 댓글 생성 오류: $e');
      rethrow; // 오류를 다시 던져서 호출자에게 알림
    }
  }

  Future<void> updatePostComment(
    int postCommentId,
    PostComment postComment,
  ) async {
    try {
      PostComment updatedPost = await _postCommentService.updatePost(
        postCommentId,
        postComment,
      );
      int index = _postComments.indexWhere((p) => p.id == updatedPost.id);
      if (index != -1) {
        _postComments[index] = updatedPost;
        notifyListeners();
      }
    } catch (e) {
      print('[PostProvider] 게시글 수정 오류: $e');
      rethrow;
    }
  }

  Future<void> deletePostComment(int postCommentId) async {
    try {
      await _postCommentService.deletePost(postCommentId);
      _postComments.removeWhere((p) => p.id == postCommentId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
