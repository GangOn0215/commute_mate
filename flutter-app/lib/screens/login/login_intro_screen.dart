import 'dart:async';

import 'package:commute_mate/models/user.dart';
import 'package:commute_mate/provider/user_provider.dart';
import 'package:commute_mate/screens/login/login_kakao_webview.dart';
import 'package:commute_mate/screens/login/signup_screen.dart';
import 'package:commute_mate/services/api/kakao_auth_service.dart';
import 'package:commute_mate/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginIntroScreen extends StatefulWidget {
  const LoginIntroScreen({super.key});

  @override
  State<LoginIntroScreen> createState() => _LoginIntroScreenState();
}

class _LoginIntroScreenState extends State<LoginIntroScreen>
    with SingleTickerProviderStateMixin {
  // ── Design Tokens ──────────────────────────────────────
  static const _bg = Color(0xFFF9FAFB);
  static const _surface = Color(0xFFFFFFFF);
  static const _ink = Color(0xFF09090B);
  static const _muted = Color(0xFF71717A);
  static const _border = Color(0xFFE4E4E7);
  static const _accent = Color(0xFF059669);

  // ── Controllers ────────────────────────────────────────
  final KakaoAuthService _kakaoAuth = KakaoAuthService();
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  UserService userService = UserService();
  User? user;

  // ── Entry Animation ────────────────────────────────────
  AnimationController? _anim;
  Animation<double> _fade = const AlwaysStoppedAnimation(1.0);
  Animation<Offset> _slide = const AlwaysStoppedAnimation(Offset.zero);

  @override
  void initState() {
    super.initState();
    final ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _anim = ctrl;
    _fade = CurvedAnimation(parent: ctrl, curve: Curves.easeOutExpo);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: ctrl, curve: Curves.easeOutExpo));
    ctrl.forward();
  }

  @override
  void dispose() {
    _anim?.dispose();
    userIdController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ── Auth Logic (unchanged) ─────────────────────────────
  Future<void> _loginWithKakao() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final loginUrl = await _kakaoAuth.getLoginUrl();
      if (!mounted) return;

      final code = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (context) => KakaoLoginWebView(loginUrl: loginUrl),
        ),
      );

      if (code == null) {
        setState(() => _isLoading = false);
        return;
      }

      final userData = await _kakaoAuth.loginWithCode(code);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${userData['nickname']} 님, 반가워요!'),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Timer(const Duration(seconds: 2), () {
        if (mounted) context.go('/home');
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('로그인 실패: $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _login() async {
    if (userIdController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('아이디와 패스워드를 모두 입력해주세요.'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    try {
      user = await userService.getUserByLoginByIdPw(
        userIdController.text,
        passwordController.text,
      );

      if (!mounted) return;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('아이디 또는 패스워드를 확인해주세요.'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        await context.read<UserProvider>().loginAndSave(user!);
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${user!.name}님 환영합니다!'),
            duration: const Duration(seconds: 1),
          ),
        );

        await Future.delayed(const Duration(seconds: 1));
        if (mounted) context.go('/home');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('오류가 발생했습니다: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // ── Build ──────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 52),
                    _buildHeader(),
                    const SizedBox(height: 40),
                    _buildForm(),
                    const SizedBox(height: 10),
                    _buildHelperLinks(),
                    const SizedBox(height: 24),
                    _buildLoginButton(),
                    const SizedBox(height: 48),
                    _buildDivider(),
                    const SizedBox(height: 24),
                    _buildSocialLogin(),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────
  Widget _buildHeader() {
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
          child: const Text(
            'COMMUTE MATE',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: _accent,
              letterSpacing: 2.2,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          '로그인',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: _ink,
            letterSpacing: -1.2,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          '나만의 출퇴근 메이트에 오신 것을 환영해요.',
          style: TextStyle(
            fontSize: 14,
            color: _muted,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  // ── Form ───────────────────────────────────────────────
  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('아이디'),
        const SizedBox(height: 6),
        _buildTextField(
          controller: userIdController,
          hint: '아이디를 입력하세요',
          keyboardType: TextInputType.text,
        ),
        const SizedBox(height: 16),
        _fieldLabel('패스워드'),
        const SizedBox(height: 6),
        _buildTextField(
          controller: passwordController,
          hint: '패스워드를 입력하세요',
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

  // ── Helper Links ───────────────────────────────────────
  Widget _buildHelperLinks() {
    return Row(
      children: [
        _helperBtn('회원가입', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SignupScreen()),
          );
        }),
        _dot(),
        _helperBtn('아이디 찾기', () {}),
        _dot(),
        _helperBtn('패스워드 찾기', () {}),
      ],
    );
  }

  Widget _helperBtn(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: _muted,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _dot() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Text('·', style: TextStyle(color: _border, fontSize: 12)),
    );
  }

  // ── Login Button ───────────────────────────────────────
  Widget _buildLoginButton() {
    return _TactileButton(
      onTap: _isLoading ? null : _login,
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
              : const Text(
                  '로그인',
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

  // ── Divider ────────────────────────────────────────────
  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: _border)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '간편 로그인',
            style: TextStyle(
              fontSize: 12,
              color: _muted,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Expanded(child: Container(height: 1, color: _border)),
      ],
    );
  }

  // ── Social Login ───────────────────────────────────────
  Widget _buildSocialLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _socialBtn(
          asset: 'assets/images/naver_circle_icon.png',
          label: '네이버',
          onTap: () {},
        ),
        const SizedBox(width: 16),
        _socialBtn(
          asset: 'assets/images/kakao_circle_icon.png',
          label: '카카오',
          onTap: _loginWithKakao,
        ),
        const SizedBox(width: 16),
        _socialBtn(
          asset: 'assets/images/google_circle_icon.png',
          label: '구글',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _socialBtn({
    required String asset,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: _surface,
              border: Border.all(color: _border),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  asset,
                  width: 34,
                  height: 34,
                  cacheWidth: 68,
                  cacheHeight: 68,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: _muted,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
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
