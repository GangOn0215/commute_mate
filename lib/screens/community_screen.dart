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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.thumb_up_alt_outlined, size: 16),
                              SizedBox(width: 4),
                              Text('Like'),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.comment_outlined, size: 16),
                              SizedBox(width: 4),
                              Text('Comment'),
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
