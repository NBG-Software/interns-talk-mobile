import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:interns_talk_mobile/ui/pages/conversation_page.dart';
import 'package:interns_talk_mobile/ui/pages/profile_page.dart';
import 'package:interns_talk_mobile/utils/colors.dart';
import 'package:interns_talk_mobile/utils/images.dart';
import 'package:intl/intl.dart';

class ChatRoomPage extends StatelessWidget {
  const ChatRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'Chat room',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => const ProfilePage()));
              },
              icon: Icon(CupertinoIcons.profile_circled),
            ),
          ),
        ],
      ),
      body: ChatRoomBodyView(),
    );
  }
}

class ChatRoomBodyView extends StatefulWidget {
  const ChatRoomBodyView({super.key});

  @override
  State<ChatRoomBodyView> createState() => _ChatRoomBodyViewState();
}

class _ChatRoomBodyViewState extends State<ChatRoomBodyView> {
  int chatCount = 1;
  int mentorCount = 5;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    String formattedTime = DateFormat('hh:mm a').format(now);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListView.builder(
              padding:
                  EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 30),
              itemCount: chatCount,
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            color: kUserProfileBackground,
                            borderRadius: BorderRadius.circular(8)),
                        child: Image.asset(kUserPlaceHolderImage),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'User $index',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'User $index sent you a message blahljdlsjflsjfl',
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(formattedTime)
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const ConversationPage()));
                          },
                          icon: Icon(CupertinoIcons.forward))
                    ],
                  ),
                );
              }),
          Divider(
            height: 8,
            color: kIconColorGrey,
          ),
          ListView.builder(
              padding:
                  EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 8),
              itemCount: mentorCount,
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            color: kUserProfileBackground,
                            borderRadius: BorderRadius.circular(8)),
                        child: Image.asset(kUserPlaceHolderImage),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'User $index',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Mobile BarLarLar',
                                style: TextStyle(fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              chatCount = chatCount + 1;
                              mentorCount = mentorCount - 1;
                            });
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const ConversationPage()));
                          },
                          icon: Icon(CupertinoIcons.add_circled))
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}
