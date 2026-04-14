import 'package:commute_mate/models/post.dart';
import 'package:commute_mate/widgets/community/comment/comment_list.dart';
import 'package:commute_mate/widgets/community/comment/comment_writer.dart';
import 'package:commute_mate/widgets/community/post_detail_card.dart';
import 'package:flutter/material.dart';

class CommunityView extends StatelessWidget {
  final Post post;

  const CommunityView({super.key, required this.post});

  // ── Design Tokens ──────────────────────────────────────
  static const _bg = Color(0xFFF9FAFB);
  static const _surface = Color(0xFFFFFFFF);
  static const _ink = Color(0xFF09090B);
  static const _border = Color(0xFFE4E4E7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Top Bar ───────────────────────────────
            Container(
              color: _surface,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: _surface,
                        border: Border.all(color: _border),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16,
                        color: _ink,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    '게시글',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: _ink,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: _border),

            // ── Body ─────────────────────────────────
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  // 게시글 본문
                  Container(
                    color: _surface,
                    child: PostDetailCard(post: post),
                  ),

                  const SizedBox(height: 8),

                  // 댓글 영역
                  Container(
                    color: _surface,
                    padding: const EdgeInsets.only(top: 16, bottom: 12),
                    child: CommentList(post: post),
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CommentWriter(postId: post.id),
    );
  }
}
