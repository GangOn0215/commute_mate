import 'package:commute_mate/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FooterNavigation extends StatelessWidget {
  const FooterNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final paths = [
      '/home',
      '/statistics',
      '/community',
      '/points_shop',
      '/account',
    ]; // 탭에 대응하는 경로들
    final String currentPath = GoRouterState.of(context).uri.toString();

    // 현재 경로가 paths 안에서 몇 번째인지 찾는다.
    final index = paths.indexOf(currentPath);

    // indexOf는 못 찾으면 -1을 반환한다 → 그럴 때를 대비해서 안전하게 0으로 보정
    final currentIndex = index == -1 ? 0 : index;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        final targetPath = paths[index];

        if (targetPath != currentPath) {
          context.go(targetPath);
        }
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.navSelected,
      unselectedItemColor: AppColors.navUnselected,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      elevation: 10,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
        BottomNavigationBarItem(
          icon: Icon(Icons.business_center_outlined),
          label: '근태관리',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.forum), label: '커뮤니티'),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          label: '포인트 쇼핑',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_rounded),
          label: '마이페이지',
        ),
      ],
    );
  }
}
