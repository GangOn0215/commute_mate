import 'package:commute_mate/models/user.dart';

class Post {
  final int? id;
  final User? user;
  final int? userId;
  final String title;
  final String content;
  final String category;
  final int likeCount;
  final int commentCount;
  final int readCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt; // ✅ null 허용
  final int? isActive; // ✅ null 허용

  Post({
    this.id,
    this.user,
    this.userId,
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
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: int.tryParse(json['id'].toString()) ?? 0,
      user: User.fromJson(json['user']),
      userId: json['user_id'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      category: json['category'] ?? '',
      likeCount: int.tryParse(json['like_count'].toString()) ?? 0,
      commentCount: int.tryParse(json['comment_count'].toString()) ?? 0,
      readCount: int.tryParse(json['read_count'].toString()) ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      isActive: json['is_active'] is int
          ? json['is_active']
          : int.tryParse(json['is_active']?.toString() ?? '0'),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user?.toJson(),
      'user_id': userId,
      'title': title,
      'content': content,
      'category': category,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'readCount': readCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'isActive': isActive,
    };
  }
}

enum PostCategory { general, announcement, event, question, tip, cat }
