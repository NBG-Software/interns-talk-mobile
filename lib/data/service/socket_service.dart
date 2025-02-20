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
    if (token == null || token.isEmpty) {
      print("No token found. Socket connection aborted.");
      return;
    }
    socket = IO.io(
     '$kBaseUrl:3000',
      IO.OptionBuilder().setTransports(['websocket'])
          .setExtraHeaders(
          {'Authorization': 'Bearer $token',
          'X-App-Key': 'odbvje0i0aya2scsimxq'})
          .setQuery({'token': token, 'appKey' : 'odbvje0i0aya2scsimxq'})
          .build(),
    );
    socket.io.options?['reconnection'] = true;
    socket.io.options?['autoConnect'] = false;
    socket.connect();

    socket.onConnect((_) {
      print("✅ Socket connected successfully.");
    });

    socket.onDisconnect((_) {
      print("❌ Socket disconnected.");
    });

    socket.onError((error) {
      print("⚠️ Socket error: $error");
    });
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
