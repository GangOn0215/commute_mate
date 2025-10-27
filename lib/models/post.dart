import 'package:commute_mate/models/user.dart';

class Post {
  final int? id;
  final int userId;
  final String userName;
  final String title;
  final String content;
  final String category;
  final int likeCount;
  final int commentCount;
  final int readCount;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt; // ✅ null 허용
  final int? isActive; // ✅ null 허용
  final String? authorName; // ✅ null 허용
  final String? authorNickname; // ✅ null 허용
  final String? authorProfile; // ✅ null 허용

  Post({
    this.id,
    required this.userId,
    required this.userName,
    required this.title,
    required this.content,
    required this.category,
    required this.likeCount,
    required this.commentCount,
    required this.readCount,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.isActive,
    this.authorName,
    this.authorNickname,
    this.authorProfile,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      userName: json['user_name'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      category: json['category'] ?? '',
      likeCount: int.tryParse(json['like_count'].toString()) ?? 0,
      commentCount: int.tryParse(json['comment_count'].toString()) ?? 0,
      readCount: int.tryParse(json['read_count'].toString()) ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      deletedAt: json['deleted_at']?.toString(),
      isActive: json['is_active'] is int
          ? json['is_active']
          : int.tryParse(json['is_active']?.toString() ?? '0'),
      authorName: json['author_name']?.toString(),
      authorNickname: json['author_nickname']?.toString(),
      authorProfile: json['author_profile']?.toString(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'title': title,
      'content': content,
      'category': category,
      'like_count': likeCount,
      'comment_count': commentCount,
      'read_count': readCount,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'is_active': isActive,
      'author_name': authorName,
      'author_nickname': authorNickname,
      'author_profile': authorProfile,
    };
  }
}

enum PostCategory { general, announcement, event, question, tip }
