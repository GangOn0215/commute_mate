import 'package:commute_mate/models/work_recode.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class StatisticsCalendar extends StatefulWidget {
  const StatisticsCalendar({super.key});

  @override
  State<StatisticsCalendar> createState() => _StatisticsCalendarState();
}

class _StatisticsCalendarState extends State<StatisticsCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  final Map<DateTime, List<WorkRecode>> _events = {
    DateTime.utc(2025, 10, 20): [
      WorkRecode(
        checkInTime: DateTime.utc(2025, 10, 20, 8, 35, 0),
        checkOutTime: DateTime.utc(2025, 10, 20, 21, 2, 0),
        status: WorkStatus.completed,
      ),
    ],

    DateTime.utc(2025, 10, 21): [
      WorkRecode(
        checkInTime: DateTime.utc(2025, 10, 21, 8, 58, 0),
        checkOutTime: DateTime.utc(2025, 10, 21, 21, 2, 0),
        status: WorkStatus.completed,
      ),
    ],
  };

  List<WorkRecode> _getEventsForDay(DateTime day) {
    final key = DateTime.utc(day.year, day.month, day.day);

    return _events[key] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 캘린더
          Container(
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TableCalendar(
              locale: 'ko_KR',
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,

              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              eventLoader: _getEventsForDay,
              // 캘린더 스타일
              calendarStyle: CalendarStyle(
                // 오늘 날짜 스타일
                todayDecoration: BoxDecoration(
                  color: Colors.blue.withAlpha(128),
                  shape: BoxShape.circle,
                ),

                // 선택된 날짜 스타일
                selectedDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
              // 헤더 스타일
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarBuilders: CalendarBuilders(
                // 주말 배경색 변경
                defaultBuilder: (context, day, focusedDay) {
                  var isWeekend =
                      day.weekday == DateTime.saturday ||
                      day.weekday == DateTime.sunday;

                  if (!isWeekend) {
                    return null;
                  }
                  switch (day.weekday) {
                    case DateTime.saturday:
                      return Container(
                        margin: const EdgeInsets.all(6.0),
                        alignment: Alignment.center,
                        child: Text(
                          '${day.day}',
                          style: TextStyle(color: Colors.orangeAccent),
                        ),
                      );
                  }
                  return Container(
                    margin: const EdgeInsets.all(6.0),
                    alignment: Alignment.center,
                    child: Text(
                      '${day.day}',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  );
                },
                markerBuilder: (context, day, events) {
                  if (events.isEmpty) return SizedBox();
                  return Positioned(
                    bottom: -4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...events
                            .take(3)
                            .map(
                              (e) => Container(
                                margin: EdgeInsets.symmetric(horizontal: 1),
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        if (events.length > 3)
                          Padding(
                            padding: EdgeInsets.only(left: 2),
                            child: Text(
                              '+${events.length - 3}',
                              style: TextStyle(fontSize: 8, color: Colors.grey),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // 선택된 날짜 정보
          Container(),
          // Container(
          //   margin: EdgeInsets.symmetric(horizontal: 16),
          //   padding: EdgeInsets.all(16),
          //   decoration: BoxDecoration(
          //     color: Colors.blue.withAlpha(26),
          //     borderRadius: BorderRadius.circular(12),
          //   ),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(
          //         '${_selectedDay!.month}월 ${_selectedDay!.day}일',
          //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          //       ),
          //       SizedBox(height: 8),
          //       Row(
          //         children: [
          //           Icon(Icons.login, size: 16, color: Colors.green),
          //           SizedBox(width: 4),
          //           Text('출근: 09:00'),
          //           SizedBox(width: 16),
          //           Icon(Icons.logout, size: 16, color: Colors.red),
          //           SizedBox(width: 4),
          //           Text('퇴근: 18:00'),
          //         ],
          //       ),
          //       SizedBox(height: 4),
          //       Text('근무 시간: 8시간 30분'),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
