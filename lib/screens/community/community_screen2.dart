import 'package:commute_mate/data/post_data.dart';
import 'package:commute_mate/models/post.dart';
import 'package:commute_mate/services/post_service.dart';
import 'package:commute_mate/widgets/community/post_card.dart';
import 'package:commute_mate/widgets/community/post_card_skeleton.dart';
import 'package:flutter/material.dart';

class CommunityScreen2 extends StatefulWidget {
  const CommunityScreen2({super.key});

  @override
  State<CommunityScreen2> createState() => _CommunityScreen2State();
}

class _CommunityScreen2State extends State<CommunityScreen2> {
  final PostService postService = PostService();
  late Future<List<Post>> futurePosts;
  bool isLoading = false;
  final postData = PostData();

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() {
      isLoading = true;
    });

    // API 요청과 2초 타이머를 동시에 실행
    await Future.wait([
      futurePosts = postService.getPosts(),
      Future.delayed(const Duration(seconds: 2)),
    ]);

    print(futurePosts);

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _refreshPosts() async {
    setState(() {
      futurePosts = postService.getPosts();
    });
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
      body: isLoading
          ? ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: 5, // 로딩용 카드 개수 (3~5개 추천)
              itemBuilder: (context, index) => const PostCardSkeleton(),
            )
          : Center(
              child: ListView.builder(
                itemCount: postData.posts.length,
                itemBuilder: (BuildContext context, int index) {
                  final post = postData.posts[index];

                  return PostCard(post: post);
                },
              ),
            ),
      floatingActionButton: Container(
        height: 48,
        margin: EdgeInsets.only(bottom: 8, right: 4),
        child: FloatingActionButton.extended(
          onPressed: () {
            // 글 작성 화면으로 이동
          },
          backgroundColor: Color(0xFF6C5CE7), // 보라색
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
    );
  }
}
