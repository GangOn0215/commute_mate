import 'package:commute_mate/widgets/statistics_calendar.dart';
import 'package:flutter/material.dart';
import 'package:commute_mate/widgets/chart/attendance_bar_chart.dart';
import 'package:commute_mate/widgets/chart/attendance_pie_chart.dart';
import 'package:commute_mate/widgets/chart/work_hours_line_chart.dart';
import 'package:table_calendar/table_calendar.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DateTime _focusedDay = DateTime.now();
  final DateTime _selectedDay = DateTime.now();

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
          StatisticsCalendar(),
          // 📊 통계 탭
          // _buildStatisticsTab(),
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
