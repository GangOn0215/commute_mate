import 'package:commute_mate/provider/work_recode_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class FooterNavigation extends StatelessWidget {
  const FooterNavigation({super.key});

  // ── Design Tokens ──────────────────────────────────────
  static const _surface = Color(0xFFFFFFFF);
  static const _border = Color(0xFFE4E4E7);

  // ── Layout Constants ───────────────────────────────────
  static const double _navHeight = 72.0;

  // ── Side Tabs (좌 2개 + 우 2개) ────────────────────────
  static const _leftTabs = [
    _TabItem(
      path: '/home',
      iconOff: Icons.home_outlined,
      iconOn: Icons.home_rounded,
      label: '홈',
    ),
    _TabItem(
      path: '/statistics',
      iconOff: Icons.bar_chart_outlined,
      iconOn: Icons.bar_chart_rounded,
      label: '근태',
    ),
  ];
  static const _rightTabs = [
    _TabItem(
      path: '/community',
      iconOff: Icons.chat_bubble_outline_rounded,
      iconOn: Icons.chat_bubble_rounded,
      label: '커뮤니티',
    ),
    _TabItem(
      path: '/account',
      iconOff: Icons.person_outline_rounded,
      iconOn: Icons.person_rounded,
      label: '마이페이지',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.toString();
    final work = context.watch<WorkRecodeProvider>();

    bool isActive(String path) => currentPath == path;
    void goTo(String path) {
      if (currentPath != path) context.go(path);
    }

    return Container(
      decoration: BoxDecoration(
        color: _surface,
        border: const Border(top: BorderSide(color: _border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: _navHeight,
          child: Row(
            children: [
              // 왼쪽 탭
              for (final tab in _leftTabs)
                Expanded(
                  child: _NavButton(
                    tab: tab,
                    isActive: isActive(tab.path),
                    onTap: () => goTo(tab.path),
                  ),
                ),
              // 중앙 FAB
              _CenterFab(work: work),
              // 오른쪽 탭
              for (final tab in _rightTabs)
                Expanded(
                  child: _NavButton(
                    tab: tab,
                    isActive: isActive(tab.path),
                    onTap: () => goTo(tab.path),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Tab Item Data ──────────────────────────────────────
class _TabItem {
  final String path;
  final IconData iconOff;
  final IconData iconOn;
  final String label;
  const _TabItem({
    required this.path,
    required this.iconOff,
    required this.iconOn,
    required this.label,
  });
}

// ── Side Nav Button ────────────────────────────────────
class _NavButton extends StatefulWidget {
  final _TabItem tab;
  final bool isActive;
  final VoidCallback onTap;
  const _NavButton({
    required this.tab,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton>
    with SingleTickerProviderStateMixin {
  static const _ink = Color(0xFF09090B);
  static const _muted = Color(0xFF71717A);

  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration: const Duration(milliseconds: 160),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.88,
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
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) => _ctrl.reverse(),
      onTapCancel: () => _ctrl.reverse(),
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _scale,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              width: 44,
              height: 30,
              decoration: BoxDecoration(
                color: widget.isActive ? _ink : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                widget.isActive ? widget.tab.iconOn : widget.tab.iconOff,
                size: 20,
                color: widget.isActive ? Colors.white : _muted,
              ),
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w400,
                color: widget.isActive ? _ink : _muted,
              ),
              child: Text(widget.tab.label),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Center FAB ─────────────────────────────────────────
class _CenterFab extends StatefulWidget {
  final WorkRecodeProvider work;
  const _CenterFab({required this.work});

  @override
  State<_CenterFab> createState() => _CenterFabState();
}

class _CenterFabState extends State<_CenterFab>
    with SingleTickerProviderStateMixin {
  static const _green = Color(0xFF059669);
  static const _amber = Color(0xFFF59E0B);
  static const _gray = Color(0xFF9CA3AF);

  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
      reverseDuration: const Duration(milliseconds: 180),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.90,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCheckedIn = widget.work.isCheckedIn;
    final isCheckedOut = widget.work.isCheckedOut;
    final isLoading = widget.work.isLoading;

    final Color fabColor;
    final IconData icon;
    final String label;
    final VoidCallback? onTap;

    if (isCheckedOut) {
      fabColor = _gray;
      icon = Icons.check_rounded;
      label = '완료';
      onTap = null;
    } else if (isCheckedIn) {
      fabColor = _amber;
      icon = Icons.logout_rounded;
      label = '퇴근';
      onTap = () => widget.work.checkOut();
    } else {
      fabColor = _green;
      icon = Icons.login_rounded;
      label = '출근';
      onTap = () => widget.work.checkIn();
    }

    return GestureDetector(
      onTap: (isLoading || onTap == null)
          ? null
          : () {
              _ctrl.forward().then((_) => _ctrl.reverse());
              onTap!();
            },
      child: ScaleTransition(
        scale: _scale,
        child: SizedBox(
          width: 88,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // FAB 원형 버튼
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: fabColor,
                  shape: BoxShape.circle,
                  boxShadow: onTap != null
                      ? [
                          BoxShadow(
                            color: fabColor.withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(14),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(height: 3),
              // 라벨
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 250),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: fabColor,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
