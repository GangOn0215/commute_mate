// widgets/work_banner.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../models/work_status.dart';

class WorkBanner extends StatefulWidget {
  const WorkBanner({super.key});

  @override
  State<WorkBanner> createState() => _WorkBannerState();
}

class _WorkBannerState extends State<WorkBanner> {
  late Timer _t;
  late WorkStatus _status;

  @override
  void initState() {
    super.initState();
    _tick();
    _t = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    setState(() => _status = getWorkStatus(DateTime.now()));
  }

  @override
  void dispose() {
    _t.cancel();
    super.dispose();
  }

  String _fmt(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');

    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    return '${two(h)}:${two(m)}:${two(s)}';
  }

  @override
  Widget build(BuildContext context) {
    String title;
    switch (_status.phase) {
      case WorkPhase.before:
        title = '출근까지 남은 시간';
        break;
      case WorkPhase.working:
        title = '근무 시간입니다 (퇴근까지)';
        break;
      case WorkPhase.after:
        title = '근무 시간 외 입니다 (다음 출근까지)';
        break;
      case WorkPhase.weekend:
        title = '주말입니다 (다음 근무까지)';
        break;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Text(
          _fmt(_status.remain),
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
