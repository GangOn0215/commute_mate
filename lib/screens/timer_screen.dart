import 'package:flutter/material.dart';
import 'package:commute_mate/widgets/work_banner.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late DateTime now;
  late int currentTimeStamp;
  late DateTime targetTime;
  late int workEndTimeStamp;
  late int remainingSeconds;
  late int hours;
  late int minutes;
  late int seconds;
  late String timeString;
  late Color timerColor = const Color(0xFF2C2C2C); // 초기 색상: 진한 차콜

  late int workStartTimeStamp;
  late DateTime workStartTime;
  late DateTime workEndTime;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('퇴근냥이 🐱')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Container(alignment: Alignment.center, child: WorkBanner())],
      ),
    );
  }
}
