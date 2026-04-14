import 'package:commute_mate/models/post_comment.dart';
import 'package:commute_mate/services/post_comment_service.dart';
import 'package:flutter/foundation.dart';

class PostCommentProvider extends ChangeNotifier {
  final PostCommentService _postCommentService;

  PostCommentProvider({PostCommentService? postCommentService})
    : _postCommentService = postCommentService ?? PostCommentService();

  List<PostComment> _comments = [];
  bool _isLoading = false;
  String? _error;
  int? _currentPostId;

  // 답글 모드 상태
  int? _replyingToCommentId;
  String? _replyingToNickname;

  List<PostComment> get comments => _comments;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int? get currentPostId => _currentPostId;
  int? get replyingToCommentId => _replyingToCommentId;
  String? get replyingToNickname => _replyingToNickname;

  /// 답글 모드 시작
  void startReply(int commentId, String nickname) {
    _replyingToCommentId = commentId;
    _replyingToNickname = nickname;
    notifyListeners();
  }

  /// 답글 모드 취소
  void cancelReply() {
    _replyingToCommentId = null;
    _replyingToNickname = null;
    notifyListeners();
  }

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
      if (kDebugMode)
        print('[PostCommentProvider] fetchCommentsByPostId 오류: $e');
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

  /// 댓글/대댓글 생성
  Future<bool> createComment(PostComment comment) async {
    try {
      PostComment newComment = await _postCommentService.createdPostComment(
        comment,
      );

      if (comment.parentId != null) {
        // 대댓글: 부모 댓글의 replies에 추가
        final parentIndex = _comments.indexWhere(
          (c) => c.id == comment.parentId,
        );
        if (parentIndex != -1) {
          final parent = _comments[parentIndex];
          _comments[parentIndex] = parent.copyWith(
            replies: [...parent.replies, newComment],
          );
        }
      } else {
        // 일반 댓글: 목록 맨 앞에 추가
        _comments.insert(0, newComment);
      }

      cancelReply();
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
      if (kDebugMode) print('[PostCommentProvider] updateComment 오류: $e');
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
      if (kDebugMode) print('[PostCommentProvider] deleteComment 오류: $e');
      notifyListeners();
      return false;
    }
  }

  /// 댓글 좋아요 토글 (낙관적 업데이트)
  Future<void> toggleLike(int commentId, int userId) async {
    final index = _comments.indexWhere((c) => c.id == commentId);
    if (index == -1) return;

    final comment = _comments[index];
    final optimisticLiked = !comment.isLiked;
    _comments[index] = comment.copyWith(
      isLiked: optimisticLiked,
      likeCount: optimisticLiked ? comment.likeCount + 1 : comment.likeCount - 1,
    );
    notifyListeners();

    try {
      final result = await _postCommentService.toggleLike(commentId, userId);
      _comments[index] = _comments[index].copyWith(
        isLiked: result.liked,
        likeCount: result.likeCount,
      );
      notifyListeners();
    } catch (e) {
      // 롤백
      _comments[index] = _comments[index].copyWith(
        isLiked: !optimisticLiked,
        likeCount: optimisticLiked
            ? _comments[index].likeCount - 1
            : _comments[index].likeCount + 1,
      );
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clear() {
    _comments = [];
    _isLoading = false;
    _error = null;
    _currentPostId = null;
    _replyingToCommentId = null;
    _replyingToNickname = null;
    notifyListeners();
  }
}
