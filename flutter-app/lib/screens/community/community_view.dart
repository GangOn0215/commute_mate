import 'package:commute_mate/models/post.dart';
import 'package:commute_mate/widgets/community/comment/comment_container.dart';
import 'package:commute_mate/widgets/community/comment/comment_list.dart';
import 'package:commute_mate/widgets/community/comment/comment_writer.dart';
import 'package:commute_mate/widgets/community/post_detail_card.dart';
import 'package:flutter/material.dart';

class CommunityView extends StatefulWidget {
  final Post post;

  const CommunityView({super.key, required this.post});

  @override
  State<CommunityView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<CommunityView> {
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            // 게시글 정보
            PostDetailCard(post: widget.post),
            const SizedBox(height: 16.0),

            // 댓글 리스트
            CommentList(post: widget.post),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
      bottomNavigationBar: CommentWriter(postId: widget.post.id),
    );
  }
}
