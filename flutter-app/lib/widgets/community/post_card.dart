import 'package:commute_mate/models/post.dart';
import 'package:commute_mate/screens/community/community_view.dart';
import 'package:flutter/material.dart';
import 'package:commute_mate/utils/common.dart';

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  Future<void> initPostData() async {
    loadPostData();
  }

  Future<void> loadPostData() async {
    final post = widget.post;
  }

  @override
  void initState() {
    super.initState();

    initPostData();
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    var profileImage = post.user?.profileImageUrl;

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
                      if (profileImage != null && profileImage.isNotEmpty)
                        ClipOval(
                          child: Image.network(
                            profileImage,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,

                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return SizedBox(
                                width: 40,
                                height: 40,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                simpleAvatar(),
                          ),
                        )
                      else
                        simpleAvatar(),
                    ],
                    // children: [CircleAvatar(backgroundColor: Colors.blueGrey)],
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${post.user?.nickname}',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Row(
                        children: [
                          Text(
                            getTimeAgo(post.createdAt),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 10, // 높이 지정 필요
                            child: VerticalDivider(
                              width: 16, // 좌우 여백 포함 너비
                              thickness: 1,
                              color: Colors.grey[400],
                            ),
                          ),
                          Text(
                            post.category,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
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
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      /**
                       * 만약 내가 '좋아요' 
                       * 눌렀으면 Icons.favorite 
                       * 아니면 Icons.favorite_border
                       */
                      Icon(Icons.favorite_border, size: 20),
                      SizedBox(width: 2),
                      Text(post.likeCount.toString()),
                      SizedBox(width: 10),
                      Icon(Icons.chat_bubble_outline, size: 20),
                      SizedBox(width: 2),
                      Text(post.commentCount.toString()),
                      SizedBox(width: 10),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '조회',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      SizedBox(width: 2),
                      Text(
                        post.readCount.toString(),
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget simpleAvatar() {
  return CircleAvatar(
    radius: 20,
    backgroundColor: Colors.grey[300],
    child: Icon(Icons.person, size: 24, color: Colors.white),
  );
}
