import 'package:commute_mate/models/post.dart';
import 'package:commute_mate/provider/post_comment_provider.dart';
import 'package:commute_mate/widgets/community/comment/comment_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentList extends StatefulWidget {
  final Post post;
  const CommentList({super.key, required this.post});

  @override
  State<CommentList> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 화면 로드 후 댓글 불러오기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onLoadComments();
    });
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  Future<void> _onLoadComments() async {
    final postComment = context.read<PostCommentProvider>();
    await postComment.fetchCommentsByPostId(widget.post.id);
  }

  Future<void> _onRefresh() async {
    await _onLoadComments();
  }

  Future<void> _onLikePressed() async {
    // 좋아요 기능 구현 예정
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 24, 21, 21).withAlpha(16),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // 댓글 개수 표시
            Consumer<PostCommentProvider>(
              builder: (context, provider, child) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(width: 8),
                    const Text(
                      '댓글',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Jua',
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${provider.comments.length}',
                      style: const TextStyle(fontSize: 16, fontFamily: 'Jua'),
                    ),
                  ],
                );
              },
            ),

            // 댓글 목록
            Consumer<PostCommentProvider>(
              builder: (context, provider, child) {
                // 로딩 중
                if (provider.isLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                // 에러 발생
                if (provider.error != null) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          provider.error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _onLoadComments,
                          child: const Text('다시 시도'),
                        ),
                      ],
                    ),
                  );
                }

                // 댓글 없음
                if (provider.comments.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: Text(
                        '첫 댓글을 남겨보세요!',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                  );
                }

                // 댓글 목록 표시
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.comments.length,
                  itemBuilder: (context, index) {
                    final comment = provider.comments[index];
                    return CommentCard(comment: comment);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
