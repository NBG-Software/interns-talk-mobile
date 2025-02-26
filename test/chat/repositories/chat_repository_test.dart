import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:interns_talk_mobile/common/result.dart';
import 'package:interns_talk_mobile/data/datasources/chat_remote_datasource.dart';
import 'package:interns_talk_mobile/data/model/chat_model.dart';
import 'package:interns_talk_mobile/data/model/message_model.dart';
import 'package:interns_talk_mobile/data/repository/chat_repository.dart';

class MockChatRemoteDatasource extends Mock implements ChatRemoteDatasource {}

void main() {
  late ChatRepository chatRepository;
  late MockChatRemoteDatasource mockChatRemoteDatasource;

  setUp(() {
    mockChatRemoteDatasource = MockChatRemoteDatasource();
    chatRepository =
        ChatRepository(chatRemoteDatasource: mockChatRemoteDatasource);
  });

  final testChats = [
    Chat(chatId: 1, mentorId: 1),
    Chat(chatId: 2, mentorId: 2)
  ];
  final testMessages = [
    MessageModel(
        id: 1,
        messageText: 'Hello',
        chatId: 1,
        senderId: 3,
        createdAt: DateTime.now()),
    MessageModel(
        id: 2,
        messageText: 'Hi',
        chatId: 1,
        senderId: 4,
        createdAt: DateTime.now())
  ];
  const testChatId = 1;
  const testMentorId = 2;

  group('ChatRepository', () {
    test('getChatList returns list of chats', () async {
      when(() => mockChatRemoteDatasource.getChatList())
          .thenAnswer((_) async => Result.success(testChats));

      final result = await chatRepository.getChatList();

      expect(result.isSuccess, true);
      expect(result.data, testChats);
    });

    test('createChat returns chat ID', () async {
      when(() => mockChatRemoteDatasource.createChat(mentorId: testMentorId))
          .thenAnswer((_) async => Result.success(testChatId));

      final result = await chatRepository.createChat(mentorId: testMentorId);

      expect(result.isSuccess, true);
      expect(result.data, testChatId);
    });

    test('getMessageHistory returns list of messages', () async {
      when(() => mockChatRemoteDatasource.getMessageHistory(testChatId))
          .thenAnswer((_) async => Result.success(testMessages));

      final result = await chatRepository.getMessageHistory(testChatId);

      expect(result.isSuccess, true);
      expect(result.data, testMessages);
    });
  });
}
