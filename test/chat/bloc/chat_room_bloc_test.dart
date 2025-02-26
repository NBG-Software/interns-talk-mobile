import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interns_talk_mobile/common/result.dart';
import 'package:interns_talk_mobile/data/model/chat_model.dart';
import 'package:interns_talk_mobile/data/model/mentor_model.dart';
import 'package:interns_talk_mobile/data/repository/chat_repository.dart';
import 'package:interns_talk_mobile/data/repository/user_repository.dart';
import 'package:interns_talk_mobile/ui/bloc/chat_room_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockChatRepository extends Mock implements ChatRepository {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late ChatRoomBloc chatRoomBloc;
  late MockChatRepository mockChatRepository;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockChatRepository = MockChatRepository();
    mockUserRepository = MockUserRepository();
    chatRoomBloc = ChatRoomBloc(
      chatRepository: mockChatRepository,
      userRepository: mockUserRepository,
    );
  });

  tearDown(() => chatRoomBloc.close());

  const testChatId = 1;
  final testMentors = [Mentor(id: 1, firstName: 'John', lastName: 'Doe')];
  final testChats = [Chat(chatId: 1, mentorId: 1)];

  group('ChatRoomBloc', () {
    blocTest<ChatRoomBloc, ChatRoomState>(
      'emits [ChatRoomLoading, ChatCreated] when CreateChatEvent is added',
      build: () {
        when(() =>
                mockChatRepository.createChat(mentorId: any(named: 'mentorId')))
            .thenAnswer((_) async => Result.success(testChatId));
        return chatRoomBloc;
      },
      act: (bloc) => bloc.add(CreateChatEvent(mentorId: 1)),
      expect: () => [ChatRoomLoading(), ChatCreated(testChatId)],
    );

    blocTest<ChatRoomBloc, ChatRoomState>(
      'emits [ChatRoomLoading, DataLoaded] when GetDataEvent is added and data is available',
      build: () {
        when(() => mockChatRepository.getChatList())
            .thenAnswer((_) async => Result.success(testChats));
        when(() => mockUserRepository.getMentorList())
            .thenAnswer((_) async => Result.success(testMentors));
        return chatRoomBloc;
      },
      act: (bloc) => bloc.add(GetDataEvent()),
      expect: () => [
        ChatRoomLoading(),
        DataLoaded(chats: testChats, mentors: testMentors)
      ],
    );

    blocTest<ChatRoomBloc, ChatRoomState>(
      'emits [ChatRoomLoading, ChatRoomNoData] when GetDataEvent is added and no data is available',
      build: () {
        when(() => mockChatRepository.getChatList())
            .thenAnswer((_) async => Result.success([]));
        when(() => mockUserRepository.getMentorList())
            .thenAnswer((_) async => Result.success([]));
        return chatRoomBloc;
      },
      act: (bloc) => bloc.add(GetDataEvent()),
      expect: () => [
        ChatRoomLoading(),
        ChatRoomNoData('There is no mentor registered yet')
      ],
    );
  });
}
