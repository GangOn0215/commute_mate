// widgets/post_detail_card.dart
import 'package:commute_mate/core/theme/app_colors.dart';
import 'package:commute_mate/models/post.dart';
import 'package:flutter/material.dart';

class PostDetailCard extends StatelessWidget {
  final Post post;

  const PostDetailCard({super.key, required this.post});

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 작성자 정보
                _AuthorInfo(userName: widget.post.user!.userId),
                IconButton(
                  onPressed: () {
                    _showCustomModalBottomSheet(
                      context: context,
                      post: widget.post,
                    );
                  },
                  icon: Icon(Icons.more_vert),
                ),
              ],
            ),

            Divider(height: 23, color: AppColors.grey100),

            // 제목
            Text(
              widget.post.title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),

            // 내용
            Text(widget.post.content, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
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
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit Post'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommunityUpdateForm(post: post),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete Post'),
                onTap: () {
                  Navigator.pop(context);
                  // 삭제 동작 추가
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
