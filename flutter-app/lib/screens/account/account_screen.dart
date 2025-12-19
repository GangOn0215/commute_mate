import 'package:commute_mate/core/theme/app_colors.dart';
import 'package:commute_mate/models/work_config.dart';
import 'package:commute_mate/provider/user_provider.dart';
import 'package:commute_mate/widgets/account_header_icon.dart';
import 'package:commute_mate/widgets/account_header_info.dart';
import 'package:commute_mate/widgets/account_header_manage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    int startHour = WorkConfig.instance.startHour;
    int startMinute = WorkConfig.instance.startMinute;
    int endHour = WorkConfig.instance.endHour;
    int endMinute = WorkConfig.instance.endMinute;

    String settingTime = "";

    TimeOfDay start = TimeOfDay(
      hour: startHour, // 기본 9시
      minute: startMinute,
    );

    TimeOfDay end = TimeOfDay(
      hour: endHour, // 기본 18시
      minute: endMinute,
    );

    String two(int n) => n.toString().padLeft(2, '0');

    settingTime =
        "${two(startHour)}:${two(startMinute)} ~ ${two(endHour)}:${two(endMinute)}";

    void updateSettingTime() {
      setState(() {
        settingTime =
            "${two(startHour)}:${two(startMinute)} ~ ${two(endHour)}:${two(endMinute)}";
      });
    }

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, title: Text('팡팡월드 🐱')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white38,
                border: Border.all(color: Colors.grey.shade300, width: 1.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 왼쪽 영역 (아이콘 + 정보)
                    Expanded(
                      child: Row(
                        children: [
                          SizedBox(child: const AccountHeaderIcon()),
                          Expanded(
                            child: AccountHeaderInfo(), // 닉네임 + 이메일
                          ),
                        ],
                      ),
                    ),
                    // 오른쪽 관리 버튼
                    const AccountHeaderManage(),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white38,
                border: Border.all(color: Colors.grey.shade300, width: 1.0),
              ),
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return SizedBox(
                        height: 200,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '출/퇴근시간',
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              InkWell(
                                onTap: () async {
                                  final picked = await showTimePicker(
                                    context: context,
                                    initialTime: start,
                                  );

                                  if (picked != null) {
                                    setState(() {
                                      start = picked;
                                      // 전역 WorkConfig에 저장
                                      WorkConfig.instance.startHour =
                                          picked.hour;
                                      WorkConfig.instance.startMinute =
                                          picked.minute;
                                    });

                                    await WorkConfig.instance
                                        .save(); // SharedPreferences에 저장

                                    updateSettingTime(); // 메인 UI 반영
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 20,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '출근 시간 변경',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Row(
                                        children: [Icon(Icons.login, size: 28)],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  final picked = await showTimePicker(
                                    context: context,
                                    initialTime: end,
                                  );

                                  if (picked != null) {
                                    setState(() {
                                      end = picked;
                                      // 전역 WorkConfig에 저장
                                      WorkConfig.instance.endHour = picked.hour;
                                      WorkConfig.instance.endMinute =
                                          picked.minute;
                                    });
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 20,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '퇴근 시간 변경',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.logout, size: 32),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.access_time, size: 28),
                          SizedBox(width: 10),
                          Text('출/퇴근시간 설정', style: TextStyle(fontSize: 20)),
                          SizedBox(width: 10),
                          Text(
                            '($settingTime)',
                            style: TextStyle(
                              color: AppColors.buttonDisabledText,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Icon(Icons.keyboard_arrow_right_outlined, size: 40),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            // 로그아웃 버튼
            Container(
              decoration: BoxDecoration(
                color: Colors.white38,
                border: Border.all(color: Colors.grey.shade300, width: 1.0),
              ),
              child: InkWell(
                onTap: () async {
                  // 로그아웃 확인 다이얼로그
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('로그아웃'),
                        content: Text('정말 로그아웃 하시겠습니까?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('취소'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text(
                              '로그아웃',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirm == true && mounted) {
                    try {
                      // 로그아웃 처리
                      await context.read<UserProvider>().logout();

                      if (mounted) {
                        // 로그인 화면으로 이동
                        context.go('/login');

                        // 성공 메시지
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('로그아웃되었습니다.'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('로그아웃 중 오류가 발생했습니다: $e'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, size: 28, color: Colors.red),
                          SizedBox(width: 10),
                          Text(
                            '로그아웃',
                            style: TextStyle(fontSize: 20, color: Colors.red),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.keyboard_arrow_right_outlined,
                        size: 40,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            // 버전 정보
            Container(
              decoration: BoxDecoration(
                color: Colors.white38,
                border: Border.all(color: Colors.grey.shade300, width: 1.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline, size: 28),
                        SizedBox(width: 10),
                        Text('버전 정보', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    Text(
                      _version.isEmpty ? '로딩 중...' : 'v$_version',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.buttonDisabledText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
