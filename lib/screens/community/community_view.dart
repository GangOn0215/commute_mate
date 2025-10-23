import 'package:commute_mate/core/theme/app_colors.dart';
import 'package:commute_mate/models/post.dart';
import 'package:flutter/material.dart';

class CommunityView extends StatefulWidget {
  final Post post; // post Data
  const CommunityView({super.key, required this.post});

  @override
  State<CommunityView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<CommunityView> {
  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    return Scaffold(
      appBar: AppBar(
        title: Text('Community'),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              // padding: EdgeInsets.all(16.0),
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 16.0,
                bottom: 16.0,
              ),
              child: Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(
                        255,
                        24,
                        21,
                        21,
                      ).withAlpha(16),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // You can add more widgets here to display post details
                        CircleAvatar(backgroundColor: AppColors.navSelected),
                        SizedBox(width: 12),
                        Text('@${post.userName}'),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 12),
                      height: 1,
                      color: AppColors.grey100,
                    ),

                    Row(
                      children: [
                        SizedBox(height: 20),
                        Text(
                          post.title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            post.content,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
