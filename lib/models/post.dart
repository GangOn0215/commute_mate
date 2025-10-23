import 'package:commute_mate/models/user.dart';

class Post {
  String id;
  String title;
  String userName;
  User? author;
  String content;
  DateTime createdAt;
  int likeCount;
  int commentCount;
  int readCount;
  PostCategory category;

  Post({
    required this.id,
    required this.title,
    required this.userName,
    this.author,
    required this.content,
    required this.createdAt,
    this.category = PostCategory.general,
    this.likeCount = 0,
    this.commentCount = 0,
    this.readCount = 0,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      userName: json['userName'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      category: PostCategory.values.firstWhere(
        (e) => e.toString() == 'PostCategory.${json['category']}',
        orElse: () => PostCategory.general,
      ),
      likeCount: json['likeCount'] ?? 0,
    );
  }
}

enum PostCategory { general, announcement, event, question, tip }
