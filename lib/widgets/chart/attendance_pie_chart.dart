import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AttendancePieChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 60,
          sections: [
            PieChartSectionData(
              value: 20,
              title: '정상\n20일',
              color: Colors.green,
              radius: 80,
              titleStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            PieChartSectionData(
              value: 3,
              title: '지각\n3일',
              color: Colors.orange,
              radius: 70,
              titleStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            PieChartSectionData(
              value: 1,
              title: '조퇴\n1일',
              color: Colors.red,
              radius: 70,
              titleStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            PieChartSectionData(
              value: 1,
              title: '결근\n1일',
              color: Colors.grey,
              radius: 70,
              titleStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
