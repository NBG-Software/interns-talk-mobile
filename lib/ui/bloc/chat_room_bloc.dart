import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interns_talk_mobile/data/model/chat_model.dart';
import 'package:interns_talk_mobile/data/model/mentor_model.dart';
import 'package:interns_talk_mobile/data/repository/chat_repository.dart';
import 'package:interns_talk_mobile/data/repository/user_repository.dart';

class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  final ChatRepository chatRepository;
  final UserRepository userRepository;

  ChatRoomBloc({
    required this.chatRepository,
    required this.userRepository,
  }) : super(ChatRoomInitial()) {
    on<GetDataEvent>(_onGetData);
    // on<GetMentorListEvent>(_onGetMentorList);
    // on<GetChatListEvent>(_onGetChatList);
  }

  // Future<void> _onGetMentorList(
  //     GetMentorListEvent event, Emitter<ChatRoomState> emit) async {
  //   emit(ChatRoomLoading());
  //   final result = await userRepository.getMentorList();

  //   if (result.isSuccess) {
  //     emit(MentorListLoaded(result.data!));
  //   } else {
  //     emit(ChatRoomError(result.error ?? "Failed to load mentor list"));
  //   }
  // }

  // Future<void> _onGetChatList(
  //     GetChatListEvent event, Emitter<ChatRoomState> emit) async {
  //   emit(ChatRoomLoading());
  //   final result = await chatRepository.getChatList();

  //   if (result.isSuccess) {
  //     emit(ChatListLoaded(result.data!));
  //   } else {
  //     emit(ChatRoomError(result.error ?? "Failed to load chat messages"));
  //   }
  // }

  Future<void> _onGetData(
      GetDataEvent event, Emitter<ChatRoomState> emit) async {
    emit(ChatRoomLoading());
    final chats = await chatRepository.getChatList();
    final mentors = await userRepository.getMentorList();

    if (chats.isSuccess && mentors.isSuccess) {
      emit(DataLoaded(chats: chats.data ?? [], mentors: mentors.data ?? []));
    }
    // else if (chats.isSuccess && mentors.isError) {
    //   emit(DataLoaded(chats: chats.data!, mentors: []));
    // } else if (chats.isError && mentors.isSuccess) {
    //   emit(DataLoaded(chats: [], mentors: mentors.data!));
    // }
    else {
      emit(ChatRoomError("${chats.error}"));
    }
  }
}

// Events
abstract class ChatRoomEvent {}

class GetMentorListEvent extends ChatRoomEvent {}

class GetChatListEvent extends ChatRoomEvent {}

class GetDataEvent extends ChatRoomEvent {}

// Chat Room States
abstract class ChatRoomState {}

class ChatRoomInitial extends ChatRoomState {}

class ChatRoomLoading extends ChatRoomState {}

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
