import 'package:commute_mate/models/work_recode.dart';
import 'package:commute_mate/services/work_recode_service.dart';
import 'package:flutter/foundation.dart';

class WorkRecodeProvider extends ChangeNotifier {
  final WorkRecodeService _service = WorkRecodeService();

  Map<DateTime, WorkRecode> _records = {};
  bool _isLoading = false;

  Map<DateTime, WorkRecode> get records => _records;
  bool get isLoading => _isLoading;

  WorkRecode? get todayRecord {
    final now = DateTime.now();
    return _records[DateTime.utc(now.year, now.month, now.day)];
  }

  bool get isCheckedIn => todayRecord?.checkInTime != null;
  bool get isCheckedOut =>
      todayRecord?.checkInTime != null && todayRecord?.checkOutTime != null;

  WorkRecodeProvider() {
    load();
  }

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    try {
      _records = await _service.loadAll();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 출근
  Future<void> checkIn() async {
    if (isCheckedIn) return;
    final now = DateTime.now();
    final record = WorkRecode(
      checkInTime: now,
      checkOutTime: null,
      status: WorkStatus.working,
    );
    await _service.saveToday(record);
    _records[DateTime.utc(now.year, now.month, now.day)] = record;
    notifyListeners();
  }

  /// 오늘 기록 초기화
  Future<void> resetToday() async {
    await _service.deleteToday();
    final now = DateTime.now();
    _records.remove(DateTime.utc(now.year, now.month, now.day));
    notifyListeners();
  }

  /// 퇴근
  Future<void> checkOut() async {
    if (!isCheckedIn || isCheckedOut) return;
    final now = DateTime.now();
    final today = todayRecord!;
    final updated = WorkRecode(
      checkInTime: today.checkInTime,
      checkOutTime: now,
      status: WorkStatus.completed,
    );
    await _service.saveToday(updated);
    _records[DateTime.utc(now.year, now.month, now.day)] = updated;
    notifyListeners();
  }
}
