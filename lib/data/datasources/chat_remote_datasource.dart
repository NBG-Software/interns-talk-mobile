import 'package:dio/dio.dart';
import 'package:interns_talk_mobile/common/result.dart';
import 'package:interns_talk_mobile/data/model/chat_model.dart';
import 'package:interns_talk_mobile/data/service/dio_client.dart';

class ChatRemoteDatasource {
  final DioClient dioClient;
  final Dio dio = DioClient().dio;

  ChatRemoteDatasource(this.dioClient);

  Future<Result<List<Chat>>> getChatList() async {
    try {
      final response = await dio.get('/chats/latest');

      if (response.data != null) {
        final data = response.data['data'];
        List<Chat> chatList = data.map((e) => Chat.fromJson(e)).toList();
        return Result.success(chatList);
      } else {
        return Result.error(
            "Failed to fetch chat list: ${response.statusMessage}");
      }
    } catch (e) {
      return Result.error("Error fetching chat list: $e");
    }
  }
}
