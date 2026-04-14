import 'package:commute_mate/models/post_comment.dart';
import 'package:commute_mate/provider/post_comment_provider.dart';
import 'package:commute_mate/provider/user_provider.dart';
import 'package:commute_mate/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatelessWidget {
  final PostComment comment;
  final bool isReply;
  final VoidCallback? onReply;

  const CommentCard({
    super.key,
    required this.comment,
    this.isReply = false,
    this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CommentBody(comment: comment, isReply: isReply, onReply: onReply),
        if (!isReply && comment.replies.isNotEmpty)
          _ReplyBlock(replies: comment.replies),
      ],
    );
  }
}

// ── 댓글 단일 행 ──────────────────────────────────────────
class _CommentBody extends StatelessWidget {
  final PostComment comment;
  final bool isReply;
  final VoidCallback? onReply;

  const _CommentBody({
    required this.comment,
    required this.isReply,
    this.onReply,
  });

  static const _ink = Color(0xFF09090B);
  static const _muted = Color(0xFF71717A);
  static const _border = Color(0xFFE4E4E7);
  static const _red = Color(0xFFEF4444);

  @override
  Widget build(BuildContext context) {
    final profileImage = comment.user?.profileImageUrl;
    final double avatarSize = isReply ? 26 : 34;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: isReply ? 8 : 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatar(profileImage, avatarSize),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 닉네임 + 시간
                Row(
                  children: [
                    Text(
                      comment.user?.nickname ?? '익명',
                      style: TextStyle(
                        fontSize: isReply ? 12 : 13,
                        fontWeight: FontWeight.w600,
                        color: _ink,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        '·',
                        style: TextStyle(color: _muted, fontSize: 11),
                      ),
                    ),
                    Text(
                      getTimeAgo(comment.createdAt),
                      style: const TextStyle(fontSize: 11, color: _muted),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // 본문
                Text(
                  comment.content,
                  style: TextStyle(
                    fontSize: isReply ? 13 : 14,
                    color: _ink,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 6),

                // 액션
                Row(
                  children: [
                    // 좋아요 버튼
                    GestureDetector(
                      onTap: () => _handleLike(context),
                      child: Row(
                        children: [
                          Icon(
                            comment.isLiked
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 13,
                            color: comment.isLiked ? _red : _muted,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            comment.likeCount > 0
                                ? comment.likeCount.toString()
                                : '좋아요',
                            style: TextStyle(
                              fontSize: 11,
                              color: comment.isLiked ? _red : _muted,
                              fontWeight: comment.isLiked
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isReply) ...[
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: onReply,
                        child: _actionChip(
                          Icons.chat_bubble_outline_rounded,
                          '답글',
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleLike(BuildContext context) {
    final user = context.read<UserProvider>().user;
    if (user == null || comment.id == null) return;
    context.read<PostCommentProvider>().toggleLike(comment.id!, user.id!.toInt());
  }

  Widget _actionChip(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 13, color: _muted),
        const SizedBox(width: 3),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: _muted,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(String? imageUrl, double size) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          imageUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _defaultAvatar(size),
          loadingBuilder: (_, child, progress) =>
              progress == null ? child : _defaultAvatar(size),
        ),
      );
    }
    return _defaultAvatar(size);
  }

  Widget _defaultAvatar(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(color: _border, shape: BoxShape.circle),
      child: Icon(Icons.person_rounded, size: size * 0.52, color: _muted),
    );
  }
}

// ── 대댓글 블록 ────────────────────────────────────────────
class _ReplyBlock extends StatefulWidget {
  final List<PostComment> replies;

  const _ReplyBlock({required this.replies});

  @override
  State<_ReplyBlock> createState() => _ReplyBlockState();
}

class _ReplyBlockState extends State<_ReplyBlock> {
  static const _bg = Color(0xFFF9FAFB);
  static const _muted = Color(0xFF71717A);
  static const _border = Color(0xFFE4E4E7);

  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final count = widget.replies.length;
    final showAll = _expanded || count <= 1;
    final visible = showAll ? widget.replies : [widget.replies.first];

    return Container(
      margin: const EdgeInsets.only(left: 60, right: 16, top: 2, bottom: 12),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...visible.map(
            (reply) => _CommentBody(comment: reply, isReply: true),
          ),
          if (count > 1)
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: Row(
                  children: [
                    Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 14,
                      color: _muted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _expanded ? '답글 접기' : '답글 ${count - 1}개 더보기',
                      style: const TextStyle(
                        fontSize: 12,
                        color: _muted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
