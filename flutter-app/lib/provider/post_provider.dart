import 'package:flutter/foundation.dart';
import 'package:commute_mate/models/post.dart';
import 'package:commute_mate/services/post_service.dart';

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
}
