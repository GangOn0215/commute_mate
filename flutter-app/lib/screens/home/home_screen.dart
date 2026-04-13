import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:commute_mate/models/work_status.dart';
import 'package:commute_mate/provider/work_recode_provider.dart';

// ────────────────────────────────────────────────────────────
//  HomeScreen
// ────────────────────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late Timer _timer;
  WorkStatus _status = getWorkStatus(DateTime.now());

  // Staggered entrance (3 stages)
  List<AnimationController> _anims = [];
  List<Animation<double>> _fades = [];
  List<Animation<Offset>> _slides = [];

  // ── Design Tokens (Zinc palette + single accent) ──────────
  static const _bg = Color(0xFFF9FAFB); // zinc-50
  static const _surface = Color(0xFFFFFFFF);
  static const _ink = Color(0xFF09090B); // zinc-950
  static const _muted = Color(0xFF71717A); // zinc-500
  static const _border = Color(0xFFE4E4E7); // zinc-200

  // Status-specific desaturated accents (NO AI purple)
  Color get _phaseColor {
    switch (_status.phase) {
      case WorkPhase.before:
        return const Color(0xFF2563EB); // blue-600
      case WorkPhase.working:
        return const Color(0xFF059669); // emerald-600
      case WorkPhase.after:
        return const Color(0xFF64748B); // slate-500
      case WorkPhase.weekend:
        return const Color(0xFFD97706); // amber-600
    }
  }

  Color get _phaseBg {
    switch (_status.phase) {
      case WorkPhase.before:
        return const Color(0xFFEFF6FF); // blue-50
      case WorkPhase.working:
        return const Color(0xFFECFDF5); // emerald-50
      case WorkPhase.after:
        return const Color(0xFFF8FAFC); // slate-50
      case WorkPhase.weekend:
        return const Color(0xFFFFFBEB); // amber-50
    }
  }

  String get _phaseLabel {
    switch (_status.phase) {
      case WorkPhase.before:
        return '출근 전';
      case WorkPhase.working:
        return '근무 중';
      case WorkPhase.after:
        return '근무 외';
      case WorkPhase.weekend:
        return '주말';
    }
  }

  String get _phaseDesc {
    switch (_status.phase) {
      case WorkPhase.before:
        return '출근까지 남은 시간';
      case WorkPhase.working:
        return '퇴근까지 남은 시간';
      case WorkPhase.after:
        return '다음 출근까지';
      case WorkPhase.weekend:
        return '다음 근무까지';
    }
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    _initAnimations();
  }

  void _initAnimations() {
    const curve = Curves.easeOutExpo;
    const slideBegin = Offset(0, 0.05);

    _anims = List.generate(
      3,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 750),
      ),
    );
    _fades = _anims
        .map(
          (c) => CurvedAnimation(parent: c, curve: curve) as Animation<double>,
        )
        .toList();
    _slides = _anims
        .map(
          (c) => Tween<Offset>(
            begin: slideBegin,
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: c, curve: curve)),
        )
        .toList();

    // Stagger: 0ms, 120ms, 240ms
    for (int i = 0; i < _anims.length; i++) {
      Future.delayed(Duration(milliseconds: i * 120), () {
        if (mounted) {
          _anims[i].forward();
        }
      });
    }
  }

  void _tick() {
    setState(() => _status = getWorkStatus(DateTime.now()));
  }

  @override
  void dispose() {
    _timer.cancel();
    for (final c in _anims) {
      c.dispose();
    }
    super.dispose();
  }

  String _fmt(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.inHours)}:${two(d.inMinutes.remainder(60))}:${two(d.inSeconds.remainder(60))}';
  }

  Widget _enter(int i, Widget child) => FadeTransition(
    opacity: _fades[i],
    child: SlideTransition(position: _slides[i], child: child),
  );

  // ────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 44),

              // ── 1. 헤더 (좌측 정렬, 비대칭) ──────────────────
              _enter(
                0,
                _buildHeader(
                  now,
                  weekdays[now.weekday - 1],
                  months[now.month - 1],
                ),
              ),

              const SizedBox(height: 36),

              // ── 2. 상태 섹션 (카드 없음, divider만) ───────────
              _enter(1, _buildStatus()),

              const SizedBox(height: 28),

              // ── 3. 비대칭 벤토 (고양이 55% | 액션 45%) ────────
              _enter(2, _buildBento(context)),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ── 헤더 ───────────────────────────────────────────────────
  Widget _buildHeader(DateTime now, String weekday, String month) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MEOW WORLD',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _muted,
                    letterSpacing: 2.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  weekday,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: _ink,
                    letterSpacing: -1.2,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${now.day} $month ${now.year}',
                  style: TextStyle(
                    fontSize: 14,
                    color: _muted,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: _surface,
                border: Border.all(color: _border),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.tune, size: 17, color: _muted),
            ),
          ),
        ],
      ),
    );
  }

  // ── 상태 섹션 (카드 없이 divider + padding) ────────────────
  Widget _buildStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 상단 구분선
        Container(height: 1, color: _border),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 배지 + 라이브 도트
              Row(
                children: [
                  // 상태 배지
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: _phaseBg,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: _phaseColor.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _phaseColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _phaseLabel,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _phaseColor,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // 라이브 펄스 인디케이터
                  _PulseDot(color: _phaseColor),
                ],
              ),

              const SizedBox(height: 18),

              // 대형 카운트다운 (tabular / monospace)
              Text(
                _fmt(_status.remain),
                style: const TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.w800,
                  color: _ink,
                  letterSpacing: -3.0,
                  height: 1.0,
                  fontFamily: 'monospace',
                ),
              ),

              const SizedBox(height: 14),

              // 설명 텍스트
              Text(
                _phaseDesc,
                style: const TextStyle(
                  fontSize: 13,
                  color: _muted,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 20),
              Container(height: 1, color: _border),
              const SizedBox(height: 20),

              // 출퇴근 버튼 영역
              Consumer<WorkRecodeProvider>(
                builder: (context, provider, _) {
                  return _buildCheckSection(context, provider);
                },
              ),
            ],
          ),
        ),
        // 하단 구분선
        Container(height: 1, color: _border),
      ],
    );
  }

  Widget _buildCheckSection(BuildContext context, WorkRecodeProvider provider) {
    // 오늘 근무 완료
    if (provider.isCheckedOut) {
      final r = provider.todayRecord!;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF059669),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '오늘 근무 완료  ·  ${r.workDurationString}',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF059669),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _ResetButton(onTap: () => _confirmReset(context, provider)),
        ],
      );
    }

    // 출근 중 → 퇴근 버튼
    if (provider.isCheckedIn) {
      final checkInTime = provider.todayRecord!.checkInTime!;
      final hh = checkInTime.hour.toString().padLeft(2, '0');
      final mm = checkInTime.minute.toString().padLeft(2, '0');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CheckButton(
            label: '퇴근하기',
            subLabel: '출근 $hh:$mm',
            onTap: () => provider.checkOut(),
          ),
          const SizedBox(height: 10),
          _ResetButton(onTap: () => _confirmReset(context, provider)),
        ],
      );
    }

    // 미출근 → 출근 버튼
    return _CheckButton(label: '출근하기', onTap: () => provider.checkIn());
  }

  void _confirmReset(BuildContext context, WorkRecodeProvider provider) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFFFFFFF),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          '오늘 기록 초기화',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF09090B),
          ),
        ),
        content: const Text(
          '오늘의 출퇴근 기록이 삭제돼요.\n정말 초기화할까요?',
          style: TextStyle(fontSize: 14, color: Color(0xFF71717A), height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              '취소',
              style: TextStyle(
                color: Color(0xFF71717A),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              provider.resetToday();
            },
            child: const Text(
              '초기화',
              style: TextStyle(
                color: Color(0xFFDC2626),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── 비대칭 벤토 (고양이 | 액션 리스트) ──────────────────────
  Widget _buildBento(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 좌측: 고양이 (flex 11 ≈ 55%)
          Expanded(
            flex: 11,
            child: Container(
              decoration: BoxDecoration(
                color: _surface,
                border: Border.all(color: _border),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x07000000),
                    blurRadius: 24,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: Lottie.asset('assets/animations/waiting_cat.json'),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                    child: Text(
                      '출근 대기 중',
                      style: TextStyle(
                        fontSize: 12,
                        color: _muted,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 10),

          // 우측: 액션 리스트 (flex 9 ≈ 45%)
          // divider로 구분 – 개별 카드 사용 안 함
          Expanded(
            flex: 9,
            child: Container(
              decoration: BoxDecoration(
                color: _surface,
                border: Border.all(color: _border),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x07000000),
                    blurRadius: 24,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  children: [
                    _actionTile(
                      context,
                      Icons.bar_chart_rounded,
                      '근태관리',
                      '/statistics',
                      first: true,
                    ),
                    Container(height: 1, color: _border),
                    _actionTile(
                      context,
                      Icons.forum_rounded,
                      '커뮤니티',
                      '/community',
                    ),
                    Container(height: 1, color: _border),
                    _actionTile(
                      context,
                      Icons.shopping_bag_rounded,
                      '포인트샵',
                      '/points_shop',
                    ),
                    Container(height: 1, color: _border),
                    _actionTile(
                      context,
                      Icons.person_rounded,
                      '마이페이지',
                      '/account',
                      last: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionTile(
    BuildContext context,
    IconData icon,
    String label,
    String path, {
    bool first = false,
    bool last = false,
  }) {
    return GestureDetector(
      onTap: () => context.go(path),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.fromLTRB(14, first ? 16 : 13, 14, last ? 16 : 13),
        child: Row(
          children: [
            Icon(icon, size: 16, color: _muted),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: _ink,
                ),
              ),
            ),
            Icon(Icons.chevron_right, size: 14, color: _muted),
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────
//  CheckButton — 출퇴근 버튼 (tactile press animation)
// ────────────────────────────────────────────────────────────
class _CheckButton extends StatefulWidget {
  final String label;
  final String? subLabel;
  final VoidCallback onTap;

  const _CheckButton({required this.label, this.subLabel, required this.onTap});

  @override
  State<_CheckButton> createState() => _CheckButtonState();
}

class _CheckButtonState extends State<_CheckButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            vertical: widget.subLabel != null ? 12 : 15,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF09090B),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.subLabel != null) ...[
                Text(
                  widget.subLabel!,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white54,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 2),
              ],
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────
//  ResetButton — 초기화 텍스트 버튼 (기록 있을 때만 표시)
// ────────────────────────────────────────────────────────────
class _ResetButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ResetButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.refresh_rounded, size: 13, color: Color(0xFFBBBBBB)),
          SizedBox(width: 4),
          Text(
            '오늘 기록 초기화',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFFBBBBBB),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────
//  PulseDot — 분리된 StatefulWidget (퍼포먼스 격리)
// ────────────────────────────────────────────────────────────
class _PulseDot extends StatefulWidget {
  final Color color;
  const _PulseDot({required this.color});

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FadeTransition(
          opacity: Tween<double>(begin: 0.3, end: 1.0).animate(_anim),
          child: Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          'LIVE',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: widget.color,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
