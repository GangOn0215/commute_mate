import 'package:commute_mate/models/post.dart';
import 'package:commute_mate/provider/post_comment_provider.dart';
import 'package:commute_mate/widgets/community/comment/comment_card.dart';
import 'package:commute_mate/widgets/community/comment/comment_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentList extends StatefulWidget {
  final Post post;
  const CommentList({super.key, required this.post});

  @override
  State<CommentList> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  // ── Design Tokens ──────────────────────────────────────
  static const _ink = Color(0xFF09090B);
  static const _muted = Color(0xFF71717A);
  static const _border = Color(0xFFE4E4E7);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadComments());
  }

  Future<void> _loadComments() async {
    if (!mounted) return;
    await context
        .read<PostCommentProvider>()
        .fetchCommentsByPostId(widget.post.id);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostCommentProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Row(
                children: [
                  const Text(
                    '댓글',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _ink,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _border,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${provider.comments.length}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _muted,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Body ────────────────────────────────────
            if (provider.isLoading)
              const Column(
                children: [
                  CommentSkeleton(),
                  CommentSkeleton(),
                  CommentSkeleton(),
                ],
              )
            else if (provider.error != null)
              _ErrorState(error: provider.error!, onRetry: _loadComments)
            else if (provider.comments.isEmpty)
              const _EmptyState()
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.comments.length,
                itemBuilder: (_, i) {
                  final comment = provider.comments[i];
                  final isLast = i == provider.comments.length - 1;
                  return Column(
                    children: [
                      CommentCard(
                        comment: comment,
                        onReply: () => provider.startReply(
                          comment.id!,
                          comment.user?.nickname ?? '익명',
                        ),
                      ),
                      // 마지막 댓글엔 구분선 없음
                      if (!isLast)
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: _border,
                        ),
                    ],
                  );
                },
              ),
          ],
        );
      },
    );
  }
}

// ── Error State ────────────────────────────────────────────
class _ErrorState extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorState({required this.error, required this.onRetry});

  static const _muted = Color(0xFF71717A);
  static const _border = Color(0xFFE4E4E7);
  static const _ink = Color(0xFF09090B);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Column(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 36,
              color: Color(0xFFEF4444),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: const TextStyle(fontSize: 13, color: _muted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: _border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '다시 시도',
                  style: TextStyle(fontSize: 13, color: _ink),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty State ────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.chat_bubble_outline_rounded,
              size: 36,
              color: Color(0xFFD4D4D8),
            ),
            SizedBox(height: 10),
            Text(
              '첫 댓글을 남겨보세요',
              style: TextStyle(fontSize: 14, color: Color(0xFF71717A)),
            ),
          ],
        ),
      ),
    );
  }
}
