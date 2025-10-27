import 'package:commute_mate/data/post_data.dart';
import 'package:commute_mate/models/post.dart';
import 'package:commute_mate/provider/post_provider.dart';
import 'package:commute_mate/screens/community/community_form.dart';
import 'package:commute_mate/services/post_service.dart';
import 'package:commute_mate/widgets/community/post_card.dart';
import 'package:commute_mate/widgets/community/post_card_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommunityScreen2 extends StatefulWidget {
  const CommunityScreen2({super.key});

  @override
  State<CommunityScreen2> createState() => _CommunityScreen2State();
}

class _CommunityScreen2State extends State<CommunityScreen2> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<PostProvider>(context, listen: false).fetchPosts(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PostProvider>();

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
      body: Stack(
        children: [
          // 기존 body 내용
          Builder(
            builder: (context) {
              if (provider.isLoading) {
                return ListView.builder(
                  itemCount: 5,
                  itemBuilder: (_, __) => PostCardSkeleton(),
                );
              } else if (provider.error != null) {
                return Center(child: Text('Error: ${provider.error}'));
              } else {
                return RefreshIndicator(
                  onRefresh: provider.refreshPosts,
                  child: ListView.builder(
                    itemCount: provider.posts.length,
                    itemBuilder: (context, index) {
                      final post = provider.posts[index];
                      return PostCard(post: post);
                    },
                  ),
                );
              }
            },
          ),

          // 글 쓰기 버튼
          Positioned(
            right: 20,
            bottom: 20,
            child: SizedBox(
              height: 48,
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CommunityForm()),
                  );
                },
                backgroundColor: Color(0xFF6C5CE7),
                elevation: 4,
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit_outlined, size: 16, color: Colors.white),
                    SizedBox(width: 6),
                    Text(
                      '글쓰기',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
