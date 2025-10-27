import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:commute_mate/models/post.dart';
import 'package:commute_mate/provider/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommunityForm extends StatefulWidget {
  const CommunityForm({super.key});

  @override
  State<CommunityForm> createState() => _CommunityFormState();
}

class _CommunityFormState extends State<CommunityForm> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  // ✅ 빈 문자열 제거
  final List<String> categories = [
    'general',
    'question',
    'company',
    'commute',
    'cat',
  ];

  String? selectedCategory; // 선택된 카테고리

  Future<void> submitPost() async {
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
      return;
    }

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('제목과 내용을 모두 입력해주세요.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final provider = context.read<PostProvider>();

    final newPost = Post(
      userId: 1,
      userName: 'admin',
      title: title,
      content: content,
      category: category,
      likeCount: 0,
      commentCount: 0,
      readCount: 0,
      createdAt: DateTime.now().toString(),
      updatedAt: DateTime.now().toString(),
    );

    try {
      await provider.createPost(newPost);

      // ✅ 게시글 목록 새로고침 추가 (중요!)
      await provider.refreshPosts();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('게시물이 성공적으로 등록되었습니다.'),
          backgroundColor: Color(0xFF6C5CE7),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('게시물 등록에 실패했습니다: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
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
      body: Padding(
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
              // ✅ value를 selectedCategory로 변경
              DropdownButtonFormField2<String>(
                value: selectedCategory,
                hint: Text(
                  '카테고리를 선택하세요',
                  style: TextStyle(color: Colors.grey[600], fontSize: 15),
                ),
                decoration: InputDecoration(
                  labelText: 'Category',
                  labelStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
                  floatingLabelStyle: TextStyle(
                    color: Color(0xFF6C5CE7),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF6C5CE7), width: 2),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
                iconStyleData: IconStyleData(
                  icon: Icon(Icons.keyboard_arrow_down_rounded),
                  iconSize: 22,
                  iconEnabledColor: Colors.grey[600],
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(16),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                menuItemStyleData: MenuItemStyleData(
                  height: 44,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                ),
                buttonStyleData: ButtonStyleData(padding: EdgeInsets.zero),
                style: TextStyle(fontSize: 15, color: Colors.black87),
                items: categories.map((cat) {
                  return DropdownMenuItem<String>(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
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

              Expanded(
                child: TextField(
                  controller: contentController,
                  decoration: InputDecoration(
                    labelText: 'Content',
                    labelStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
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
                      borderSide: BorderSide(
                        color: Color(0xFF6C5CE7),
                        width: 2,
                      ),
                    ),
                  ),
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                ),
              ),

              SizedBox(height: 20),

              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: submitPost,
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
