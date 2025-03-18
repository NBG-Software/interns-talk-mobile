import 'dart:async';

import 'package:chatview/chatview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:interns_talk_mobile/data/model/message_model.dart';
import 'package:interns_talk_mobile/data/repository/chat_repository.dart';
import 'package:interns_talk_mobile/data/service/socket_service.dart';

@injectable
class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final ChatRepository chatRepository;
  final SocketService socketService;
  int? currentChatId;

  StreamSubscription<MessageModel>? _socketSubscription;

  ConversationBloc({
    required this.chatRepository,
    required this.socketService,
  }) : super(ConversationInitial()) {
    on<GetChatHistoryEvent>(_onGetChatHistory);
    on<SendMessageEvent>(_onSendMessage);
    on<NewMessageReceived>(_onNewMessageReceived);
  }

  Future<void> _onGetChatHistory(
      GetChatHistoryEvent event, Emitter<ConversationState> emit) async {
    emit(ConversationLoading());
    if (currentChatId != event.chatId) {
      currentChatId = event.chatId;
      _subscribeToChat(event.chatId);
    }
    // _socketSubscription?.cancel();

    // if (_socketSubscription == null) {
    //   _socketSubscription = socketService.messageStream.listen(
    //     (newMessage) {
    //       add(NewMessageReceived(newMessage));
    //     },
    //     onError: (error) {
    //       emit(ConversationError("Failed to listen for messages: $error"));
    //     },
    //     onDone: () {
    //       emit(ConversationError("WebSocket connection closed unexpectedly."));
    //     },
    //   );
    // }

    final result = await chatRepository.getMessageHistory(event.chatId);

    if (result.isSuccess) {
      emit(ChatHistoryLoaded(result.data!));
    } else {
      emit(ConversationError(result.error ?? "Failed to load chat history"));
    }
  }

  void _subscribeToChat(int chatId) {
    print("🔄 Subscribing to chat ID: $chatId");

    _socketSubscription?.cancel();
    socketService.subscribeToChannel(chatId);

    _socketSubscription = socketService.messageStream.listen(
      (newMessage) {
        print("📥 Received new message: ${newMessage.id}");
        add(NewMessageReceived(newMessage));
      },
      onError: (error) {
        print("⚠️ WebSocket error: $error");
      },
      onDone: () {
        print("🛑 WebSocket connection closed.");
      },
      cancelOnError: true,
    );
  }

  void _onNewMessageReceived(
      NewMessageReceived event, Emitter<ConversationState> emit) {
    print("✅ Handling NewMessageReceived event for ID: ${event.message.id}");

    final newMessage = event.message;
    final updatedMessage = Message(
        message: newMessage.messageText ?? '',
        createdAt: newMessage.createdAt ?? DateTime.now(),
        sentBy: newMessage.senderId.toString());
    emit(NewMessageAdded(updatedMessage));
  }

  Future<void> _onSendMessage(
      SendMessageEvent event, Emitter<ConversationState> emit) async {
    final result = await chatRepository.sendMessage(event.message);
    if (result.isError) {
      print('state : $state');
      emit(ConversationError(result.error ?? 'Fail to send message'));
    }
  }

  @override
  Future<void> close() {
    _socketSubscription?.cancel();
    return super.close();
  }
}

// Events
abstract class ConversationEvent {}

class GetChatHistoryEvent extends ConversationEvent {
  final int chatId;

  GetChatHistoryEvent(this.chatId);
}

class SendMessageEvent extends ConversationEvent {
  final MessageModel message;

  SendMessageEvent({
    required this.message,
  });
}

class NewMessageReceived extends ConversationEvent {
  final MessageModel message;

  NewMessageReceived(this.message);
}

// States
abstract class ConversationState {}

class ConversationInitial extends ConversationState {}

class ConversationLoading extends ConversationState {}

class ChatHistoryLoaded extends ConversationState {
  final List<MessageModel> messages;

  ChatHistoryLoaded(this.messages);
}

class NewMessageAdded extends ConversationState {
  final Message message;

  NewMessageAdded(this.message);
}

class ConversationError extends ConversationState {
  final String message;

  ConversationError(this.message);
}
