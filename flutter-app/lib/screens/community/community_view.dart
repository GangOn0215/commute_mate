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
        child: PostDetailCard(post: post),
      ),
    );
  }
}
