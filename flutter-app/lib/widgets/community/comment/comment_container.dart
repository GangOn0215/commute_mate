import 'package:commute_mate/models/post.dart';
import 'package:commute_mate/widgets/community/comment/comment_list.dart';
import 'package:flutter/material.dart';

class CommentContainer extends StatelessWidget {
  final Post post;

  const CommentContainer({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CommentList(post: post),
    );
  }
}
