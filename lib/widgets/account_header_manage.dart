import 'package:flutter/material.dart';
import 'package:commute_mate/theme/app_colors.dart';

class AccountHeaderManage extends StatelessWidget {
  const AccountHeaderManage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.buttonPrimaryText,
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          child: IconButton(
            onPressed: () {},
            icon: Icon(Icons.manage_accounts, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }
}
