import 'package:commute_mate/models/post.dart';
import 'package:commute_mate/models/user.dart';

class PostComment {
  final int? id;
  final int? userId; // 생성/수정 시에는 userId만 사용
  final int? postId; // 댓글이 속한 게시글 ID
  final User? user; // 조회 시에는 User 객체 사용
  final Post? post;
  final String content;
  final int likeCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  PostComment({
    this.id,
    this.userId,
    this.postId,
    this.user,
    this.post,
    required this.content,
    this.likeCount = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // 서버에서 받을 때 (조회)
  factory PostComment.fromJson(Map<String, dynamic> json) {
    return PostComment(
      id: json['id'] as int?,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      content: json['content'] ?? '',
      likeCount: json['likeCount'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'postId': postId,
      if (id != null) 'id': id,
      'content': content,
      'likeCount': likeCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
