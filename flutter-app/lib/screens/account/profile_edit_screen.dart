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

class _ProfileEditScreenState extends State<ProfileEditScreen>
    with SingleTickerProviderStateMixin {
  // ── Design Tokens ──────────────────────────────────────
  static const _bg = Color(0xFFF9FAFB);
  static const _surface = Color(0xFFFFFFFF);
  static const _ink = Color(0xFF09090B);
  static const _muted = Color(0xFF71717A);
  static const _border = Color(0xFFE4E4E7);
  static const _danger = Color(0xFFEF4444);

  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nicknameController;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _contactController;
  late TextEditingController _departmentController;

  bool _isLoading = false;
  User? _user;

  // ── Entry Animation ────────────────────────────────────
  late final AnimationController _entryAnim;
  late final Animation<double> _entryFade;
  late final Animation<Offset> _entrySlide;

  @override
  void initState() {
    super.initState();
    _user = context.read<UserProvider>().user;
    _nicknameController = TextEditingController(text: _user?.nickname ?? '');
    _nameController = TextEditingController(text: _user?.name ?? '');
    _emailController = TextEditingController(text: _user?.email ?? '');
    _contactController = TextEditingController(text: _user?.contact ?? '');
    _departmentController = TextEditingController(
      text: _user?.department ?? '',
    );

    _entryAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _entryFade = CurvedAnimation(parent: _entryAnim, curve: Curves.easeOutExpo);
    _entrySlide = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryAnim, curve: Curves.easeOutExpo));
    _entryAnim.forward();
  }

  @override
  void dispose() {
    _entryAnim.dispose();
    _nicknameController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  // ── Save ───────────────────────────────────────────────
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (_user == null) {
      _showSnack('사용자 정보를 찾을 수 없습니다.');
      return;
    }

    // async gap 전에 미리 캡처
    final provider = context.read<UserProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

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

      final result = await UserService().updateUser(updatedUser);

      if (!mounted) return;
      provider.setUser(result);
      messenger.showSnackBar(
        const SnackBar(
          content: Text('프로필이 업데이트되었습니다.'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      navigator.pop();
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text('프로필 업데이트 실패: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
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

  bool _isValidEmail(String email) {
    if (email.isEmpty) return true;
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }

  // ── Build ──────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: FadeTransition(
          opacity: _entryFade,
          child: SlideTransition(
            position: _entrySlide,
            child: Column(
              children: [
                // ── Top Bar ─────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
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
                      const SizedBox(width: 16),
                      const Text(
                        '프로필 수정',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: _ink,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Form ────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 28),

                          // 기본 정보
                          _sectionLabel('기본 정보'),
                          const SizedBox(height: 12),

                          _fieldLabel('닉네임'),
                          const SizedBox(height: 6),
                          _buildFormField(
                            controller: _nicknameController,
                            hint: '닉네임을 입력하세요',
                            validator: (v) => v == null || v.trim().isEmpty
                                ? '닉네임을 입력해주세요'
                                : null,
                          ),
                          const SizedBox(height: 16),

                          _fieldLabel('이름'),
                          const SizedBox(height: 6),
                          _buildFormField(
                            controller: _nameController,
                            hint: '이름을 입력하세요',
                            validator: (v) => v == null || v.trim().isEmpty
                                ? '이름을 입력해주세요'
                                : null,
                          ),
                          const SizedBox(height: 16),

                          _fieldLabel('이메일'),
                          const SizedBox(height: 6),
                          _buildFormField(
                            controller: _emailController,
                            hint: 'example@email.com',
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v != null &&
                                  v.isNotEmpty &&
                                  !_isValidEmail(v)) {
                                return '올바른 이메일 형식을 입력해주세요';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          _fieldLabel('전화번호'),
                          const SizedBox(height: 6),
                          _buildFormField(
                            controller: _contactController,
                            hint: '010-0000-0000',
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              _PhoneNumberFormatter(),
                            ],
                            validator: (v) => v == null || v.trim().isEmpty
                                ? '전화번호를 입력해주세요'
                                : null,
                          ),
                          const SizedBox(height: 16),

                          _fieldLabel('부서'),
                          const SizedBox(height: 6),
                          _buildFormField(
                            controller: _departmentController,
                            hint: '부서를 입력하세요 (선택)',
                          ),

                          const SizedBox(height: 32),

                          // 계정 정보
                          _sectionLabel('계정 정보'),
                          const SizedBox(height: 12),
                          _readOnlyField(
                            label: '아이디',
                            value: _user?.userId ?? '',
                          ),

                          const SizedBox(height: 40),

                          // 저장 버튼
                          _buildSaveButton(),
                          const SizedBox(height: 48),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Section Label ──────────────────────────────────────
  Widget _sectionLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: _muted,
        letterSpacing: 0.8,
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

  // ── Form Field ─────────────────────────────────────────
  Widget _buildFormField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      style: const TextStyle(
        fontSize: 15,
        color: _ink,
        fontWeight: FontWeight.w400,
      ),
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _danger, width: 1.5),
        ),
        errorStyle: const TextStyle(fontSize: 12, color: _danger),
      ),
    );
  }

  // ── Read-Only Field ────────────────────────────────────
  Widget _readOnlyField({required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _border.withValues(alpha: 0.3),
        border: Border.all(color: _border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: _muted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: _ink,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: _border,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              '변경 불가',
              style: TextStyle(
                fontSize: 10,
                color: _muted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Save Button ────────────────────────────────────────
  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _saveProfile,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: _isLoading ? _ink.withValues(alpha: 0.6) : _ink,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: _isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text(
                  '저장하기',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),
        ),
      ),
    );
  }
}

// ── Phone Number Formatter ─────────────────────────────
class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll('-', '');
    if (text.isEmpty) return newValue;

    String formatted;
    if (text.length <= 3) {
      formatted = text;
    } else if (text.length <= 7) {
      formatted = '${text.substring(0, 3)}-${text.substring(3)}';
    } else if (text.length <= 11) {
      formatted =
          '${text.substring(0, 3)}-${text.substring(3, 7)}-${text.substring(7)}';
    } else {
      formatted =
          '${text.substring(0, 3)}-${text.substring(3, 7)}-${text.substring(7, 11)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
