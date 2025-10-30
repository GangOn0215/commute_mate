import 'package:flutter/material.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.cyanAccent,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '일반',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.grey.shade300,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    '김모씨',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.bookmark_border),
                        ),
                      ],
                    ),

                    ListTile(
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.grey.shade300,
                      ),
                      title: Text('User $index'),
                      subtitle: Text(
                        'This is a sample post content for post number $index.',
                      ),
                      trailing: Icon(Icons.more_vert),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.thumb_up_alt_outlined, size: 16),
                              SizedBox(width: 4),
                              Text('16'),
                            ],
                          ),
                          SizedBox(width: 10),
                          Row(
                            children: [
                              Icon(Icons.mode_comment_outlined, size: 16),
                              SizedBox(width: 4),
                              Text('5'),
                            ],
                          ),
                          SizedBox(width: 10),
                          Row(
                            children: [
                              Icon(Icons.remove_red_eye_sharp, size: 16),
                              SizedBox(width: 4),
                              Text('96'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
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
