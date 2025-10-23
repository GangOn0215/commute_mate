import 'package:commute_mate/data/post_data.dart';
import 'package:commute_mate/models/post.dart';
import 'package:commute_mate/screens/community/community_view.dart';
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
                        children: [
                          Row(
                            children: [
                              CircleAvatar(backgroundColor: Colors.blueGrey),
                              SizedBox(width: 10),
                              Text(
                                '@${post.userName}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            post.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
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
          },
        ),
      ),
    );
  }
}
