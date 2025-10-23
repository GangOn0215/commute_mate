import 'package:commute_mate/models/post.dart';
import 'package:flutter/material.dart';

class CommunityView extends StatefulWidget {
  final Post post; // post Data

  @override
  State<CommunityView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<CommunityView> {
  @override
  Widget build(BuildContext context) {
    final post = widget.post;
  }
}
