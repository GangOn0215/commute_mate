import 'package:commute_mate/models/post.dart';
import 'package:commute_mate/provider/post_provider.dart';
import 'package:commute_mate/provider/user_provider.dart';
import 'package:commute_mate/screens/community/community_update_form.dart';
import 'package:commute_mate/utils/common.dart';
import 'package:commute_mate/widgets/community/post/post_detail_card_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostDetailCard extends StatefulWidget {
  final Post post;

  const PostDetailCard({super.key, required this.post});

  @override
  State<PostDetailCard> createState() => _PostDetailCardState();
}

class _PostDetailCardState extends State<PostDetailCard> {
  // ── Design Tokens ──────────────────────────────────────
  static const _ink = Color(0xFF09090B);
  static const _muted = Color(0xFF71717A);
  static const _border = Color(0xFFE4E4E7);
  static const _danger = Color(0xFFEF4444);

  bool _isLoading = false;
  bool _isMyPost = false;
  late Post _post;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
    _loadPost();
  }

  Future<void> _loadPost() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final provider = context.read<PostProvider>();
      final userId = context.read<UserProvider>().user?.id?.toInt();
      final postId = widget.post.id.toInt();

      final detailed = userId == null
          ? await provider.getPost(postId)
          : await provider.getPostByUserId(postId, userId);

      if (!mounted) return;

      final currentUser = context.read<UserProvider>().user;
      setState(() {
        _post = detailed;
        _isMyPost = currentUser != null && detailed.user?.id == currentUser.id;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('게시물 로드 실패: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleLike() async {
    final user = context.read<UserProvider>().user;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('로그인이 필요합니다.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final provider = context.read<PostProvider>();
    // 낙관적 업데이트: 로컬 상태도 즉시 반영
    final optimisticLiked = !_post.isLiked;
    setState(() {
      _post = _post.copyWith(
        isLiked: optimisticLiked,
        likeCount: optimisticLiked ? _post.likeCount + 1 : _post.likeCount - 1,
      );
    });

    try {
      await provider.toggleLike(_post.id.toInt(), user.id!.toInt());
    } catch (_) {
      // 실패 시 롤백
      if (mounted) {
        setState(() {
          _post = _post.copyWith(
            isLiked: !optimisticLiked,
            likeCount: optimisticLiked
                ? _post.likeCount - 1
                : _post.likeCount + 1,
          );
        });
      }
    }
  }

  void _showOptionsSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: _border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.edit_outlined, color: _ink),
                title: const Text(
                  '수정하기',
                  style: TextStyle(fontSize: 15, color: _ink),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CommunityUpdateForm(post: _post),
                    ),
                  ).then((result) {
                    if (result == true) _loadPost();
                  });
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.delete_outline_rounded,
                  color: _danger,
                ),
                title: const Text(
                  '삭제하기',
                  style: TextStyle(fontSize: 15, color: _danger),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _showDeleteDialog();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteDialog() {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          '게시물 삭제',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        content: const Text(
          '정말 삭제하시겠습니까?\n삭제된 게시물은 복구할 수 없습니다.',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('취소', style: TextStyle(color: _muted)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('삭제', style: TextStyle(color: _danger)),
          ),
        ],
      ),
    ).then((confirmed) async {
      if (confirmed != true || !mounted) return;
      final provider = context.read<PostProvider>();
      final messenger = ScaffoldMessenger.of(context);
      final navigator = Navigator.of(context);
      try {
        await provider.deletePost(_post.id.toInt());
        if (!mounted) return;
        messenger.showSnackBar(
          const SnackBar(
            content: Text('게시물이 삭제되었습니다.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        navigator.pop(true);
      } catch (e) {
        if (!mounted) return;
        messenger.showSnackBar(
          SnackBar(
            content: Text('삭제 실패: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const PostDetailSkeleton();

    final profileImage = _post.user?.profileImageUrl;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 작성자 정보 ────────────────────────────────
          Row(
            children: [
              _buildAvatar(profileImage),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _post.user?.nickname ?? '익명',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          getTimeAgo(_post.createdAt),
                          style: const TextStyle(fontSize: 12, color: _muted),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            '·',
                            style: TextStyle(color: _muted, fontSize: 12),
                          ),
                        ),
                        Text(
                          _post.category,
                          style: const TextStyle(fontSize: 12, color: _muted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (_isMyPost)
                GestureDetector(
                  onTap: _showOptionsSheet,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      border: Border.all(color: _border),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.more_horiz_rounded,
                      size: 18,
                      color: _muted,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, color: _border),
          const SizedBox(height: 16),

          // ── 제목 ──────────────────────────────────────
          Text(
            _post.title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: _ink,
              height: 1.3,
              letterSpacing: -0.3,
            ),
          ),

          const SizedBox(height: 12),

          // ── 내용 ──────────────────────────────────────
          Text(
            _post.content,
            style: const TextStyle(fontSize: 15, color: _ink, height: 1.6),
          ),

          const SizedBox(height: 20),

          // ── 하단 통계 ──────────────────────────────────
          Row(
            children: [
              GestureDetector(
                onTap: _toggleLike,
                child: Row(
                  children: [
                    Icon(
                      _post.isLiked
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      size: 16,
                      color: _post.isLiked
                          ? const Color(0xFFEF4444)
                          : _muted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _post.likeCount.toString(),
                      style: TextStyle(
                        fontSize: 13,
                        color: _post.isLiked
                            ? const Color(0xFFEF4444)
                            : _muted,
                        fontWeight: _post.isLiked
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _statItem(Icons.chat_bubble_outline_rounded, _post.commentCount),
              const Spacer(),
              Icon(
                Icons.visibility_outlined,
                size: 13,
                color: _muted.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 3),
              Text(
                _post.readCount.toString(),
                style: TextStyle(
                  fontSize: 12,
                  color: _muted.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(IconData icon, int count) {
    return Row(
      children: [
        Icon(icon, size: 16, color: _muted),
        const SizedBox(width: 4),
        Text(
          count.toString(),
          style: const TextStyle(fontSize: 13, color: _muted),
        ),
      ],
    );
  }

  Widget _buildAvatar(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          imageUrl,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _defaultAvatar(),
          loadingBuilder: (_, child, progress) =>
              progress == null ? child : _defaultAvatar(),
        ),
      );
    }
    return _defaultAvatar();
  }

  Widget _defaultAvatar() {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(color: _border, shape: BoxShape.circle),
      child: const Icon(Icons.person_rounded, size: 20, color: _muted),
    );
  }
}
