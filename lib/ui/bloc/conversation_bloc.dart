import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:interns_talk_mobile/data/model/message_model.dart';
import 'package:interns_talk_mobile/data/repository/chat_repository.dart';
import 'package:interns_talk_mobile/data/service/socket_service.dart';

@lazySingleton
class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final ChatRepository chatRepository;
  final SocketService socketService;

  ConversationBloc({
    required this.chatRepository,
    required this.socketService,
  }) : super(ConversationInitial()) {
    on<GetChatHistoryEvent>(_onGetChatHistory);
    on<SendMessageEvent>(_onSendMessage);
    on<ListenMessageEvent>(_onListenMessage);

    socketService.listenForMessages(1, (message) {
      add(ListenMessageEvent(MessageModel.fromJson(message)));
    });
  }

  Future<void> _onGetChatHistory(
      GetChatHistoryEvent event, Emitter<ConversationState> emit) async {
    emit(ConversationLoading());
    final result = await chatRepository.getMessageHistory(event.chatId);

    if (result.isSuccess) {
      emit(ChatHistoryLoaded(result.data!));
    } else {
      emit(ConversationError(result.error ?? "Failed to load chat history"));
    }
  }

  Future<void> _onSendMessage(
      SendMessageEvent event, Emitter<ConversationState> emit) async {
    final message = {
      "text": event.messageText,
      "media": event.messageMedia,
      "timestamp": DateTime.now().toString()
    };

    socketService.sendMessage(event.chatId, message);

    final sentMessage = MessageModel.fromJson(message);
    emit(MessageSent(sentMessage));
  }

  void _onListenMessage(
      ListenMessageEvent event, Emitter<ConversationState> emit) {
    emit(NewMessageReceived(event.message));
  }
}

// Events
abstract class ConversationEvent {}

class GetChatHistoryEvent extends ConversationEvent {
  final int chatId;

  GetChatHistoryEvent(this.chatId);
}

class SendMessageEvent extends ConversationEvent {
  final int chatId;
  final String messageText;
  final String? messageMedia;

  SendMessageEvent({
    required this.chatId,
    required this.messageText,
    this.messageMedia,
  });
}

class ListenMessageEvent extends ConversationEvent {
  final MessageModel message;

  ListenMessageEvent(this.message);
}

// States
abstract class ConversationState {}

class ConversationInitial extends ConversationState {}

class ConversationLoading extends ConversationState {}

class ChatHistoryLoaded extends ConversationState {
  final List<MessageModel> messages;

  ChatHistoryLoaded(this.messages);
}

class MessageSent extends ConversationState {
  final MessageModel message;

  MessageSent(this.message);
}

class NewMessageReceived extends ConversationState {
  final MessageModel message;

  NewMessageReceived(this.message);
}

class ConversationError extends ConversationState {
  final String message;

  ConversationError(this.message);
}
