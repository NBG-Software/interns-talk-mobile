import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:interns_talk_mobile/common/result.dart';
import 'package:interns_talk_mobile/data/model/chat_model.dart';
import 'package:interns_talk_mobile/data/model/message_model.dart';
import 'package:interns_talk_mobile/data/service/dio_client.dart';

import '../../common/handler.dart';

@lazySingleton
class ChatRemoteDatasource {
  final DioClient dioClient;

  ChatRemoteDatasource(this.dioClient);

  Future<Result<List<Chat>>> getChatList() async {
    try {
      final response = await dioClient.dio.get('/chats/latest');

      if (response.data != null) {
        final List<dynamic> data = response.data['data'];
        List<Chat> chatList =
            data.map((e) => Chat.fromJson(e as Map<String, dynamic>)).toList();
        return Result.success(chatList);
      } else {
        return Result.error(
            "Failed to fetch chat list: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      final errorMessage = Handler.handleDioError(e);
      return Result.error(errorMessage);
    } catch (e) {
      return Result.error("Unexpected error occurred");
    }
  }

  Future<Result<int>> createChat({required int mentorId}) async {
    try {
      final response =
          await dioClient.dio.post('/chats', data: {'mentor_id': mentorId});
      if (response.data != null) {
        final int chatId = response.data['data']['chat_id'];
        return Result.success(chatId);
      } else {
        return Result.error(response.data['message']);
      }
    } on DioException catch (e) {
      final errorMessage = Handler.handleDioError(e);
      return Result.error(errorMessage);
    } catch (e) {
      return Result.error("Unexpected error occurred");
    }
  }

  Future<Result<List<MessageModel>>> getMessageHistory(int chatId) async {
    try {
      final response =
          await dioClient.dio.get('/message', data: {'chat_id': chatId});
      if (response.data != null) {
        final List<dynamic> messageList = response.data['data'];
        final List<MessageModel> messages =
            messageList.map((json) => MessageModel.fromJson(json)).toList();
        return Result.success(messages);
      } else {
        return Result.error(response.data['message']);
      }
    } on DioException catch (e) {
      final errorMessage = Handler.handleDioError(e);
      return Result.error(errorMessage);
    } catch (e) {
      return Result.error("Unexpected error occurred");
    }
  }
}
