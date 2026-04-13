import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:commute_mate/models/work_recode.dart';
import 'package:commute_mate/provider/work_recode_provider.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage>
    with SingleTickerProviderStateMixin {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  // ── Design Tokens (홈과 동일한 시스템) ─────────────────────
  static const _bg = Color(0xFFF9FAFB);
  static const _surface = Color(0xFFFFFFFF);
  static const _ink = Color(0xFF09090B);
  static const _muted = Color(0xFF71717A);
  static const _border = Color(0xFFE4E4E7);
  static const _accent = Color(0xFF059669); // emerald-600

  // Entry animation
  late final AnimationController _anim;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  // Provider에서 실데이터 사용 — mock 제거

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    )..forward();

    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOutExpo);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _anim, curve: Curves.easeOutExpo));
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  Map<DateTime, WorkRecode> _getRecords(BuildContext context) =>
      context.watch<WorkRecodeProvider>().records;

  List<WorkRecode> _eventsForDay(
    DateTime day,
    Map<DateTime, WorkRecode> records,
  ) {
    final r = records[DateTime.utc(day.year, day.month, day.day)];
    return r != null ? [r] : [];
  }

  int _daysWorked(Map<DateTime, WorkRecode> records) => records.keys
      .where((d) => d.year == _focusedDay.year && d.month == _focusedDay.month)
      .length;

  String _totalHours(Map<DateTime, WorkRecode> records) {
    var total = Duration.zero;
    for (final entry in records.entries) {
      if (entry.key.year == _focusedDay.year &&
          entry.key.month == _focusedDay.month) {
        if (entry.value.workDuration != null) {
          total += entry.value.workDuration!;
        }
      }
    }
    final h = total.inHours;
    final m = total.inMinutes.remainder(60);
    if (h == 0 && m == 0) return '-';
    return '${h}h ${m}m';
  }

  String _fmtTime(DateTime? dt) {
    if (dt == null) return '-';
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final records = _getRecords(context);
    final selectedEvents = _eventsForDay(_selectedDay, records);

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 44),
                  _buildHeader(months[_focusedDay.month - 1]),
                  const SizedBox(height: 32),
                  _buildSummary(records),
                  const SizedBox(height: 24),
                  _buildCalendar(records),
                  const SizedBox(height: 16),
                  _buildDayDetail(selectedEvents),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── 헤더 ───────────────────────────────────────────────────
  Widget _buildHeader(String month) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ATTENDANCE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _muted,
                    letterSpacing: 2.4,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '근태관리',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: _ink,
                    letterSpacing: -1.2,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '$month ${_focusedDay.year}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: _muted,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: _surface,
              border: Border.all(color: _border),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.tune, size: 17, color: _muted),
          ),
        ],
      ),
    );
  }

  // ── 월별 요약 (카드 없이 divider만) ────────────────────────
  Widget _buildSummary(Map<DateTime, WorkRecode> records) {
    return Column(
      children: [
        Container(height: 1, color: _border),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          child: IntrinsicHeight(
            child: Row(
              children: [
                _statItem('출근일', '${_daysWorked(records)}일'),
                Container(width: 1, color: _border),
                _statItem('근무시간', _totalHours(records)),
                Container(width: 1, color: _border),
                _statItem('이번달', '${_focusedDay.month}월'),
              ],
            ),
          ),
        ),
        Container(height: 1, color: _border),
      ],
    );
  }

  Widget _statItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: _ink,
              letterSpacing: -0.5,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: _muted,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  // ── 캘린더 ─────────────────────────────────────────────────
  Widget _buildCalendar(Map<DateTime, WorkRecode> records) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: _surface,
          border: Border.all(color: _border),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x07000000),
              blurRadius: 24,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: TableCalendar<WorkRecode>(
            locale: 'ko_KR',
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
            },
            onPageChanged: (focused) {
              setState(() => _focusedDay = focused);
            },
            eventLoader: (day) => _eventsForDay(day, records),
            calendarStyle: CalendarStyle(
              // Today: emerald accent (light tint)
              todayDecoration: BoxDecoration(
                color: _accent.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              todayTextStyle: const TextStyle(
                color: _accent,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
              // Selected: ink
              selectedDecoration: const BoxDecoration(
                color: _ink,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
              defaultTextStyle: const TextStyle(
                color: _ink,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              weekendTextStyle: const TextStyle(color: _muted, fontSize: 14),
              outsideDaysVisible: false,
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: _ink,
                letterSpacing: -0.3,
              ),
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: _muted,
                size: 20,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: _muted,
                size: 20,
              ),
              headerPadding: EdgeInsets.symmetric(vertical: 16),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _muted,
              ),
              weekendStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _muted,
              ),
            ),
            calendarBuilders: CalendarBuilders<WorkRecode>(
              // 주말 색상
              defaultBuilder: (context, day, focusedDay) {
                final isWeekend =
                    day.weekday == DateTime.saturday ||
                    day.weekday == DateTime.sunday;
                if (!isWeekend) return null;
                return Center(
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      fontSize: 14,
                      color: day.weekday == DateTime.saturday
                          ? const Color(0xFFD97706) // amber-600
                          : const Color(0xFFDC2626), // red-600
                    ),
                  ),
                );
              },
              // 이벤트 마커
              markerBuilder: (context, day, events) {
                if (events.isEmpty) return const SizedBox.shrink();
                return Positioned(
                  bottom: 5,
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: _accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // ── 선택 날짜 상세 ─────────────────────────────────────────
  Widget _buildDayDetail(List<WorkRecode> events) {
    const monthLabels = [
      '1월',
      '2월',
      '3월',
      '4월',
      '5월',
      '6월',
      '7월',
      '8월',
      '9월',
      '10월',
      '11월',
      '12월',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 1, color: _border),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Text(
                  '${monthLabels[_selectedDay.month - 1]} ${_selectedDay.day}일',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _ink,
                    letterSpacing: -0.3,
                  ),
                ),
                const Spacer(),
                if (events.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: _accent.withValues(alpha: 0.25),
                      ),
                    ),
                    child: const Text(
                      '출근 완료',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _accent,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          events.isEmpty ? _buildEmpty() : _buildRecord(events.first),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: double.infinity),
          const Icon(Icons.calendar_today_outlined, size: 26, color: _border),
          const SizedBox(height: 10),
          const Text(
            '이 날의 근태 기록이 없어요',
            style: TextStyle(
              fontSize: 14,
              color: _muted,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecord(WorkRecode r) {
    return Container(
      decoration: BoxDecoration(
        color: _surface,
        border: Border.all(color: _border),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _recordRow(
            Icons.login_rounded,
            '출근',
            _fmtTime(r.checkInTime),
            first: true,
          ),
          Container(height: 1, color: _border),
          _recordRow(Icons.logout_rounded, '퇴근', _fmtTime(r.checkOutTime)),
          Container(height: 1, color: _border),
          _recordRow(
            Icons.access_time_rounded,
            '근무시간',
            r.workDurationString,
            last: true,
          ),
        ],
      ),
    );
  }

  Widget _recordRow(
    IconData icon,
    String label,
    String value, {
    bool first = false,
    bool last = false,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, first ? 16 : 13, 16, last ? 16 : 13),
      child: Row(
        children: [
          Icon(icon, size: 15, color: _muted),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: _muted,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: _ink,
              fontWeight: FontWeight.w600,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
