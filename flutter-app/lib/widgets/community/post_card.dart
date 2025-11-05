import 'package:commute_mate/models/post.dart';
import 'package:commute_mate/screens/community/community_view.dart';
import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  Future<void> initPostData() async {
    final post = widget.post;
    // 추가적인 초기화 작업이 필요한 경우 여기에 작성

    loadPostData();
  }

  Future<void> loadPostData() async {
    // provi
    final post = widget.post;
    // post 데이터를 로드하는 로직을 여기에 작성
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(16),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CommunityView(post: post),
              ),
            );
          },
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(backgroundColor: Colors.blueGrey),
                      SizedBox(width: 10),
                      Text(
                        '@${post.user?.userId}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 5),
                      Text(
                        '•',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      SizedBox(width: 5),
                      Text(
                        _getTimeAgo(post.createdAt),
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                  Icon(Icons.more_horiz),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    post.title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      post.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.thumb_up_alt_outlined, size: 16),
                  SizedBox(width: 5),
                  Text(post.likeCount.toString()),
                  SizedBox(width: 10),
                  Icon(Icons.comment_outlined, size: 16),
                  SizedBox(width: 5),
                  Text(post.commentCount.toString()),
                  SizedBox(width: 10),
                  Icon(Icons.remove_red_eye_sharp, size: 16),
                  SizedBox(width: 5),
                  Text(post.readCount.toString()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _getTimeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return '방금 전';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes}분 전';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}시간 전';
  } else if (difference.inDays < 7) {
    return '${difference.inDays}일 전';
  } else {
    // 7일 이상이면 날짜로 표시
    return '${dateTime.year}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.day.toString().padLeft(2, '0')}';
  }
}
