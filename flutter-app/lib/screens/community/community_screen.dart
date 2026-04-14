import 'package:commute_mate/provider/post_provider.dart';
import 'package:commute_mate/screens/community/community_form.dart';
import 'package:commute_mate/widgets/community/post_card.dart';
import 'package:commute_mate/widgets/community/post_card_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  // ── Design Tokens ──────────────────────────────────────
  static const _bg = Color(0xFFF9FAFB);
  static const _surface = Color(0xFFFFFFFF);
  static const _ink = Color(0xFF09090B);
  static const _muted = Color(0xFF71717A);
  static const _border = Color(0xFFE4E4E7);

  String _selectedCategory = '전체';
  final List<String> _categories = [
    '전체',
    '자유게시판',
    '질문',
    '회사',
    '출퇴근',
    '일상',
    '고양이',
    '공지사항',
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        Provider.of<PostProvider>(context, listen: false).fetchPosts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PostProvider>();

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────
            Container(
              color: _surface,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '커뮤니티',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: _ink,
                      letterSpacing: -0.5,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CommunityForm()),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: _ink,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            size: 14,
                            color: Colors.white,
                          ),
                          SizedBox(width: 5),
                          Text(
                            '글쓰기',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Category Filter ──────────────────────────
            Container(
              color: _surface,
              child: Column(
                children: [
                  SizedBox(
                    height: 52,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, i) {
                        final cat = _categories[i];
                        final isSelected = cat == _selectedCategory;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedCategory = cat),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected ? _ink : _surface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? _ink : _border,
                              ),
                            ),
                            child: Text(
                              cat,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isSelected ? Colors.white : _muted,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(height: 1, color: _border),
                ],
              ),
            ),

            // ── Post List ────────────────────────────────
            Expanded(child: _buildPostList(provider)),
          ],
        ),
      ),
    );
  }

  Widget _buildPostList(PostProvider provider) {
    if (provider.isLoading) {
      return ListView.builder(
        padding: const EdgeInsets.only(top: 8),
        itemCount: 5,
        itemBuilder: (_, __) => const PostCardSkeleton(),
      );
    }

    if (provider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Color(0xFFEF4444)),
            const SizedBox(height: 12),
            Text(
              '불러오기 실패',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF09090B),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              provider.error!,
              style: const TextStyle(fontSize: 13, color: Color(0xFF71717A)),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: provider.fetchPosts,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF09090B),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '다시 시도',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final filtered = _selectedCategory == '전체'
        ? provider.posts
        : provider.posts.where((p) => p.category == _selectedCategory).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 12),
            const Text(
              '게시글이 없습니다',
              style: TextStyle(fontSize: 15, color: Color(0xFF71717A)),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: const Color(0xFF09090B),
      onRefresh: provider.refreshPosts,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: filtered.length,
        itemBuilder: (_, i) => PostCard(post: filtered[i]),
      ),
    );
  }
}
