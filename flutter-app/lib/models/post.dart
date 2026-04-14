import 'package:commute_mate/models/user.dart';

class Post {
  final int id;
  final int? userId; // ✅ 생성/수정 시에는 userId만 사용
  final User? user; // ✅ 조회 시에는 User 객체 사용
  final String title;
  final String content;
  final String category;
  final int likeCount;
  final int commentCount;
  final int readCount;
  final bool isLiked;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final bool isActive;

  Post({
    required this.id,
    this.userId,
    this.user,
    required this.title,
    required this.content,
    required this.category,
    this.likeCount = 0,
    this.commentCount = 0,
    this.readCount = 0,
    this.isLiked = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.deletedAt,
    this.isActive = true,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // 서버에서 받을 때 (조회)
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      category: json['category'] ?? '',
      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      readCount: json['readCount'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'])
          : null,
      isActive: json['isActive'] ?? true,
    );
  }

  Post copyWith({
    int? id,
    int? userId,
    User? user,
    String? title,
    String? content,
    String? category,
    int? likeCount,
    int? commentCount,
    int? readCount,
    bool? isLiked,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool? isActive,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      user: user ?? this.user,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      readCount: readCount ?? this.readCount,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  // 서버로 보낼 때 (생성/수정)
  Map<String, dynamic> toJson() {
    return {
      'userId': userId, // ✅ User 객체 대신 userId만 전송
      'id': id,
      'title': title,
      'content': content,
      'category': category.toUpperCase(),
      'likeCount': likeCount,
      'commentCount': commentCount,
      'readCount': readCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
