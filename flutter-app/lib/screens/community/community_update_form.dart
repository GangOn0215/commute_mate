import 'package:commute_mate/models/post.dart';
import 'package:commute_mate/provider/post_provider.dart';
import 'package:commute_mate/widgets/community/pretty_category_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommunityUpdateForm extends StatefulWidget {
  final Post post;

  const CommunityUpdateForm({super.key, required this.post});

  @override
  State<CommunityUpdateForm> createState() => _CommunityUpdateFormState();
}

class _CommunityUpdateFormState extends State<CommunityUpdateForm> {
  // ── Design Tokens ──────────────────────────────────────
  static const _bg = Color(0xFFF9FAFB);
  static const _surface = Color(0xFFFFFFFF);
  static const _ink = Color(0xFF09090B);
  static const _muted = Color(0xFF71717A);
  static const _border = Color(0xFFE4E4E7);

  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  final List<String> _categories = [
    '자유게시판',
    '질문',
    '회사',
    '출퇴근',
    '일상',
    '고양이',
    '공지사항',
  ];

  String? _selectedCategory;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post.title);
    _contentController = TextEditingController(text: widget.post.content);
    _selectedCategory = widget.post.category;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (_selectedCategory == null || _selectedCategory!.isEmpty) {
      _showSnack('카테고리를 선택해주세요.');
      return;
    }

    if (title.isEmpty || content.isEmpty) {
      _showSnack('제목과 내용을 모두 입력해주세요.');
      return;
    }

    final provider = context.read<PostProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    setState(() => _isSubmitting = true);

    final updatedPost = Post(
      id: 0,
      title: title,
      content: content,
      category: _selectedCategory!,
    );

    try {
      await provider.updatePost(widget.post.id.toInt(), updatedPost);
      await provider.refreshPosts();

      if (!mounted) return;

      messenger.showSnackBar(
        const SnackBar(
          content: Text('게시물이 수정되었습니다.'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 1),
        ),
      );
      navigator.pop(true);
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text('게시물 수정 실패: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
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
                    '게시글 수정',
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

            // ── Form ─────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 카테고리
                    PrettyCategorySelector(
                      selected: _selectedCategory,
                      categories: _categories,
                      onChanged: (val) =>
                          setState(() => _selectedCategory = val),
                    ),

                    const SizedBox(height: 20),

                    // 제목
                    _fieldLabel('제목'),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: _titleController,
                      hint: '제목을 입력하세요',
                      maxLines: 1,
                    ),

                    const SizedBox(height: 16),

                    // 내용
                    _fieldLabel('내용'),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: _contentController,
                      hint: '내용을 입력하세요',
                      minLines: 8,
                      maxLines: null,
                    ),

                    const SizedBox(height: 32),

                    // 수정 버튼
                    GestureDetector(
                      onTap: _isSubmitting ? null : _submit,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: _isSubmitting
                              ? _ink.withValues(alpha: 0.6)
                              : _ink,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  '수정하기',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: _ink,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int? minLines,
    int? maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 15, color: _ink),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: _muted, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        filled: true,
        fillColor: _surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _ink, width: 1.5),
        ),
      ),
      textAlignVertical: minLines != null
          ? TextAlignVertical.top
          : TextAlignVertical.center,
    );
  }
}
