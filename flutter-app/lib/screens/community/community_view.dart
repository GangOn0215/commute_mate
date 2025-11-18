import 'package:commute_mate/models/post.dart';
import 'package:commute_mate/widgets/community/post_detail_card.dart';
import 'package:flutter/material.dart';

class CommunityView extends StatelessWidget {
  final Post post;

  const CommunityView({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community'),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            PostDetailCard(post: post),
            SizedBox(height: 16.0),
            Container(
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

              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(width: 8),
                        Text(
                          '댓글',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text('3', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    Column(
                      children: [
                        // 여기에 댓글 위젯들을 추가하세요
                        SizedBox(height: 8),
                        Text('댓글 기능은 아직 구현되지 않았습니다.'),
                        SizedBox(height: 8),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
