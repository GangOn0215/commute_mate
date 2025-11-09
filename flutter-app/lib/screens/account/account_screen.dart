import 'package:commute_mate/core/theme/app_colors.dart';
import 'package:commute_mate/models/work_config.dart';
import 'package:commute_mate/widgets/account_header_icon.dart';
import 'package:commute_mate/widgets/account_header_info.dart';
import 'package:commute_mate/widgets/account_header_manage.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
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
          ],
        ),
      ),
    );
  }
}
