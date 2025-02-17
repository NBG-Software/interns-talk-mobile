import 'package:chatview/chatview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:interns_talk_mobile/utils/colors.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final _chatController = ChatController(
    initialMessageList: [
      Message(message: 'Hi', createdAt: DateTime.now(), sentBy: '1'),
      Message(
          message: 'Hello how can I help you?',
          createdAt: DateTime.now(),
          sentBy: '2'),
      Message(
          message: 'How is going with api progress?',
          createdAt: DateTime.now(),
          sentBy: '1'),
      Message(
          message: 'So far so good', createdAt: DateTime.now(), sentBy: '2'),
      Message(
          message: 'How about you?', createdAt: DateTime.now(), sentBy: '2'),
    ],
    scrollController: ScrollController(),
    currentUser: ChatUser(
      id: '1',
      name: 'Ko Htwe',
    ),
    otherUsers: [
      ChatUser(
        id: '2',
        name: 'Ko Hein',
      ),
    ],
  );

  void receiveMessage() async {
    _chatController.addMessage(
      Message(
        id: DateTime.now().toString(),
        message: 'I will schedule the meeting.',
        createdAt: DateTime.now(),
        sentBy: '2',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatView(
        chatController: _chatController,
        onSendTap: _onSendTap,
        featureActiveConfig: const FeatureActiveConfig(
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
              reloadButtonColor: kPrimaryColor, showDefaultReloadButton: true),
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
          actions: [
            IconButton(
              tooltip: 'Simulate Message receive',
              onPressed: receiveMessage,
              icon: Icon(
                Icons.supervised_user_circle,
                color: kIconColorGrey,
              ),
            ),
          ],
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
          closeIconColor: kAppWhite,
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
            receiptsWidgetConfig:
                const ReceiptsWidgetConfig(showReceiptsIn: ShowReceiptsIn.all),
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
    Future.delayed(const Duration(milliseconds: 300), () {
      _chatController.initialMessageList.last.setStatus =
          MessageStatus.undelivered;
    });
    Future.delayed(const Duration(seconds: 1), () {
      _chatController.initialMessageList.last.setStatus = MessageStatus.read;
    });
  }
}
