import 'package:commute_mate/models/work_config.dart';
import 'package:commute_mate/provider/user_provider.dart';
import 'package:commute_mate/screens/account/profile_edit_screen.dart';
import 'package:commute_mate/widgets/account_header_icon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  // ── Design Tokens ──────────────────────────────────────
  static const _bg = Color(0xFFF9FAFB);
  static const _surface = Color(0xFFFFFFFF);
  static const _ink = Color(0xFF09090B);
  static const _muted = Color(0xFF71717A);
  static const _border = Color(0xFFE4E4E7);
  static const _accent = Color(0xFF059669);
  static const _danger = Color(0xFFEF4444);
  static const _blue = Color(0xFF3B82F6);

  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (mounted) setState(() => _version = packageInfo.version);
  }

  // ── Build ──────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    String two(int n) => n.toString().padLeft(2, '0');
    String settingTime =
        '${two(WorkConfig.instance.startHour)}:${two(WorkConfig.instance.startMinute)}'
        ' ~ '
        '${two(WorkConfig.instance.endHour)}:${two(WorkConfig.instance.endMinute)}';

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Profile Header ─────────────────────────
              _buildProfileHeader(user),

              const SizedBox(height: 24),

              // ── Settings ───────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionLabel('설정'),
                    const SizedBox(height: 8),
                    _settingCard(
                      icon: Icons.access_time_rounded,
                      iconBg: _blue.withValues(alpha: 0.1),
                      iconColor: _blue,
                      label: '출/퇴근시간 설정',
                      trailing: Text(
                        settingTime,
                        style: const TextStyle(fontSize: 12, color: _muted),
                      ),
                      onTap: () => _showTimeSheet(context),
                    ),

                    const SizedBox(height: 24),

                    _sectionLabel('계정'),
                    const SizedBox(height: 8),
                    _settingCard(
                      icon: Icons.logout_rounded,
                      iconBg: _danger.withValues(alpha: 0.08),
                      iconColor: _danger,
                      label: '로그아웃',
                      labelColor: _danger,
                      onTap: () => _logout(context),
                    ),

                    const SizedBox(height: 24),

                    _sectionLabel('앱 정보'),
                    const SizedBox(height: 8),
                    _settingCard(
                      icon: Icons.info_outline_rounded,
                      iconBg: _border,
                      iconColor: _muted,
                      label: '버전 정보',
                      trailing: Text(
                        _version.isEmpty ? '로딩 중...' : 'v$_version',
                        style: const TextStyle(fontSize: 13, color: _muted),
                      ),
                    ),

                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Profile Header ─────────────────────────────────────
  Widget _buildProfileHeader(user) {
    return Container(
      width: double.infinity,
      color: _surface,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      child: Column(
        children: [
          // 상단 바
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '마이페이지',
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
                  MaterialPageRoute(builder: (_) => ProfileEditScreen()),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _bg,
                    border: Border.all(color: _border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '프로필 수정',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _ink,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 아바타
          const AccountHeaderIcon(),

          // 이름
          Text(
            user?.nickname?.isNotEmpty == true
                ? user!.nickname!
                : (user?.name ?? '사용자'),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: _ink,
              letterSpacing: -0.3,
            ),
          ),

          // 이메일
          if (user?.email != null) ...[
            const SizedBox(height: 2),
            Text(
              user!.email!,
              style: const TextStyle(fontSize: 13, color: _muted),
            ),
          ],

          const SizedBox(height: 10),

          // 레벨 배지
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _accent.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: _accent.withValues(alpha: 0.2)),
            ),
            child: Text(
              'Lv. ${user?.level ?? 1}',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _accent,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
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

  // ── Setting Card ───────────────────────────────────────
  Widget _settingCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String label,
    Color? labelColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _surface,
        border: Border.all(color: _border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 18, color: iconColor),
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: labelColor ?? _ink,
                  ),
                ),
                const Spacer(),
                if (trailing != null) ...[trailing, const SizedBox(width: 6)],
                if (onTap != null)
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: _muted,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Time Picker Sheet ──────────────────────────────────
  void _showTimeSheet(BuildContext context) {
    TimeOfDay start = TimeOfDay(
      hour: WorkConfig.instance.startHour,
      minute: WorkConfig.instance.startMinute,
    );
    TimeOfDay end = TimeOfDay(
      hour: WorkConfig.instance.endHour,
      minute: WorkConfig.instance.endMinute,
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Container(
          decoration: const BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 핸들
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: _border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                '출/퇴근 시간 설정',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: _ink,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 20),

              // 출근 시간
              _timeRow(
                label: '출근 시간',
                icon: Icons.login_rounded,
                iconColor: _blue,
                time: start,
                onTap: () async {
                  final picked = await showTimePicker(
                    context: ctx,
                    initialTime: start,
                  );
                  if (picked != null) {
                    WorkConfig.instance.startHour = picked.hour;
                    WorkConfig.instance.startMinute = picked.minute;
                    await WorkConfig.instance.save();
                    setSheetState(() => start = picked);
                    setState(() {});
                  }
                },
              ),

              const SizedBox(height: 10),

              // 퇴근 시간
              _timeRow(
                label: '퇴근 시간',
                icon: Icons.logout_rounded,
                iconColor: _muted,
                time: end,
                onTap: () async {
                  final picked = await showTimePicker(
                    context: ctx,
                    initialTime: end,
                  );
                  if (picked != null) {
                    WorkConfig.instance.endHour = picked.hour;
                    WorkConfig.instance.endMinute = picked.minute;
                    await WorkConfig.instance.save();
                    setSheetState(() => end = picked);
                    setState(() {});
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _timeRow({
    required String label,
    required IconData icon,
    required Color iconColor,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    final formatted =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _bg,
          border: Border.all(color: _border),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: _ink,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Text(
              formatted,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: _ink,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right_rounded, size: 18, color: _muted),
          ],
        ),
      ),
    );
  }

  // ── Logout ─────────────────────────────────────────────
  Future<void> _logout(BuildContext context) async {
    // 모든 await 전에 context 의존 객체 미리 캡처
    final router = GoRouter.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final provider = context.read<UserProvider>();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          '로그아웃',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
        ),
        content: const Text('정말 로그아웃 하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('취소', style: TextStyle(color: _muted)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(
              '로그아웃',
              style: TextStyle(color: _danger, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    try {
      await provider.logout();
      if (!mounted) return;
      router.go('/login');
      messenger.showSnackBar(
        const SnackBar(
          content: Text('로그아웃되었습니다.'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text('로그아웃 중 오류가 발생했습니다: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
