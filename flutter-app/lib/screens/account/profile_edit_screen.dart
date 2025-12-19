import 'package:commute_mate/models/user.dart';
import 'package:commute_mate/provider/user_provider.dart';
import 'package:commute_mate/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nicknameController;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _contactController;
  late TextEditingController _departmentController;

  bool _isLoading = false;
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = context.read<UserProvider>().user;

    _nicknameController = TextEditingController(text: _user?.nickname ?? '');
    _nameController = TextEditingController(text: _user?.name ?? '');
    _emailController = TextEditingController(text: _user?.email ?? '');
    _contactController = TextEditingController(text: _user?.contact ?? '');
    _departmentController = TextEditingController(text: _user?.department ?? '');
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    if (email.isEmpty) return true; // 이메일은 선택사항
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_user == null) {
      _showSnackBar('사용자 정보를 찾을 수 없습니다.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final updatedUser = User(
        id: _user!.id,
        userId: _user!.userId,
        password: _user!.password,
        name: _nameController.text.trim(),
        nickname: _nicknameController.text.trim(),
        email: _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
        contact: _contactController.text.trim(),
        department: _departmentController.text.trim().isEmpty
            ? null
            : _departmentController.text.trim(),
        profileImageUrl: _user!.profileImageUrl,
        level: _user!.level,
        isActive: _user!.isActive,
        createdAt: _user!.createdAt,
        lastLoginAt: _user!.lastLoginAt,
        notificationEnabled: _user!.notificationEnabled,
      );

      // 서버에 업데이트 요청
      final result = await UserService().updateUser(updatedUser);

      if (mounted) {
        // Provider에 업데이트된 사용자 정보 저장
        context.read<UserProvider>().setUser(result);

        _showSnackBar('프로필이 업데이트되었습니다.');

        Navigator.pop(context);
      }
    } catch (e) {
      _showSnackBar('프로필 업데이트 실패: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: Duration(seconds: 2)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('프로필 수정'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_isLoading)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _saveProfile,
              child: Text(
                '저장',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Text(
                  '기본 정보',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 20),

                // 닉네임
                TextFormField(
                  controller: _nicknameController,
                  decoration: InputDecoration(
                    labelText: '닉네임',
                    hintText: '닉네임을 입력하세요',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '닉네임을 입력해주세요';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // 이름
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: '이름',
                    hintText: '이름을 입력하세요',
                    prefixIcon: Icon(Icons.badge_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '이름을 입력해주세요';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // 이메일
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: '이메일',
                    hintText: '이메일을 입력하세요',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty && !_isValidEmail(value)) {
                      return '올바른 이메일 형식을 입력해주세요';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // 전화번호
                TextFormField(
                  controller: _contactController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    _PhoneNumberFormatter(),
                  ],
                  decoration: InputDecoration(
                    labelText: '전화번호',
                    hintText: '전화번호를 입력하세요',
                    prefixIcon: Icon(Icons.phone_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '전화번호를 입력해주세요';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // 부서 (선택사항)
                TextFormField(
                  controller: _departmentController,
                  decoration: InputDecoration(
                    labelText: '부서 (선택사항)',
                    hintText: '부서를 입력하세요',
                    prefixIcon: Icon(Icons.business_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 30),

                // 계정 정보
                Divider(),
                SizedBox(height: 10),
                Text(
                  '계정 정보',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 20),

                // 아이디 (수정 불가)
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.account_circle_outlined, color: Colors.grey[600]),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '아이디',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            _user?.userId ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll('-', '');

    if (text.isEmpty) return newValue;

    String formatted = '';

    if (text.length <= 3) {
      formatted = text;
    } else if (text.length <= 7) {
      formatted = '${text.substring(0, 3)}-${text.substring(3)}';
    } else if (text.length <= 11) {
      formatted = '${text.substring(0, 3)}-${text.substring(3, 7)}-${text.substring(7)}';
    } else {
      formatted = '${text.substring(0, 3)}-${text.substring(3, 7)}-${text.substring(7, 11)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
