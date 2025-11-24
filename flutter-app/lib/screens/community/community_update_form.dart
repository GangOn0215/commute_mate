import 'package:commute_mate/models/post.dart';
import 'package:commute_mate/provider/post_provider.dart';
import 'package:commute_mate/widgets/community/pretty_category_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommunityUpdateForm extends StatefulWidget {
  Post post;

  CommunityUpdateForm({super.key, required this.post});

  @override
  State<CommunityUpdateForm> createState() => _CommunityUpdateFormState();
}

class _CommunityUpdateFormState extends State<CommunityUpdateForm> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  final List<String> categories = [
    'general',
    'question',
    'company',
    'commute',
    'cat',
  ];

  String? selectedCategory;

  Future<bool> updatePost() async {
    String title = titleController.text.trim();
    String content = contentController.text.trim();
    final category = selectedCategory;

    if (category == null || category.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('카테고리를 선택해주세요.'),
          backgroundColor: Colors.orange,
        ),
      );
      return false;
    }

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('제목과 내용을 모두 입력해주세요.'),
          backgroundColor: Colors.orange,
        ),
      );
      return false;
    }

    final provider = context.read<PostProvider>();

    final updatePost = Post(
      id: 0,
      title: title,
      content: content,
      category: category,
    );

    try {
      await provider.updatePost(widget.post.id.toInt(), updatePost);
      await provider.refreshPosts();

      if (!mounted) false;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('게시물이 성공적으로 수정되었습니다.'),
          backgroundColor: Color(0xFF6C5CE7),
        ),
      );

      Navigator.pop(context, true); // ✅ 이 줄 추가! (결과 전달)

      return true;
    } catch (e) {
      if (!mounted) return false;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('게시물 수정에 실패했습니다: $e'),
          backgroundColor: Colors.red,
        ),
      );

      return false;
    }
  }

  Future<void> loadPostData() async {
    titleController.text = widget.post.title;
    contentController.text = widget.post.content;
    selectedCategory = widget.post.category;
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    loadPostData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community'),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none_outlined),
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 24, 21, 21).withAlpha(16),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ✅ PrettyCategorySelector (onChanged 수정 필요)
              PrettyCategorySelector(
                selected: selectedCategory,
                categories: categories,
                onChanged: (value) {
                  // ✅ context → value
                  setState(() {
                    selectedCategory = value; // ✅ 실제로 값 변경
                  });
                },
              ),

              SizedBox(height: 24),

              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
                  floatingLabelStyle: TextStyle(
                    color: Color(0xFF6C5CE7),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  hintText: '제목을 입력하세요.',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF6C5CE7), width: 2),
                  ),
                ),
              ),

              SizedBox(height: 24),

              // ✅ Expanded 제거, minLines 사용
              TextField(
                controller: contentController,
                minLines: 10, // ✅ 고정 높이
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'Content',
                  labelStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
                  floatingLabelStyle: TextStyle(
                    color: Color(0xFF6C5CE7),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  hintText: '오늘의 이야기를 써내려가주세요! 👍',
                  alignLabelWithHint: true,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF6C5CE7), width: 2),
                  ),
                ),
                textAlignVertical: TextAlignVertical.top,
              ),

              SizedBox(height: 20),

              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: updatePost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6C5CE7),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
