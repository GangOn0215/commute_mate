import 'dart:convert';
import 'package:commute_mate/models/work_recode.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkRecodeService {
  static const _key = 'work_records_v1';

  static String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Future<Map<String, dynamic>> _loadRaw() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    debugPrint('[WorkRecodeService] loadRaw: raw=$raw');
    if (raw == null) return {};
    return Map<String, dynamic>.from(jsonDecode(raw) as Map);
  }

  Future<void> _saveRaw(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(data);
    final result = await prefs.setString(_key, encoded);
    debugPrint('[WorkRecodeService] saveRaw: result=$result, data=$encoded');
  }

  /// 전체 기록 로드 → {날짜(UTC): WorkRecode}
  Future<Map<DateTime, WorkRecode>> loadAll() async {
    final raw = await _loadRaw();
    final result = <DateTime, WorkRecode>{};
    for (final entry in raw.entries) {
      try {
        final parts = entry.key.split('-');
        final date = DateTime.utc(
          int.parse(parts[0]),
          int.parse(parts[1]),
          int.parse(parts[2]),
        );
        result[date] = WorkRecode.fromJson(
          Map<String, dynamic>.from(entry.value as Map),
        );
        debugPrint('[WorkRecodeService] loadAll: loaded ${entry.key}');
      } catch (e, st) {
        debugPrint('[WorkRecodeService] loadAll: error parsing ${entry.key}: $e\n$st');
      }
    }
    debugPrint('[WorkRecodeService] loadAll: total ${result.length} records');
    return result;
  }

  /// 오늘 기록 저장 (덮어쓰기)
  Future<void> saveToday(WorkRecode record) async {
    final dateKey = _dateKey(DateTime.now());
    debugPrint('[WorkRecodeService] saveToday: key=$dateKey, record=${record.toJson()}');
    final raw = await _loadRaw();
    raw[dateKey] = record.toJson();
    await _saveRaw(raw);
  }

  /// 오늘 기록 삭제
  Future<void> deleteToday() async {
    final raw = await _loadRaw();
    raw.remove(_dateKey(DateTime.now()));
    await _saveRaw(raw);
  }
}
