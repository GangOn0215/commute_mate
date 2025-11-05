// widgets/post_detail_card.dart
import 'package:commute_mate/core/theme/app_colors.dart';
import 'package:commute_mate/models/post.dart';
import 'package:commute_mate/provider/post_provider.dart';
import 'package:commute_mate/provider/user_provider.dart';
import 'package:commute_mate/screens/community/community_update_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostDetailCard extends StatefulWidget {
  final Post post;

  const PostDetailCard({super.key, required this.post});

  @override
  State<PostDetailCard> createState() => _PostDetailCardState();
}

class _PostDetailCardState extends State<PostDetailCard> {
  bool isLoading = false;
  bool _isMyPost = false;
  late Post _post;

  @override
  void initState() {
    super.initState();

    loadPostData();
    _checkMyPost();
  }

  Future<Post?> loadPostData() async {
    isLoading = true;
    final provider = context.read<PostProvider>();
    try {
      Post detailedPost = await provider.getPost(widget.post.id!.toInt());

      setState(() {
        _post = detailedPost;
        isLoading = false;
      });

      // 필요한 경우 상태 업데이트
    } catch (e) {
      debugPrint('게시물 로드 실패: $e');
      setState(() => isLoading = false);
    }

    isLoading = false;
    return null;
  }

  Future<void> _checkMyPost() async {
    final user = context.read<UserProvider>().user;

    try {
      final provider = context.read<PostProvider>();
      _post = await provider.getPost(widget.post.id!.toInt());

      print(_post);
      print(user);

      setState(() {
        // 필요한 경우 상태 업데이트
        _isMyPost = _post.user!.id == user!.id;
      });
    } catch (e) {
      debugPrint('내 게시물 확인 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 24, 21, 21).withAlpha(16),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: !isLoading
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 작성자 정보
                      _AuthorInfo(userName: _post.user!.userId),
                      _isMyPost
                          ? IconButton(
                              onPressed: () {
                                _showCustomModalBottomSheet(
                                  context: context,
                                  post: _post,
                                );
                              },
                              icon: Icon(Icons.more_vert),
                            )
                          : Container(),
                    ],
                  ),

                  Divider(height: 23, color: AppColors.grey100),

                  // 제목
                  Text(
                    _post.title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 20),

                  // 내용
                  Text(_post.content, style: TextStyle(fontSize: 16)),
                ],
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<dynamic> _showCustomModalBottomSheet<T>({
    required BuildContext context,
    required Post post,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height: 150,
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                SizedBox(height: 20),
                _isMyPost
                    ? ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Edit Post'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CommunityUpdateForm(post: post),
                            ),
                          ).then((result) {
                            if (result == true) {
                              // 수정 후 필요한 작업 수행
                              setState(() {
                                Navigator.pop(context);
                                loadPostData();
                              });
                            }
                          });
                        },
                      )
                    : Container(),
                _isMyPost
                    ? ListTile(
                        leading: Icon(Icons.delete),
                        title: Text('Delete Post'),
                        onTap: () {
                          _showDeleteConfirmationDialog(context, post).then((
                            confirmed,
                          ) {
                            if (confirmed) {
                              if (!context.mounted) return;

                              final provider = context.read<PostProvider>();
                              provider.deletePost(post.id!.toInt()).then((_) {
                                if (!context.mounted) return;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('게시물이 삭제되었습니다.')),
                                );

                                Navigator.pop(context); // 모달 닫기
                                Navigator.pop(context, true); // 이전 화면으로 돌아가기
                              });
                            }
                          });
                          // 삭제 동작 추가
                        },
                      )
                    : Container(),
              ],
            ),
          ),
        );
      },
    );
  }
}

Future<bool> _showDeleteConfirmationDialog(BuildContext context, Post post) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Delete Post'),
        content: Text('정말 삭제 하시겠습니까??'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // 삭제 로직 추가

              Navigator.of(context).pop(true);
            },
            child: Text('Delete'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}

class _AuthorInfo extends StatelessWidget {
  final String userName;

  const _AuthorInfo({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(backgroundColor: AppColors.navSelected),
        SizedBox(width: 12),
        Text('@$userName'),
      ],
    );
  }
}
