import 'package:commute_mate/data/post_data.dart';
import 'package:commute_mate/screens/community/community_view.dart';
import 'package:commute_mate/widgets/community/post_card.dart';
import 'package:flutter/material.dart';

class CommunityScreen2 extends StatefulWidget {
  const CommunityScreen2({super.key});

  @override
  State<CommunityScreen2> createState() => _CommunityScreen2State();
}

class _CommunityScreen2State extends State<CommunityScreen2> {
  final postData = PostData();

  @override
  void initState() {
    super.initState();
  }

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
      body: Center(
        child: ListView.builder(
          itemCount: postData.posts.length,
          itemBuilder: (BuildContext context, int index) {
            final post = postData.posts[index];

            return PostCard(post: post);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 글 작성 화면으로 이동하는 로직 추가
        },
        child: Text('+ 글쓰기'),
      ),
    );
  }
}
