import 'dart:async';
import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:interns_talk_mobile/data/datasources/api_constants.dart';
import 'package:interns_talk_mobile/data/datasources/auth_local_datasource.dart';
import 'package:interns_talk_mobile/data/model/message_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

@injectable
class SocketService {
  final AuthLocalDatasource authLocalDatasource;
  late WebSocketChannel channel;
  StreamSubscription? _subscription;
  final _messageController = StreamController<MessageModel>.broadcast();

  Stream<MessageModel> get messageStream => _messageController.stream;

  SocketService(this.authLocalDatasource) {
    init();
  }

  void init() async {
    try {
      final token = await authLocalDatasource.getToken();
      if (token == null || token.isEmpty) {
        print("No token found. WebSocket connection aborted.");
        return;
      }

      final wsUrl = Uri.parse('$kWsUrl/app/a45zsbdsiwtd07dgtfef?token=$token');

      channel = WebSocketChannel.connect(wsUrl);
      print("✅ WebSocket connected!");
    } catch (e) {
      print("❌ Failed to connect to WebSocket: $e");
    }
  }

  void subscribeToChannel(int chatId) {
    final subscriptionMessage = jsonEncode({
      "event": "pusher:subscribe",
      "data": {"channel": 'chat-channel-$chatId'}
    });

    channel.sink.add(subscriptionMessage);
    print("📡 Subscribed to channel: $chatId");

    startListening();
  }

  void startListening() {
    if (_subscription != null) {
      print("⚠️ WebSocket is already listening.");
      return; // Prevent multiple listeners
    }
    _subscription = channel.stream.listen(
      (message) {
        try {
          // Decode the WebSocket message
          final decodedMessage = jsonDecode(message);
          print(
              "Decoded message data: ${decodedMessage["data"]} (${decodedMessage["data"].runtimeType})");

          // Ensure decodedMessage is a Map and contains the expected structure
          if (decodedMessage is Map<String, dynamic> &&
              decodedMessage.containsKey("event") &&
              decodedMessage["event"] == "MessageSent" &&
              decodedMessage.containsKey("data")) {
            final messageData = jsonDecode(decodedMessage["data"]);

            // Check if "message" exists in the decoded data
            if (messageData is Map<String, dynamic> &&
                messageData.containsKey("message")) {
              final messageModel =
                  MessageModel.fromJson(messageData["message"]);
              _messageController.add(messageModel);
            } else {
              print("⚠️ No 'message' field found in data: $messageData");
            }
          } else {
            print("⚠️ Unknown WebSocket message format: $decodedMessage");
          }
        } catch (e) {
          print("❌ Error decoding WebSocket message: $e");
        }
      },
      onError: (error) {
        print("⚠️ WebSocket error: $error");
      },
      onDone: () {
        print("🛑 WebSocket connection closed.");
      },
      cancelOnError: true,
    );
  }

  void stopListening() {
    _subscription?.cancel();
    print("🛑 WebSocket listening stopped.");
  }

  void closeConnection() {
    _messageController.close();
    channel.sink.close(status.goingAway);
    print("🛑 WebSocket connection closed.");
  }
}
