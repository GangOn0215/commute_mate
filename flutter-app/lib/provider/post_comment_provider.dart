import 'package:commute_mate/models/post_comment.dart';
import 'package:commute_mate/services/post_comment_service.dart';
import 'package:flutter/foundation.dart';

class PostCommentProvider extends ChangeNotifier {
  final PostCommentService _postCommentService;

  // 의존성 주입으로 변경 (테스트 용이)
  PostCommentProvider({PostCommentService? postCommentService})
    : _postCommentService = postCommentService ?? PostCommentService();

  List<PostComment> _comments = [];
  bool _isLoading = false;
  String? _error;

  // 현재 조회 중인 게시글 ID (특정 게시글의 댓글을 표시할 때)
  int? _currentPostId;

  List<PostComment> get comments => _comments;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int? get currentPostId => _currentPostId;

  /// 특정 게시글의 댓글 목록 조회
  Future<void> fetchCommentsByPostId(int postId) async {
    _isLoading = true;
    _error = null;
    _currentPostId = postId;
    notifyListeners();

    try {
      _comments = await _postCommentService.getPostComments(postId);
      _error = null;
    } catch (e) {
      _comments = [];
      _error = '댓글을 불러오는데 실패했습니다: ${e.toString()}';

      if (kDebugMode) {
        print('[PostCommentProvider] fetchCommentsByPostId 오류: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 댓글 목록 새로고침
  Future<void> refreshComments() async {
    if (_currentPostId != null) {
      await fetchCommentsByPostId(_currentPostId!);
    }
  }

  /// 댓글 생성
  Future<bool> createComment(PostComment comment) async {
    try {
      PostComment newComment = await _postCommentService.createdPostComment(
        comment,
      );

      _comments.insert(0, newComment);
      notifyListeners();

      return true;
    } catch (e) {
      _error = '댓글 작성에 실패했습니다: ${e.toString()}';

      notifyListeners();
      return false;
    }
  }

  /// 댓글 수정
  Future<bool> updateComment(int commentId, PostComment comment) async {
    try {
      PostComment updatedComment = await _postCommentService.updatePostComment(
        commentId,
        comment,
      );

      int index = _comments.indexWhere((c) => c.id == commentId);

      if (index != -1) {
        _comments[index] = updatedComment;
        notifyListeners();
        return true;
      }

      return false;
    } catch (e) {
      _error = '댓글 수정에 실패했습니다: ${e.toString()}';
      if (kDebugMode) {
        print('[PostCommentProvider] updateComment 오류: $e');
      }
      notifyListeners();
      return false;
    }
  }

  /// 댓글 삭제
  Future<bool> deleteComment(int commentId) async {
    try {
      await _postCommentService.deletePostComment(commentId);

      _comments.removeWhere((c) => c.id == commentId);
      notifyListeners();

      return true;
    } catch (e) {
      _error = '댓글 삭제에 실패했습니다: ${e.toString()}';

      if (kDebugMode) {
        print('[PostCommentProvider] deleteComment 오류: $e');
      }

      notifyListeners();
      return false;
    }
  }

  /// 에러 초기화
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// 상태 초기화
  void clear() {
    _comments = [];
    _isLoading = false;
    _error = null;
    _currentPostId = null;
    notifyListeners();
  }
}
