import 'package:injectable/injectable.dart';
import 'package:interns_talk_mobile/data/datasources/api_constants.dart';
import 'package:interns_talk_mobile/data/datasources/auth_local_datasource.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

@singleton
class SocketService {
  late IO.Socket socket;
  final AuthLocalDatasource authLocalDatasource;

  SocketService(this.authLocalDatasource) {
    init();
  }
  Future<void> init() async {
    final token = await authLocalDatasource.getToken();
    // socket = IO.io(
    //   kBaseUrl,
    //   IO.OptionBuilder().setTransports(['websocket']).setExtraHeaders(
    //       {'Authorization': 'Bearer $token'}).build(),
    // );
    // socket.connect();
    if (token == null || token.isEmpty) {
      print("No token found. Socket connection aborted.");
      return;
    }

    socket = IO.io(
      kBaseUrl,
      IO.OptionBuilder().setTransports(['websocket']).setExtraHeaders(
          {'Authorization': 'Bearer $token'}).build(),
    );
    socket.io.options?['reconnection'] = true;
    socket.io.options?['autoConnect'] = false;
    socket.connect();
  }

  void sendMessage(int chatId, Map<String, dynamic> message) {
    socket.emit('chat-channel-$chatId', message);
  }

  void listenForMessages(
      int chatId, Function(Map<String, dynamic>) onMessageReceived) {
    socket.on('chat-channel-$chatId', (data) {
      onMessageReceived(data);
    });
  }

  void dispose() {
    socket.disconnect();
    socket.dispose();
  }
}
