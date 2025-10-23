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
}

enum PostCategory { general, announcement, event, question, tip }
