import 'package:commute_mate/models/user.dart';
import 'package:commute_mate/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountHeaderInfo extends StatefulWidget {
  const AccountHeaderInfo({super.key});

  @override
  State<AccountHeaderInfo> createState() => _AccountHeaderInfoState();
}

class _AccountHeaderInfoState extends State<AccountHeaderInfo> {
  User? user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadUserData();
  }

  Future<void> loadUserData() async {
    // 사용자 데이터를 불러오는 로직 작성
    user = context.read<UserProvider>().user;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 닉네임
        Text(
          user?.nickname ?? "임시 닉네임",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            height: 1.0,
          ),
          overflow: TextOverflow.ellipsis, // 길면 ... 처리
          maxLines: 1,
        ),
        // 이메일
        Text(
          user?.email ?? "temp@gmail.com",
          style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.0),
          overflow: TextOverflow.ellipsis, // 길면 ... 처리
          maxLines: 1,
        ),
        const SizedBox(height: 4),
        // 레벨 표시
        Text("Lv. ${user?.level ?? 1} "),
      ],
    );
  }
}
