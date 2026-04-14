import 'package:commute_mate/models/post.dart';
import 'package:commute_mate/services/post_service.dart';
import 'package:flutter/foundation.dart';

class PostProvider extends ChangeNotifier {
  final PostService _postService = PostService();

  List<Post> _posts = [];
  bool _isLoading = false;
  String? _error;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchPosts() async {
    _isLoading = true;
    _error = null;
    notifyListeners(); // ← 로딩 상태 전달

    try {
      _posts = await _postService.getPosts();
      print('✅ [PostProvider] 불러온 게시글 수: ${_posts.length}');
    } catch (e) {
      print('❌ [PostProvider] 오류: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners(); // ← 로딩 상태 전달
    }
  }

  Future<void> refreshPosts() async {
    await fetchPosts();
  }

  Future<Post> getPost(int id) async {
    try {
      Post post = await _postService.getPost(id);
      return post;
    } catch (e) {
      print('❌ [PostProvider] 게시글 상세 조회 오류: $e');
      rethrow;
    }
  }

  Future<Post> getPostByUserId(int id, int userId) async {
    try {
      Post post = await _postService.getPostByUserId(id, userId);
      return post;
    } catch (e) {
      print('❌ [PostProvider] 게시글 상세 조회 오류: $e');
      rethrow;
    }
  }

  Future<void> createPost(Post post) async {
    try {
      Post newPost = await _postService.createdPost(post);
      _posts.insert(0, newPost); // 새 게시글을 맨 앞에 추가

      notifyListeners();
    } catch (e) {
      print('❌ [PostProvider] 게시글 생성 오류: $e');
      rethrow; // 오류를 다시 던져서 호출자에게 알림
    }
  }

  Future<void> updatePost(int postId, Post post) async {
    try {
      Post updatedPost = await _postService.updatePost(postId, post);
      int index = _posts.indexWhere((p) => p.id == updatedPost.id);
      if (index != -1) {
        _posts[index] = updatedPost;
        notifyListeners();
      }
    } catch (e) {
      print('[PostProvider] 게시글 수정 오류: $e');
      rethrow;
    }
  }

  Future<void> deletePost(int postId) async {
    try {
      await _postService.deletePost(postId);
      _posts.removeWhere((p) => p.id == postId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleLike(int postId, int userId) async {
    // 낙관적 업데이트: 서버 응답 전에 UI 먼저 반영
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = _posts[index];
      final optimisticLiked = !post.isLiked;
      _posts[index] = post.copyWith(
        isLiked: optimisticLiked,
        likeCount: optimisticLiked ? post.likeCount + 1 : post.likeCount - 1,
      );
      notifyListeners();
    }

    try {
      final result = await _postService.toggleLike(postId, userId);
      // 서버 응답으로 최종 확정
      if (index != -1) {
        _posts[index] = _posts[index].copyWith(
          isLiked: result.liked,
          likeCount: result.likeCount,
        );
        notifyListeners();
      }
    } catch (e) {
      // 실패 시 낙관적 업데이트 롤백
      if (index != -1) {
        final post = _posts[index];
        _posts[index] = post.copyWith(
          isLiked: !post.isLiked,
          likeCount: post.isLiked ? post.likeCount - 1 : post.likeCount + 1,
        );
        notifyListeners();
      }
      rethrow;
    }
  }
}
