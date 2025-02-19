import 'package:dio/dio.dart';
import 'package:interns_talk_mobile/common/result.dart';
import 'package:interns_talk_mobile/data/model/chat_model.dart';
import 'package:interns_talk_mobile/data/service/dio_client.dart';

import '../../common/handler.dart';

class ChatRemoteDatasource {
  final DioClient dioClient;
  final Dio dio = DioClient().dio;

  ChatRemoteDatasource(this.dioClient);

  Future<Result<List<Chat>>> getChatList() async {
    try {
      final response = await dio.get('/chats/latest');

      if (response.data != null) {
        final List<dynamic> data = response.data['data'] as List<dynamic>;
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
}
