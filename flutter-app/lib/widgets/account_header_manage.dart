import 'package:flutter/material.dart';
import 'package:commute_mate/core/theme/app_colors.dart';
import 'package:commute_mate/screens/account/profile_edit_screen.dart';

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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileEditScreen(),
                ),
              );
            },
            icon: Icon(Icons.manage_accounts, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }
}
