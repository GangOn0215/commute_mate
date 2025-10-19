import 'package:flutter/material.dart';
import 'package:commute_mate/core/work_config.dart';
import 'package:commute_mate/theme/app_colors.dart';

class WorkConfigForm extends StatefulWidget {
  final void Function(WorkConfig) onSaved;
  const WorkConfigForm({super.key, required this.onSaved});

  @override
  State<WorkConfigForm> createState() => _WorkConfigFormState();
}

class _WorkConfigFormState extends State<WorkConfigForm> {
  TimeOfDay _start = TimeOfDay(
    hour: WorkConfig.instance.startHour,
    minute: WorkConfig.instance.startMinute,
  );

  TimeOfDay _end = TimeOfDay(
    hour: WorkConfig.instance.endHour,
    minute: WorkConfig.instance.endMinute,
  );

  //Futre 자료형은 비동기를 담는다는걸 의미
  // async 이 있다는건 내부 await이 있는 경우 기다려준다는 것
  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(context: context, initialTime: _start);

    if (picked != null) {
      setState(() {
        _start = picked;
      });
    }
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(context: context, initialTime: _end);

    if (picked != null) {
      setState(() {
        _end = picked;
      });
    }
  }

  void _save() {
    WorkConfig.instance.startHour = _start.hour;
    WorkConfig.instance.startMinute = _start.minute;
    WorkConfig.instance.endHour = _end.hour;
    WorkConfig.instance.endMinute = _end.minute;

    widget.onSaved(WorkConfig.instance);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text("출근 시간"),
          subtitle: Text(_start.format(context)),
          trailing: IconButton(
            icon: const Icon(Icons.access_time),
            onPressed: _pickStartTime,
          ),
        ),
        ListTile(
          title: const Text("퇴근 시간"),
          subtitle: Text(_end.format(context)),
          trailing: IconButton(
            icon: const Icon(Icons.access_time),
            onPressed: _pickEndTime,
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _save,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(AppColors.buttonPrimaryBg),
            foregroundColor: WidgetStateProperty.all(
              AppColors.buttonPrimaryText,
            ),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            ), // 패딩
          ),
          child: const Text("저장", style: TextStyle(fontSize: 18)),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
