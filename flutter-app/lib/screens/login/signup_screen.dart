import 'package:commute_mate/models/user.dart';
import 'package:commute_mate/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  // ── Design Tokens ──────────────────────────────────────
  static const _bg = Color(0xFFF9FAFB);
  static const _surface = Color(0xFFFFFFFF);
  static const _ink = Color(0xFF09090B);
  static const _muted = Color(0xFF71717A);
  static const _border = Color(0xFFE4E4E7);
  static const _accent = Color(0xFF059669);

  // ── Controllers ────────────────────────────────────────
  final _userIdCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _passwordCheckCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _nicknameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscurePasswordCheck = true;
  int _step = 0; // 0,1,2 = 입력 스텝 / 3 = 완료
  bool _isForward = true;

  // ── Entry Animation ────────────────────────────────────
  late final AnimationController _entryAnim;
  late final Animation<double> _entryFade;
  late final Animation<Offset> _entrySlide;

  @override
  void initState() {
    super.initState();
    _entryAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _entryFade = CurvedAnimation(parent: _entryAnim, curve: Curves.easeOutExpo);
    _entrySlide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryAnim, curve: Curves.easeOutExpo));
    _entryAnim.forward();
  }

  @override
  void dispose() {
    _entryAnim.dispose();
    _userIdCtrl.dispose();
    _passwordCtrl.dispose();
    _passwordCheckCtrl.dispose();
    _nameCtrl.dispose();
    _nicknameCtrl.dispose();
    _emailCtrl.dispose();
    _contactCtrl.dispose();
    super.dispose();
  }

  // ── Navigation ─────────────────────────────────────────
  void _goNext() {
    if (!_validate()) return;
    if (_step == 2) {
      _signup();
    } else {
      _isForward = true;
      setState(() => _step++);
    }
  }

  void _goBack() {
    if (_step == 0) {
      Navigator.pop(context);
    } else {
      _isForward = false;
      setState(() => _step--);
    }
  }

  // ── Validation ─────────────────────────────────────────
  bool _validate() {
    switch (_step) {
      case 0:
        if (_userIdCtrl.text.trim().isEmpty) {
          _showSnack('아이디를 입력해주세요.');
          return false;
        }
        if (_passwordCtrl.text.trim().isEmpty) {
          _showSnack('비밀번호를 입력해주세요.');
          return false;
        }
        if (_passwordCtrl.text.trim() != _passwordCheckCtrl.text.trim()) {
          _showSnack('비밀번호가 일치하지 않습니다.');
          return false;
        }
        return true;
      case 1:
        if (_nameCtrl.text.trim().isEmpty) {
          _showSnack('이름을 입력해주세요.');
          return false;
        }
        return true;
      case 2:
        if (_emailCtrl.text.trim().isEmpty) {
          _showSnack('이메일을 입력해주세요.');
          return false;
        }
        if (!RegExp(
          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
        ).hasMatch(_emailCtrl.text.trim())) {
          _showSnack('올바른 이메일 형식을 입력해주세요.');
          return false;
        }
        if (_contactCtrl.text.trim().isEmpty) {
          _showSnack('전화번호를 입력해주세요.');
          return false;
        }
        return true;
      default:
        return true;
    }
  }

  // ── Signup API ─────────────────────────────────────────
  Future<void> _signup() async {
    setState(() => _isLoading = true);
    try {
      await UserService().signup(
        User(
          userId: _userIdCtrl.text.trim(),
          password: _passwordCtrl.text.trim(),
          name: _nameCtrl.text.trim(),
          nickname: _nicknameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          contact: _contactCtrl.text.trim(),
          isActive: true,
          level: 1,
        ),
      );
      if (!mounted) return;
      _isForward = true;
      setState(() => _step = 3);
    } catch (e) {
      if (!mounted) return;
      _showSnack('회원가입에 실패했습니다: $e');
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  if (_step < 3) ...[
                    _buildTopBar(),
                    const SizedBox(height: 24),
                    _buildProgressDots(),
                    const SizedBox(height: 32),
                  ],
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, anim) {
                        return FadeTransition(
                          opacity: anim,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset(_isForward ? 0.05 : -0.05, 0),
                              end: Offset.zero,
                            ).animate(anim),
                            child: child,
                          ),
                        );
                      },
                      child: KeyedSubtree(
                        key: ValueKey(_step),
                        child: _buildStepContent(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Top Bar ────────────────────────────────────────────
  Widget _buildTopBar() {
    return GestureDetector(
      onTap: _goBack,
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
    );
  }

  // ── Progress Dots ──────────────────────────────────────
  Widget _buildProgressDots() {
    return Row(
      children: List.generate(3, (i) {
        final done = i < _step;
        final current = i == _step;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.only(right: 6),
          width: current ? 28 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: done
                ? _accent
                : current
                ? _ink
                : _border,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  // ── Step Router ────────────────────────────────────────
  Widget _buildStepContent() {
    switch (_step) {
      case 0:
        return _buildStep0();
      case 1:
        return _buildStep1();
      case 2:
        return _buildStep2();
      case 3:
        return _buildComplete();
      default:
        return const SizedBox.shrink();
    }
  }

  // ── Step 0 : 계정 ──────────────────────────────────────
  Widget _buildStep0() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(
            badge: '1 / 3',
            title: '계정 설정',
            subtitle: '로그인에 사용할 아이디와\n비밀번호를 설정해주세요.',
          ),
          const SizedBox(height: 32),
          _fieldLabel('아이디'),
          const SizedBox(height: 6),
          _buildTextField(controller: _userIdCtrl, hint: '아이디를 입력하세요'),
          const SizedBox(height: 16),
          _fieldLabel('비밀번호'),
          const SizedBox(height: 6),
          _buildTextField(
            controller: _passwordCtrl,
            hint: '비밀번호를 입력하세요',
            obscure: _obscurePassword,
            suffix: GestureDetector(
              onTap: () => setState(() => _obscurePassword = !_obscurePassword),
              child: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 18,
                color: _muted,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _fieldLabel('비밀번호 확인'),
          const SizedBox(height: 6),
          _buildTextField(
            controller: _passwordCheckCtrl,
            hint: '비밀번호를 다시 입력하세요',
            obscure: _obscurePasswordCheck,
            suffix: GestureDetector(
              onTap: () => setState(
                () => _obscurePasswordCheck = !_obscurePasswordCheck,
              ),
              child: Icon(
                _obscurePasswordCheck
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 18,
                color: _muted,
              ),
            ),
          ),
          const SizedBox(height: 32),
          _buildActionButton('다음'),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── Step 1 : 기본 정보 ─────────────────────────────────
  Widget _buildStep1() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(
            badge: '2 / 3',
            title: '기본 정보',
            subtitle: '서비스에서 사용할\n이름과 닉네임을 알려주세요.',
          ),
          const SizedBox(height: 32),
          _fieldLabel('이름'),
          const SizedBox(height: 6),
          _buildTextField(controller: _nameCtrl, hint: '실명을 입력하세요'),
          const SizedBox(height: 16),
          _fieldLabel('닉네임'),
          const SizedBox(height: 6),
          _buildTextField(controller: _nicknameCtrl, hint: '닉네임을 입력하세요 (선택)'),
          const SizedBox(height: 32),
          _buildActionButton('다음'),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── Step 2 : 연락처 ────────────────────────────────────
  Widget _buildStep2() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(
            badge: '3 / 3',
            title: '연락처',
            subtitle: '이메일과 전화번호를 입력하면\n가입이 완료돼요.',
          ),
          const SizedBox(height: 32),
          _fieldLabel('이메일'),
          const SizedBox(height: 6),
          _buildTextField(
            controller: _emailCtrl,
            hint: 'example@email.com',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          _fieldLabel('전화번호'),
          const SizedBox(height: 6),
          _buildTextField(
            controller: _contactCtrl,
            hint: '010-0000-0000',
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              _PhoneNumberFormatter(),
            ],
          ),
          const SizedBox(height: 32),
          _buildActionButton('가입하기'),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── Step 3 : 완료 ──────────────────────────────────────
  Widget _buildComplete() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: _accent.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_rounded, size: 32, color: _accent),
        ),
        const SizedBox(height: 24),
        const Text(
          '가입 완료!',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: _ink,
            letterSpacing: -1.2,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${_nameCtrl.text.trim()}님, 환영해요.\n출퇴근 메이트와 함께 시작해보세요.',
          style: const TextStyle(fontSize: 15, color: _muted, height: 1.6),
        ),
        const SizedBox(height: 48),
        _TactileButton(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: _ink,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                '로그인하러 가기',
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
      ],
    );
  }

  // ── Shared UI ──────────────────────────────────────────
  Widget _buildStepHeader({
    required String badge,
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _accent.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: _accent.withValues(alpha: 0.2)),
          ),
          child: Text(
            badge,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: _accent,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: _ink,
            letterSpacing: -1.0,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: _muted,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),
      ],
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
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    Widget? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _surface,
        border: Border.all(color: _border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
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
          border: InputBorder.none,
          suffixIcon: suffix != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: suffix,
                )
              : null,
          suffixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String label) {
    return _TactileButton(
      onTap: _isLoading ? null : _goNext,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: _ink,
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
              : Text(
                  label,
                  style: const TextStyle(
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

// ── Tactile Press Button ───────────────────────────────
class _TactileButton extends StatefulWidget {
  const _TactileButton({required this.onTap, required this.child});

  final VoidCallback? onTap;
  final Widget child;

  @override
  State<_TactileButton> createState() => _TactileButtonState();
}

class _TactileButtonState extends State<_TactileButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 180),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) {
        if (widget.onTap != null) _ctrl.forward();
      },
      onTapUp: (_) => _ctrl.reverse(),
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(scale: _scale, child: widget.child),
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
