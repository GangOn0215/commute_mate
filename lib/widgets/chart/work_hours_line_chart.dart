import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WorkHoursLineChart extends StatelessWidget {
  const WorkHoursLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          // 그리드 설정
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 2,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.2),
                strokeWidth: 1,
              );
            },
          ),

          // 타이틀 설정
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text('${value.toInt()}h');
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const days = ['월', '화', '수', '목', '금'];
                  if (value.toInt() < days.length) {
                    return Text(days[value.toInt()]);
                  }
                  return Text('');
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),

          // 경계선
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),

          // 최소/최대 값
          minX: 0,
          maxX: 4,
          minY: 0,
          maxY: 12,

          // 🎨 실제 데이터 라인
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 8), // 월요일 8시간
                FlSpot(1, 9), // 화요일 9시간
                FlSpot(2, 7.5), // 수요일 7.5시간
                FlSpot(3, 10), // 목요일 10시간
                FlSpot(4, 8.5), // 금요일 8.5시간
              ],
              isCurved: true,
              color: Colors.blue,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: Colors.white,
                    strokeWidth: 2,
                    strokeColor: Colors.blue,
                  );
                },
              ),
              // 그라데이션 배경
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.withOpacity(0.3),
                    Colors.blue.withOpacity(0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
