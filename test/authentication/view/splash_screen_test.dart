import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:interns_talk_mobile/ui/bloc/auth_bloc.dart';
import 'package:interns_talk_mobile/ui/bloc/chat_room_bloc.dart';
import 'package:interns_talk_mobile/ui/bloc/splash_bloc.dart';
import 'package:interns_talk_mobile/ui/pages/chat_room_page.dart';
import 'package:interns_talk_mobile/ui/pages/login_page.dart';
import 'package:interns_talk_mobile/ui/pages/splash_screen.dart';

// Mock classes
class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class MockChatRoomBloc extends MockBloc<ChatRoomEvent, ChatRoomState>
    implements ChatRoomBloc {}

class MockSplashBloc extends MockBloc<SplashEvent, SplashState>
    implements SplashBloc {}

void main() {
  late MockSplashBloc mockSplashBloc;
  late MockChatRoomBloc mockChatRoomBloc;
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockSplashBloc = MockSplashBloc();
    mockChatRoomBloc = MockChatRoomBloc();
    mockAuthBloc = MockAuthBloc();

    when(() => mockSplashBloc.state).thenReturn(SplashInitial());
    when(() => mockSplashBloc.stream)
        .thenAnswer((_) => Stream.value(SplashInitial()));

    when(() => mockAuthBloc.state).thenReturn(AuthInitial());
    when(() => mockAuthBloc.stream)
        .thenAnswer((_) => Stream.value(AuthInitial()));
  });

  Widget makeTestableWidget() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<SplashBloc>(
            create: (context) => mockSplashBloc,
          ),
          BlocProvider<AuthBloc>(
            create: (context) => mockAuthBloc,
          ),
          BlocProvider<ChatRoomBloc>(
            create: (context) => mockChatRoomBloc,
          ),
        ],
        child: SplashScreen(),
      ),
    );
  }

  testWidgets("Navigates to ChatRoomPage when authenticated",
      (WidgetTester tester) async {
    when(() => mockSplashBloc.state).thenReturn(Authenticated());
    when(() => mockSplashBloc.stream)
        .thenAnswer((_) => Stream.value(Authenticated()));

    await tester.pumpWidget(makeTestableWidget());
    await tester.pumpAndSettle();

    expect(find.byType(ChatRoomPage), findsOneWidget);
  });

  testWidgets("Shows loading indicator initially", (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets("Navigates to LoginPage when unauthenticated",
      (WidgetTester tester) async {
    when(() => mockSplashBloc.state).thenReturn(Unauthenticated());
    when(() => mockSplashBloc.stream)
        .thenAnswer((_) => Stream.value(Unauthenticated()));

    await tester.pumpWidget(makeTestableWidget());
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
  });
}
