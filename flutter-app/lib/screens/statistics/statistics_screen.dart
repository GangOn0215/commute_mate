import 'package:commute_mate/widgets/statistics_calendar.dart';
import 'package:flutter/material.dart';

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
    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [Tab(icon: Icon(Icons.calendar_month), text: '캘린더')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 🗓️ 캘린더 탭
          StatisticsCalendar(),
        ],
      ),
    );
  }
}
