import 'package:flutter/material.dart';
import 'package:commute_mate/widgets/chart/attendance_bar_chart.dart';
import 'package:commute_mate/widgets/chart/attendance_pie_chart.dart';
import 'package:commute_mate/widgets/chart/work_hours_line_chart.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('통계 / 근태현황'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.calendar_month), text: '캘린더'),
            Tab(icon: Icon(Icons.bar_chart), text: '통계'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 🗓️ 캘린더 탭
          _buildCalendarTab(),

          // 📊 통계 탭
          _buildStatisticsTab(),
        ],
      ),
    );
  }

  // 캘린더 탭
  Widget _buildCalendarTab() {
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
              eventLoader: (day) {
                // 여기에 해당 날짜의 이벤트 로딩 로직 추가
                return [];
              },
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
              headerStyle: HeaderStyle(
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
              ),
            ),
          ),

          // 선택된 날짜 정보
          if (_selectedDay != null) Container(),
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

  // 통계 탭
  Widget _buildStatisticsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 이번 달 요약
          _buildSummaryCards(),

          SizedBox(height: 24),

          // 주간 근무 시간 그래프
          Text(
            '주간 근무 시간',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withAlpha(16), blurRadius: 10),
              ],
            ),
            child: WorkHoursLineChart(),
          ),

          SizedBox(height: 24),

          // 출근 현황
          Text(
            '이번 달 출근 현황',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withAlpha(16), blurRadius: 10),
              ],
            ),
            child: AttendanceBarChart(),
          ),

          SizedBox(height: 24),

          // 출근률 원형 차트
          Text(
            '출근률',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withAlpha(16), blurRadius: 10),
              ],
            ),
            child: AttendancePieChart(),
          ),
        ],
      ),
    );
  }

  // 요약 카드
  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            '출근',
            '20일',
            Colors.green,
            Icons.check_circle,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard('지각', '3일', Colors.orange, Icons.schedule),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard('결근', '1일', Colors.red, Icons.cancel),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        ],
      ),
    );
  }
}
