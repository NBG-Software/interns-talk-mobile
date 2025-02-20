import 'package:chatview/chatview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interns_talk_mobile/ui/bloc/conversation_bloc.dart';
import 'package:interns_talk_mobile/utils/colors.dart';

class ConversationPage extends StatefulWidget {
  final int chatId;

  const ConversationPage({super.key, required this.chatId});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  late ChatController _chatController;

  @override
  void initState() {
    super.initState();

    _chatController = ChatController(
      initialMessageList: [],
      scrollController: ScrollController(),
      otherUsers: [ChatUser(id: '2', name: 'Ko Hein')],
      currentUser: ChatUser(id: '1', name: 'Ko Htwe'),
    );
    context.read<ConversationBloc>().add(GetChatHistoryEvent(widget.chatId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConversationBloc, ConversationState>(
      listener: (context, state) {
        if (state is ChatHistoryLoaded) {
          setState(() {
            _chatController.initialMessageList = state.messages
                .map((msg) => Message(
                      id: msg.id.toString(),
                      message: msg.messageMedia ?? msg.messageText,
                      createdAt: msg.createdAt.toLocal(),
                      sentBy: msg.senderId.toString(),
                    ))
                .toList();
          });
        } else if (state is NewMessageReceived) {
          _chatController.addMessage(Message(
            message: state.message.messageMedia ?? state.message.messageText,
            createdAt: state.message.createdAt,
            sentBy: state.message.senderId.toString(),
          ));
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
            receiptsBuilderVisibility: true,
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
          chatViewState: ChatViewState.hasMessages,
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
            chatTitle: 'Ko Hein',
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
          reactionPopupConfig: ReactionPopupConfiguration(
            shadow: BoxShadow(
              color: Colors.black54,
              blurRadius: 20,
            ),
            backgroundColor: kAppBlack,
          ),
          messageConfig: MessageConfiguration(
            messageReactionConfig: MessageReactionConfiguration(
              backgroundColor: kAppWhite,
              borderColor: kTextFieldContainer,
              reactedUserCountTextStyle: TextStyle(color: kTextColor),
              reactionCountTextStyle: TextStyle(color: kTextColor),
              reactionsBottomSheetConfig: ReactionsBottomSheetConfiguration(
                backgroundColor: kSurfaceGrey,
                reactedUserTextStyle: TextStyle(
                  color: kTextColor,
                ),
                reactionWidgetDecoration: BoxDecoration(
                  color: kSurfaceGrey,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: const Offset(0, 20),
                      blurRadius: 40,
                    )
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            imageMessageConfig: ImageMessageConfiguration(
              hideShareIcon: true,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            ),
          ),
          repliedMessageConfig: RepliedMessageConfiguration(
            backgroundColor: kReceiveMessageColor,
            verticalBarColor: kReceiveMessageColor,
            repliedMsgAutoScrollConfig: RepliedMsgAutoScrollConfig(
              enableHighlightRepliedMsg: true,
              highlightColor: Colors.pinkAccent.shade100,
              highlightScale: 1.1,
            ),
            textStyle: const TextStyle(
              color: kTextColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.25,
            ),
            replyTitleTextStyle: TextStyle(color: kTextColor),
          ),
          swipeToReplyConfig: SwipeToReplyConfiguration(
            replyIconColor: kPrimaryColor,
          ),
        ),
      ),
    );
  }

  void _onSendTap(
    String message,
    ReplyMessage replyMessage,
    MessageType messageType,
  ) {
    _chatController.addMessage(
      Message(
        id: DateTime.now().toString(),
        createdAt: DateTime.now(),
        message: message,
        sentBy: _chatController.currentUser.id,
        replyMessage: replyMessage,
        messageType: messageType,
      ),
    );
  }
}
