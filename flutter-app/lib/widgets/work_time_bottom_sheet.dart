import 'package:flutter/material.dart';

class WorkTimeBottomSheet extends StatelessWidget {
  const WorkTimeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [Text('출/퇴근시간', style: TextStyle(fontSize: 30))],
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                // 출근시간 선택 로직
              },
              child: const Text("출근 시간 선택"),
            ),
            InkWell(
              onTap: () {
                // 퇴근시간 선택 로직
              },
              child: const Text("퇴근 시간 선택"),
            ),
          ],
        ),
      ),
    );
  }
}
