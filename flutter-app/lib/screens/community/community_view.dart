import 'package:commute_mate/models/post.dart';
import 'package:commute_mate/models/post_comment.dart';
import 'package:commute_mate/provider/post_comment_provider.dart';
import 'package:commute_mate/provider/user_provider.dart';
import 'package:commute_mate/widgets/community/comment/comment_card.dart';
import 'package:commute_mate/widgets/community/post_detail_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommunityView extends StatefulWidget {
  final Post post;

  const CommunityView({super.key, required this.post});

  @override
  State<CommunityView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<CommunityView> {
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
      postId: widget.post.id,
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_outlined),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              // 게시글
              PostDetailCard(post: widget.post),
              const SizedBox(height: 16.0),

              // 댓글 섹션
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(
                        255,
                        24,
                        21,
                        21,
                      ).withAlpha(16),
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
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Jua',
                                ),
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
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
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
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
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
      ),
    );
  }
}
