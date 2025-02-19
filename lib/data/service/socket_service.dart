
import 'package:injectable/injectable.dart';
import 'package:interns_talk_mobile/data/datasources/api_constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

@singleton
class SocketService {
  late IO.Socket socket;

  SocketService() {
    init();
  }

  void init() {
    socket = IO.io(kBaseUrl, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
      "reconnection": true,
    });

    void sendMessage(String chatId, Map<String, dynamic> message) {
      socket.emit("chat-channel-$chatId", message);
    }

    void listenForMessages(Function(Map<String, dynamic>) onMessageReceived) {
      socket.on("receive_message", (data) {
        onMessageReceived(data);
      });
    }

    void dispose() {
      socket.disconnect();
    }
  }
}