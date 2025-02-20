import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interns_talk_mobile/data/model/chat_model.dart';
import 'package:interns_talk_mobile/data/model/mentor_model.dart';
import 'package:interns_talk_mobile/ui/bloc/chat_room_bloc.dart';
import 'package:interns_talk_mobile/ui/pages/conversation_page.dart';
import 'package:interns_talk_mobile/ui/pages/error_screen.dart';
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
              icon: Icon(
                CupertinoIcons.profile_circled,
                size: 30,
              ),
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
  Future<void> _onRefresh() async {
    setState(() {
      context.read<ChatRoomBloc>().add(GetDataEvent());
    });
  }

  Future<void> _onChatCreate({required int mentorId}) async {
    setState(() {
      context.read<ChatRoomBloc>().add(CreateChatEvent(mentorId: mentorId));
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<ChatRoomBloc>().add(GetDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: BlocConsumer<ChatRoomBloc, ChatRoomState>(
        listener: (context, state) async {
          if (state is ChatCreated) {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ConversationPage(chatId: state.chatId),
              ),
            );
            context.read<ChatRoomBloc>().add(GetDataEvent());
          }
        },
        builder: (context, state) {
          if (state is ChatRoomLoading) {
            return _buildLoading("Loading chat list");
          } else if (state is ChatRoomError) {
            return _buildError(
                message: state.message,
                buttonText: 'Retry',
                onBtnClick: _onRefresh);
          } else if (state is ChatCreatingError) {
            return _buildError(
                message: state.message,
                buttonText: 'Ok',
                onBtnClick: _onRefresh);
          } else if (state is DataLoaded) {
            return _buildChatAndMentorList(state);
          } else if (state is ChatRoomNoData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  SizedBox(
                    height: 30,
                  ),
                  FilledButton(onPressed: _onRefresh, child: Text('Refresh'))
                ],
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildLoading(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(message),
          ],
        ),
      ),
    );
  }

  Widget _buildError({
    required String message,
    required String buttonText,
    required VoidCallback onBtnClick,
  }) {
    return ErrorScreen(
      title: message,
      imagePath: kSorryImage,
      errorText: message,
      buttonText: buttonText,
      onBtnClick: onBtnClick,
    );
  }

  Widget _buildChatAndMentorList(DataLoaded state) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      physics: AlwaysScrollableScrollPhysics(),
      children: [
        if (state.chats.isNotEmpty) _buildChatList(state.chats),
        if (state.chats.isNotEmpty) Divider(),
        if (state.mentors.isNotEmpty) _buildMentorList(state.mentors)
      ],
    );
  }

  Widget _buildChatList(List<Chat> chats) {
    return ListView.builder(
        padding: EdgeInsetsDirectional.symmetric(vertical: 30),
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
                          '${chat.firstName} ${chat.lastName}',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'User $index sent you a message blahljdlsjflsjfl',
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(chat.updatedAt?.toIso8601String() ?? '')
                      ],
                    ),
                  ),
                ),
                IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.forward))
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
              padding: EdgeInsetsDirectional.only(bottom: 20),
              itemCount: mentors.length,
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                final mentor = mentors[index];
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
                        child: Image.network(
                          mentor.image!,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                                child:
                                    CircularProgressIndicator()); // Show loader while loading
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                                kUserPlaceHolderImage); // Show error icon if loading fails
                          },
                        ),
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
                            _onChatCreate(mentorId: mentor.id);
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
