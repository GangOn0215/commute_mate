import 'dart:collection';

import 'package:flutter/material.dart';

class CommunityScreen2 extends StatefulWidget {
  const CommunityScreen2({super.key});

  @override
  State<CommunityScreen2> createState() => _CommunityScreen2State();
}

class _CommunityScreen2State extends State<CommunityScreen2> {
  @override
  Widget build(BuildContext context) {
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
      body: Center(
        child: ListView.builder(
          itemCount: 1000,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: EdgeInsets.all(20.0),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha(16),
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
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: const Color.fromARGB(
                                255,
                                6,
                                12,
                                17,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              '@User $index',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          'Post Title $index',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(children: [Text('This is the detail of post $index.')]),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(Icons.thumb_up_alt_outlined, size: 16),
                        SizedBox(width: 5),
                        Text('2'),
                        SizedBox(width: 10),
                        Icon(Icons.comment_outlined, size: 16),
                        SizedBox(width: 5),
                        Text('3'),
                        SizedBox(width: 10),
                        Icon(Icons.remove_red_eye_sharp, size: 16),
                        SizedBox(width: 5),
                        Text('4'),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
