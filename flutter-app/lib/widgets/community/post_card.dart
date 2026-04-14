import 'package:commute_mate/models/post.dart';
import 'package:commute_mate/screens/community/community_view.dart';
import 'package:commute_mate/utils/common.dart';
import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  // ── Design Tokens ──────────────────────────────────────
  static const _surface = Color(0xFFFFFFFF);
  static const _ink = Color(0xFF09090B);
  static const _muted = Color(0xFF71717A);
  static const _border = Color(0xFFE4E4E7);

  @override
  Widget build(BuildContext context) {
    final profileImage = post.user?.profileImageUrl;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: _surface,
          border: Border.all(color: _border),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CommunityView(post: post)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── 작성자 정보 ──────────────────────────
                  Row(
                    children: [
                      _buildAvatar(profileImage),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.user?.nickname ?? '익명',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _ink,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Row(
                            children: [
                              Text(
                                getTimeAgo(post.createdAt),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: _muted,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  '·',
                                  style: TextStyle(color: _muted, fontSize: 11),
                                ),
                              ),
                              Text(
                                post.category,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: _muted,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ── 제목 ─────────────────────────────────
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _ink,
                      letterSpacing: -0.2,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // ── 내용 미리보기 ─────────────────────────
                  Text(
                    post.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: _muted,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── 하단 통계 ─────────────────────────────
                  Row(
                    children: [
                      _statItem(Icons.favorite_border_rounded, post.likeCount),
                      const SizedBox(width: 12),
                      _statItem(
                        Icons.chat_bubble_outline_rounded,
                        post.commentCount,
                      ),
                      const Spacer(),
                      Icon(
                        Icons.visibility_outlined,
                        size: 13,
                        color: _muted.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        post.readCount.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          color: _muted.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          imageUrl,
          width: 34,
          height: 34,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _defaultAvatar(),
          loadingBuilder: (_, child, progress) =>
              progress == null ? child : _defaultAvatar(),
        ),
      );
    }
    return _defaultAvatar();
  }

  Widget _defaultAvatar() {
    return Container(
      width: 34,
      height: 34,
      decoration: const BoxDecoration(color: _border, shape: BoxShape.circle),
      child: const Icon(Icons.person_rounded, size: 18, color: _muted),
    );
  }

  Widget _statItem(IconData icon, int count) {
    return Row(
      children: [
        Icon(icon, size: 14, color: _muted),
        const SizedBox(width: 3),
        Text(
          count.toString(),
          style: const TextStyle(fontSize: 12, color: _muted),
        ),
      ],
    );
  }
}

// 전역 simpleAvatar (기존 코드 호환)
Widget simpleAvatar() {
  return Container(
    width: 34,
    height: 34,
    decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle),
    child: const Icon(Icons.person_rounded, size: 18, color: Colors.white),
  );
}
