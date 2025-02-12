import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:interns_talk_mobile/utils/colors.dart';

class ChatRoomPage extends StatelessWidget {
  const ChatRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Chat room',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(CupertinoIcons.profile_circled),
          ),
        ],
      ),
      body: ChatRoomBodyView(),
    );
  }
}

class ChatRoomBodyView extends StatelessWidget {
  const ChatRoomBodyView({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now().toString();
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemCount: 4,
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.person),
                        ),
                        title: Text('User $index'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('User $index sent you a message'),
                            Text('$now')
                          ],
                        ),
                      );
                    }),
              ),
              Divider(
                height: 6,
                color: kIconColorGrey,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemCount: 10,
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.person),
                        ),
                        title: Text('User $index'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('User $index sent you a message'),
                            Text('$now')
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
