import 'package:chatview/chatview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interns_talk_mobile/data/datasources/auth_local_datasource.dart';
import 'package:interns_talk_mobile/ui/bloc/conversation_bloc.dart';
import 'package:interns_talk_mobile/utils/colors.dart';

import '../../di/injection.dart';

class ConversationPage extends StatefulWidget {
  final int chatId;
  final int mentorId;
  final String mentorName;

  const ConversationPage(
      {super.key,
      required this.chatId,
      required this.mentorId,
      required this.mentorName});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  late ChatController _chatController;
  late AuthLocalDatasource authLocalDatasource;
  ChatViewState _chatViewState = ChatViewState.loading;
  String? currentUserId;
  String? userName;

  @override
  void initState() {
    super.initState();
    authLocalDatasource = getIt<AuthLocalDatasource>();
    _loadUserAndInitController();
  }

  Future<void> _loadUserAndInitController() async {
    final userInfo = await authLocalDatasource.loadUserInfo();
    if (userInfo != null) {
      setState(() {
        currentUserId = userInfo['userId'];
        userName = userInfo['userName'];
      });

      _chatController = ChatController(
        initialMessageList: [],
        scrollController: ScrollController(),
        otherUsers: [
          ChatUser(id: (widget.mentorId).toString(), name: widget.mentorName)
        ],
        currentUser: ChatUser(
            id: currentUserId ?? '0', name: userName ?? 'Current User'),
      );
      context.read<ConversationBloc>().add(GetChatHistoryEvent(widget.chatId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConversationBloc, ConversationState>(
      listener: (context, state) {
        print("📌 Bloc state changed: $state");
        if (state is ConversationLoading) {
          setState(() {
            _chatViewState = ChatViewState.loading;
          });
        } else if (state is ChatHistoryLoaded) {
          print("✅ Messages updated: ${state.messages.length}");
          final messages = state.messages;
          _chatController.loadMoreData(messages
              .map((msg) => Message(
                    id: msg.id.toString(),
                    message: msg.messageMedia ?? msg.messageText,
                    createdAt: msg.createdAt.toLocal(),
                    sentBy: msg.senderId.toString(),
                  ))
              .toList());
          setState(() {
            _chatViewState = messages.isEmpty
                ? ChatViewState.noData
                : ChatViewState.hasMessages;
          });
        } else if (state is ConversationError) {
          setState(() {
            _chatViewState = ChatViewState.error;
          });
        }
      },
      child: Scaffold(
        body: ChatView(
          chatController: _chatController,
          onSendTap: _onSendTap,
          featureActiveConfig: const FeatureActiveConfig(
            enableReplySnackBar: false,
            enableSwipeToReply: false,
            lastSeenAgoBuilderVisibility: true,
            receiptsBuilderVisibility: false,
            enableScrollToBottomButton: true,
          ),
          scrollToBottomButtonConfig: ScrollToBottomButtonConfig(
            backgroundColor: kReceiveMessageColor,
            border: Border.all(
              color: kSurfaceGrey,
            ),
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: kSentMessageColor,
              weight: 10,
              size: 30,
            ),
          ),
          chatViewState: _chatViewState,
          chatViewStateConfig: ChatViewStateConfiguration(
            noMessageWidgetConfig: ChatViewStateWidgetConfiguration(
              showDefaultReloadButton: false,
            ),
            errorWidgetConfig: ChatViewStateWidgetConfiguration(
                reloadButtonColor: kPrimaryColor,
                showDefaultReloadButton: true),
            loadingWidgetConfig: ChatViewStateWidgetConfiguration(
              loadingIndicatorColor: kPrimaryColor,
            ),
            onReloadButtonTap: () {},
          ),
          typeIndicatorConfig: TypeIndicatorConfiguration(
            flashingCircleBrightColor: kPrimaryColor,
            flashingCircleDarkColor: kPrimaryColor,
          ),
          appBar: ChatViewAppBar(
            elevation: 2,
            backGroundColor: kTextFieldContainer,
            backArrowColor: kAppBlack,
            chatTitle: _chatController.otherUsers[0].name,
            chatTitleTextStyle: TextStyle(
              // color: theme.appBarTitleTextStyle,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              letterSpacing: 0.25,
            ),
            // userStatus: "online",
            userStatusTextStyle: const TextStyle(color: Colors.grey),
          ),
          chatBackgroundConfig: ChatBackgroundConfiguration(
            messageTimeIconColor: kTextColor,
            messageTimeTextStyle: TextStyle(color: kTextColor),
            defaultGroupSeparatorConfig: DefaultGroupSeparatorConfiguration(
              textStyle: TextStyle(
                color: kTextColor,
                fontSize: 17,
              ),
            ),
            backgroundColor: kSurfaceGrey,
          ),
          sendMessageConfig: SendMessageConfiguration(
            replyTitleColor: kTextColor,
            replyDialogColor: kTextFieldContainer,
            replyMessageColor: kTextColor,
            imagePickerIconsConfig: ImagePickerIconsConfiguration(
                galleryIconColor: kIconColorGrey,
                galleryImagePickerIcon: Icon(
                  Icons.add_circle_outline,
                  color: kPrimaryColor,
                )),
            enableCameraImagePicker: false,
            allowRecordingVoice: false,
            defaultSendButtonColor: kPrimaryColor,
            textFieldBackgroundColor: kAppWhite,
            sendButtonIcon: Icon(CupertinoIcons.paperplane_fill),
            closeIconColor: kPrimaryColor,
            textFieldConfig: TextFieldConfiguration(
              padding: EdgeInsets.symmetric(horizontal: 20),
              hintText: 'Write your message',
              hintStyle:
                  TextStyle(color: kIconColorGrey, fontWeight: FontWeight.w900),
              onMessageTyping: (status) {
                /// Do with status
                debugPrint(status.toString());
              },
              compositionThresholdTime: const Duration(seconds: 1),
              textStyle: TextStyle(color: kTextColor),
            ),
          ),
          chatBubbleConfig: ChatBubbleConfiguration(
            outgoingChatBubbleConfig: ChatBubble(
              margin: EdgeInsets.symmetric(horizontal: 16),
              textStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.25,
              ),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12)),
              linkPreviewConfig: LinkPreviewConfiguration(
                  backgroundColor: kSentMessageColor,
                  bodyStyle: TextStyle(color: kAppWhite),
                  titleStyle: TextStyle(),
                  loadingColor: kTextColor),
              receiptsWidgetConfig: const ReceiptsWidgetConfig(
                  showReceiptsIn: ShowReceiptsIn.all),
              color: kSentMessageColor,
            ),
            inComingChatBubbleConfig: ChatBubble(
              textStyle: const TextStyle(
                color: kTextColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.25,
              ),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12)),
              linkPreviewConfig: LinkPreviewConfiguration(
                linkStyle: TextStyle(
                  color: kAppWhite,
                  decoration: TextDecoration.underline,
                ),
                backgroundColor: kReceiveMessageColor,
                bodyStyle: TextStyle(color: kTextColor),
                titleStyle: TextStyle(color: kTextColor),
              ),
              senderNameTextStyle: TextStyle(color: kTextColor),
              color: kReceiveMessageColor,
            ),
          ),
        ),
      ),
    );
  }

  void _onSendTap(
      String message, ReplyMessage replyMessage, MessageType messageType) {
    if (message.trim().isEmpty) return;

    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      message: message,
      sentBy: _chatController.currentUser.id,
      replyMessage: replyMessage,
      messageType: messageType,
    );
    print("📝 Adding new message to chat: ${newMessage.message}");
    _chatController.addMessage(newMessage);

    context.read<ConversationBloc>().add(SendMessageEvent(
          chatId: widget.chatId,
          senderId: int.parse(currentUserId ?? '1'),
          messageText: message,
        ));
  }
}
