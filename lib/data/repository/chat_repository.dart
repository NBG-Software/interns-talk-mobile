import 'package:interns_talk_mobile/common/result.dart';
import 'package:interns_talk_mobile/data/datasources/chat_remote_datasource.dart';
import 'package:interns_talk_mobile/data/model/chat_model.dart';

class ChatRepository {
  final ChatRemoteDatasource chatRemoteDatasource;

  ChatRepository({required this.chatRemoteDatasource});

  Future<Result<List<Chat>>> getChatList() async {
    return await chatRemoteDatasource.getChatList();
  }

  Future<Result<int>> createChat({required int mentorId}) async {
    return await chatRemoteDatasource.createChat(mentorId: mentorId);
  }
}
