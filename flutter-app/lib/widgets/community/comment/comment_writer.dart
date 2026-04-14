import 'package:commute_mate/models/post_comment.dart';
import 'package:commute_mate/provider/post_comment_provider.dart';
import 'package:commute_mate/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentWriter extends StatefulWidget {
  final int postId;

  const CommentWriter({super.key, required this.postId});

  @override
  State<CommentWriter> createState() => _CommentWriterState();
}

class _CommentWriterState extends State<CommentWriter> {
  // ── Design Tokens ──────────────────────────────────────
  static const _surface = Color(0xFFFFFFFF);
  static const _ink = Color(0xFF09090B);
  static const _muted = Color(0xFF71717A);
  static const _border = Color(0xFFE4E4E7);

  final TextEditingController _controller = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final user = context.read<UserProvider>().user;
    final provider = context.read<PostCommentProvider>();
    final messenger = ScaffoldMessenger.of(context);

    if (user == null) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('로그인이 필요합니다.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSending = true);

    final newComment = PostComment(
      id: 0,
      postId: widget.postId,
      userId: user.id,
      parentId: provider.replyingToCommentId,
      content: text,
      likeCount: 0,
      user: user,
    );

    try {
      final success = await provider.createComment(newComment);

      if (!mounted) return;

      if (success) {
        _controller.clear();
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              provider.replyingToCommentId != null
                  ? '답글을 등록했습니다.'
                  : '댓글을 등록했습니다.',
            ),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text('댓글 작성 실패: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostCommentProvider>(
      builder: (context, provider, _) {
        return Container(
          decoration: const BoxDecoration(
            color: _surface,
            border: Border(top: BorderSide(color: _border)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 답글 모드 배너
                if (provider.replyingToCommentId != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    color: const Color(0xFFF4F4F5),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.reply_rounded,
                          size: 14,
                          color: _muted,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${provider.replyingToNickname}님에게 답글 중',
                          style: const TextStyle(fontSize: 12, color: _muted),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: provider.cancelReply,
                          child: const Icon(
                            Icons.close_rounded,
                            size: 16,
                            color: _muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                // 입력창
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                          constraints: const BoxConstraints(maxHeight: 120),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F4F5),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: TextField(
                            controller: _controller,
                            minLines: 1,
                            maxLines: 5,
                            style: const TextStyle(fontSize: 14, color: _ink),
                            decoration: InputDecoration(
                              hintText: provider.replyingToCommentId != null
                                  ? '${provider.replyingToNickname}님에게 답글 쓰기...'
                                  : '댓글을 입력하세요...',
                              hintStyle: const TextStyle(
                                color: _muted,
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _isSending ? null : _submit,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _isSending
                                ? _ink.withValues(alpha: 0.5)
                                : _ink,
                            shape: BoxShape.circle,
                          ),
                          child: _isSending
                              ? const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(
                                  Icons.arrow_upward_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
