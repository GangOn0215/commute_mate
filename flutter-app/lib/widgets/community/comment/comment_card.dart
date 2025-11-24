import 'package:commute_mate/models/post_comment.dart';
import 'package:flutter/material.dart';
import 'package:commute_mate/utils/common.dart';

class CommentCard extends StatelessWidget {
  final PostComment comment;
  const CommentCard({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(backgroundColor: Colors.blueGrey, radius: 18),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.user?.nickname ?? '익명',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 0),
                Text(
                  getTimeAgo(comment.createdAt),
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(height: 4),
                Text(comment.content, style: TextStyle(fontSize: 14)),
                SizedBox(height: 4),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.thumb_up_off_alt,
                            size: 14,
                            color: Colors.grey[700],
                          ),
                          SizedBox(width: 4),
                          Text(
                            '좋아요',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.chat_bubble_outline_outlined,
                            size: 14,
                            color: Colors.grey[700],
                          ),
                          SizedBox(width: 4),
                          Text(
                            '답글쓰기',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
