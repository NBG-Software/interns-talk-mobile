import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interns_talk_mobile/data/model/chat_model.dart';
import 'package:interns_talk_mobile/data/model/mentor_model.dart';
import 'package:interns_talk_mobile/ui/bloc/chat_room_bloc.dart';
import 'package:interns_talk_mobile/ui/pages/conversation_page.dart';
import 'package:interns_talk_mobile/ui/pages/profile_page.dart';
import 'package:interns_talk_mobile/utils/colors.dart';
import 'package:interns_talk_mobile/utils/images.dart';

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
  @override
  void initState() {
    super.initState();
    // context.read<ChatRoomBloc>().add(GetMentorListEvent());
    // context.read<ChatRoomBloc>().add(GetChatListEvent());
    context.read<ChatRoomBloc>().add(GetDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BlocBuilder<ChatRoomBloc, ChatRoomState>(builder: (context, state) {
            if (state is ChatRoomLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is DataLoaded) {
              return _buildChatList(state.chats);
            } else if (state is ChatRoomError) {
              return Center(
                child: Text(state.message),
              );
            } else {
              return Container();
            }
          }),
          BlocBuilder<ChatRoomBloc, ChatRoomState>(builder: (context, state) {
            if (state is DataLoaded) {
              if (state.chats.isNotEmpty) {
                return Divider();
              } else {
                return SizedBox.shrink();
              }
            } else {
              return SizedBox.shrink();
            }
          }),
          BlocBuilder<ChatRoomBloc, ChatRoomState>(builder: (context, state) {
            if (state is ChatRoomLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is DataLoaded) {
              return _buildMentorList(state.mentors);
            } else if (state is ChatRoomError) {
              return Center(
                child: Text(state.message),
              );
            } else {
              return Container();
            }
          })
        ],
      ),
    );
  }

  Widget _buildChatList(List<Chat> chats) {
    return ListView.builder(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 30),
        itemCount: chats.length,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          final chat = chats[index];
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
                          chat.mentorId.toString(),
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'User $index sent you a message blahljdlsjflsjfl',
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(chat.updatedAt!.toIso8601String())
                      ],
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ConversationPage()));
                    },
                    icon: Icon(CupertinoIcons.forward))
              ],
            ),
          );
        });
  }

  Widget _buildMentorList(List<Mentor> mentors) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListView.builder(
              padding:
                  EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 8),
              itemCount: mentors.length,
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                final mentor = mentors[index];
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
                                '${mentor.firstName} ${mentor.lastName}',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                mentor.expertise ?? 'General',
                                style: TextStyle(fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {});
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
