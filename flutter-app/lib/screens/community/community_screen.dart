import 'package:commute_mate/provider/post_provider.dart';
import 'package:commute_mate/provider/user_provider.dart';
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
  String selectedCategory = '전체';
  final List<String> categories = [
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
    Future.microtask(
      () => Provider.of<PostProvider>(context, listen: false).fetchPosts(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PostProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('커뮤니티'),
        elevation: 1,
        scrolledUnderElevation: 1,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none_outlined),
          ),
        ],
        centerTitle: false,
      ),
      body: Stack(
        children: [
          // ✅ 전체 레이아웃
          Column(
            children: [
              // 카테고리 필터
              _buildCategoryFilter(),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),

              // 게시글 리스트
              Expanded(child: _buildPostList(provider)),
            ],
          ),

          // 글쓰기 버튼
          Positioned(right: 20, bottom: 20, child: _buildWriteButton(context)),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 58,
      color: Colors.white,

      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        scrollDirection: Axis.horizontal, // 가로 스크롤
        physics: BouncingScrollPhysics(), // 부드로운 스크롤
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;

          return _buildCategoryChip(
            label: category,
            isSelected: isSelected,
            onTap: () => setState(() => selectedCategory = category),
          );
        },
      ),
    );
  }

  Widget _buildCategoryChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.black : const Color(0xFFE0E0E0),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF666666),
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPostList(PostProvider provider) {
    if (provider.isLoading) {
      return ListView.builder(
        itemCount: 5,
        itemBuilder: (_, __) => PostCardSkeleton(),
      );
    }

    if (provider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            SizedBox(height: 16),
            Text('Error: ${provider.error}'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: provider.fetchPosts,
              child: Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    // 카테고리 필터링
    final filteredPosts = selectedCategory == '전체'
        ? provider.posts
        : provider.posts
              .where((post) => post.category == selectedCategory)
              .toList();

    if (filteredPosts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              '게시글이 없습니다',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: provider.refreshPosts,
      child: ListView.builder(
        itemCount: filteredPosts.length,
        itemBuilder: (context, index) {
          return PostCard(post: filteredPosts[index]);
        },
      ),
    );
  }

  Widget _buildWriteButton(BuildContext context) {
    return SizedBox(
      height: 48,
      child: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CommunityForm()),
          );
        },
        backgroundColor: Color(0xFF6C5CE7),
        elevation: 4,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.edit_outlined, size: 16, color: Colors.white),
            SizedBox(width: 6),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }
}
