import 'package:commute_mate/models/post.dart';
import 'package:commute_mate/models/user.dart';

class PostComment {
  final int? id;
  final int? userId;
  final int? postId;
  final int? parentId;
  final User? user;
  final Post? post;
  final String content;
  final int likeCount;
  final bool isLiked;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<PostComment> replies;

  PostComment({
    this.id,
    this.userId,
    this.postId,
    this.parentId,
    this.user,
    this.post,
    required this.content,
    this.likeCount = 0,
    this.isLiked = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.replies = const [],
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory PostComment.fromJson(Map<String, dynamic> json) {
    return PostComment(
      id: json['id'] as int?,
      parentId: json['parentId'] as int?,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      content: json['content'] ?? '',
      likeCount: json['likeCount'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      replies: json['replies'] != null
          ? (json['replies'] as List)
                .map((e) => PostComment.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'postId': postId,
      if (parentId != null) 'parentId': parentId,
      if (id != null) 'id': id,
      'content': content,
      'likeCount': likeCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  PostComment copyWith({
    int? id,
    int? userId,
    int? postId,
    int? parentId,
    User? user,
    Post? post,
    String? content,
    int? likeCount,
    bool? isLiked,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<PostComment>? replies,
  }) {
    return PostComment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      postId: postId ?? this.postId,
      parentId: parentId ?? this.parentId,
      user: user ?? this.user,
      post: post ?? this.post,
      content: content ?? this.content,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      replies: replies ?? this.replies,
    );
  }
}
