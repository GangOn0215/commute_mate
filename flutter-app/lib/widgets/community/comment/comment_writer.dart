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
  TextEditingController commentController = TextEditingController();

  Future<void> _onCommentPressed() async {
    final user = context.read<UserProvider>().user;
    final postComment = context.read<PostCommentProvider>();

    String comment = commentController.text.trim();

    // 빈 댓글 체크
    if (comment.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('댓글 내용을 입력해주세요.'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('로그인이 필요합니다.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newPostComment = PostComment(
      id: 0,
      postId: widget.postId,
      userId: user.id,
      content: comment,
      likeCount: 0,
      user: user,
    );

    try {
      bool success = await postComment.createComment(newPostComment);

      if (!mounted) return;

      if (success) {
        // 댓글 입력창 초기화
        commentController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('댓글을 등록했습니다.'),
            backgroundColor: Color(0xFF6C5CE7),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('댓글 작성에 실패했습니다: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: commentController,
              maxLines: 4,
              minLines: 1,
              decoration: InputDecoration(
                hintText: '댓글을 입력하세요...',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                focusColor: Colors.white,
                fillColor: Colors.white,
                prefixIconColor: Colors.white,
                hoverColor: Colors.white,
                filled: true,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ElevatedButton(
              onPressed: _onCommentPressed,
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(12),
              ),
              child: const Icon(Icons.send),
            ),
          ),
        ],
      ),
    );
  }
}
