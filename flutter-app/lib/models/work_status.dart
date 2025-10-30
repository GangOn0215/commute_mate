// core/work_status.dart

import 'package:commute_mate/models/work_config.dart';

enum WorkPhase { before, working, after, weekend }

class WorkStatus {
  final WorkPhase phase;
  final Duration remain;
  final DateTime target;

  const WorkStatus(this.phase, this.remain, this.target);
}

// int kStartHour = WorkConfig.instance.startHour;
// int kEndHour = WorkConfig.instance.endHour;

bool _isWeekend(DateTime d) {
  // now Datetime을 구해, 오늘이 주말인지 확인한다
  return d.weekday == DateTime.saturday || d.weekday == DateTime.sunday;
}

DateTime _todayAt(DateTime now, int hour) {
  return DateTime(now.year, now.month, now.day, hour, 0, 0);
}

// 다음 근무시간 까지의 시간을 구한다.
DateTime _nextWorkdayStart(DateTime now) {
  DateTime d = now.add(const Duration(days: 1));

  // 주말이 아닐때 까지 한칸 씩 밀기
  while (_isWeekend(d)) {
    d = d.add(const Duration(days: 1));
  }

  return DateTime(d.year, d.month, d.day, WorkConfig.instance.startHour);
}

WorkStatus getWorkStatus(DateTime now) {
  final start = _todayAt(now, WorkConfig.instance.startHour);
  final end = _todayAt(now, WorkConfig.instance.endHour);

  // 주말
  if (_isWeekend(now)) {
    final target = _nextWorkdayStart(now);

    return WorkStatus(WorkPhase.weekend, target.difference(now), target);
  }

  if (now.isBefore(start)) {
    // 09:00 전: 근무 전

    // 근무 전
    return WorkStatus(WorkPhase.before, start.difference(now), start);
  } else if (now.isBefore(end)) {
    // 09:00 ~ 18:00: 근무 중

    // 근무 시간 중
    return WorkStatus(WorkPhase.working, end.difference(now), end);
  } else {
    // 18:00 이후: 근무 후(야간) → 다음 영업일 09:00

    // 근무 시간 후 ( 근무 시간 외 )
    final target = _nextWorkdayStart(now);

    return WorkStatus(WorkPhase.after, target.difference(now), target);
  }
}
