import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interns_talk_mobile/data/datasources/chat_remote_datasource.dart';
import 'package:interns_talk_mobile/data/model/chat_model.dart';
import 'package:interns_talk_mobile/data/model/message_model.dart';
import 'package:interns_talk_mobile/data/service/dio_client.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockDioClient extends Mock implements DioClient {
  final mockDio = MockDio();
  @override
  Dio get dio => mockDio;
}

void main() {
  late ChatRemoteDatasource chatRemoteDatasource;
  late MockDioClient mockDioClient;
  late Dio mockDio;

  setUp(() {
    mockDioClient = MockDioClient();
    mockDio = mockDioClient.mockDio;
    chatRemoteDatasource = ChatRemoteDatasource(mockDioClient);
  });

  group('ChatRemoteDatasource', () {
    test('getChatList returns a list of chats on success', () async {
      final mockResponse = Response(
        requestOptions: RequestOptions(path: '/chats/latest'),
        data: {
          'data': [
            {
              'chat_id': 1,
              'mentor_id': 1,
            },
            {
              'chat_id': 2,
              'mentor_id': 2,
            }
          ]
        },
        statusCode: 200,
      );

      when(() => mockDio.get(any())).thenAnswer((_) async => mockResponse);
      final result = await chatRemoteDatasource.getChatList();
      expect(result.isSuccess, true);
      expect(result.data, isA<List<Chat>>());
    });

    test('createChat returns chat ID on success', () async {
      final mockResponse = Response(
        requestOptions: RequestOptions(path: '/chats'),
        data: {
          'data': {'chat_id': 123}
        },
        statusCode: 200,
      );

      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => mockResponse);
      final result = await chatRemoteDatasource.createChat(mentorId: 1);
      expect(result.isSuccess, true);
      expect(result.data, 123);
    });

    test('getMessageHistory returns a list of messages on success', () async {
      final mockResponse = Response(
        requestOptions: RequestOptions(path: '/message'),
        data: {
          'data': [
            {'id': 1, 'message_text': 'Hello'},
            {'id': 2, 'message_text': 'Hi'}
          ]
        },
        statusCode: 200,
      );

      when(() => mockDio.get(any(), data: any(named: 'data')))
          .thenAnswer((_) async => mockResponse);
      final result = await chatRemoteDatasource.getMessageHistory(1);

      expect(result.isSuccess, true);
      expect(result.data, isA<List<MessageModel>>());
    });
  });
}
