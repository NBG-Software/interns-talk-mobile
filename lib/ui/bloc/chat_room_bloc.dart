import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:interns_talk_mobile/data/model/chat_model.dart';
import 'package:interns_talk_mobile/data/model/mentor_model.dart';
import 'package:interns_talk_mobile/data/repository/chat_repository.dart';
import 'package:interns_talk_mobile/data/repository/user_repository.dart';

@lazySingleton
class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  final ChatRepository chatRepository;
  final UserRepository userRepository;

  ChatRoomBloc({
    required this.chatRepository,
    required this.userRepository,
  }) : super(ChatRoomInitial()) {
    on<GetDataEvent>(_onGetData);
    on<CreateChatEvent>(_onCreateChat);
  }

  Future<void> _onCreateChat(
      CreateChatEvent event, Emitter<ChatRoomState> emit) async {
    emit(ChatRoomLoading());
    final chat = await chatRepository.createChat(mentorId: event.mentorId);
    if (chat.isSuccess) {
      emit(ChatCreated(chat.data!));
    }else{
      emit(ChatCreatingError(chat.error ?? 'Fail to start chat'));
    }
  }

  Future<void> _onGetData(
      GetDataEvent event, Emitter<ChatRoomState> emit) async {
    emit(ChatRoomLoading());
    final chats = await chatRepository.getChatList();
    final mentors = await userRepository.getMentorList();

    if (chats.isSuccess && mentors.isSuccess) {
      emit(DataLoaded(chats: chats.data ?? [], mentors: mentors.data ?? []));
    } else {
      emit(ChatRoomError(chats.error ?? 'Fail to load chat list'));
    }
  }
}

// Events
abstract class ChatRoomEvent {}

class CreateChatEvent extends ChatRoomEvent {
  final int mentorId;

  CreateChatEvent({required this.mentorId});
}

class GetMentorListEvent extends ChatRoomEvent {}

class GetChatListEvent extends ChatRoomEvent {}

class GetDataEvent extends ChatRoomEvent {}

// Chat Room States
abstract class ChatRoomState {}

class ChatRoomInitial extends ChatRoomState {}

class ChatRoomLoading extends ChatRoomState {}

class ChatCreated extends ChatRoomState {
  final int chatId;

  ChatCreated(this.chatId);
}

class DataLoaded extends ChatRoomState {
  final List<Mentor> mentors;
  final List<Chat> chats;

  DataLoaded({required this.chats, required this.mentors});
}

// class MentorListLoaded extends ChatRoomState {
//   final List<Mentor> mentors;
//   MentorListLoaded(this.mentors);
// }

// class ChatListLoaded extends ChatRoomState {
//   final List<Chat> chats;
//   ChatListLoaded(this.chats);
// }

class ChatRoomError extends ChatRoomState {
  final String message;

  ChatRoomError(this.message);
}
class ChatCreatingError extends ChatRoomState {
  final String message;

  ChatCreatingError(this.message);
}
