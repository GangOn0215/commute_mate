enum WorkStatus {
  none, // 미출근
  working, // 근무중
  completed, // 퇴근 완료
  dayOff, // 휴무
  vacation; // 휴가

  // 문자열 → enum 변환
  static WorkStatus fromString(String? value) {
    if (value == null) return WorkStatus.none;

    try {
      return WorkStatus.values.byName(value);
    } catch (e) {
      return WorkStatus.none;
    }
  }
}

class WorkRecode {
  final DateTime? checkInTime; // 출근 시간
  final DateTime? checkOutTime; // 퇴근 시간
  final String? memo; // 메모
  final WorkStatus status = WorkStatus.none; // 근무 상태

  WorkRecode({
    this.checkInTime,
    this.checkOutTime,
    this.memo,
    required WorkStatus status,
  });

  // 근무 시간 계산
  Duration? get workDuration {
    if (checkInTime != null && checkOutTime != null) {
      return checkOutTime!.difference(checkInTime!);
    }

    return null;
  }

  // 근무 시간 형식화
  String get workDurationString {
    final duration = workDuration;
    if (duration == null) {
      return '-';
    }

    final hours = workDuration!.inHours;
    final minutes = workDuration!.inMinutes.remainder(60);

    return '$hours시간 $minutes분';
  }

  Map<String, dynamic> toJson() {
    return {
      'checkInTime': checkInTime?.toIso8601String(),
      'checkOutTime': checkOutTime?.toIso8601String(),
      'memo': memo,
      'status': status.name,
    };
  }

  factory WorkRecode.fromJson(Map<String, dynamic> json) {
    return WorkRecode(
      checkInTime: json['checkInTime'] != null
          ? DateTime.parse(json['checkInTime'])
          : null,
      checkOutTime: json['checkOutTime'] != null
          ? DateTime.parse(json['checkOutTime'])
          : null,
      memo: json['memo'],
      status: WorkStatus.fromString(json['status']),
    );
  }
}
