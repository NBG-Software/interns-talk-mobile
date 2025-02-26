import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interns_talk_mobile/data/repository/auth_repository.dart';
import 'package:interns_talk_mobile/ui/bloc/splash_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockRepository extends Mock implements AuthRepository {}

void main() {
  late SplashBloc splashBloc;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    splashBloc = SplashBloc(mockRepository);
  });

  tearDown(() {
    splashBloc.close();
  });

  group('SplashBloc', () {
    blocTest<SplashBloc, SplashState>(
        'emits [Authenticated] when CheckLoginStatus is added and user is logged in',
        build: () {
          when(() => mockRepository.isLoggedIn()).thenAnswer((_) async => true);
          return splashBloc;
        },
        act: (bloc) => bloc.add(CheckLoginStatus()),
        expect: () => [Authenticated()]);
    blocTest<SplashBloc, SplashState>(
        'emits [Unauthenticated] when CheckLoginStatus is added and user is not logged in',
        build: () {
          when(() => mockRepository.isLoggedIn())
              .thenAnswer((_) async => false);
          return splashBloc;
        },
        act: (bloc) => bloc.add(CheckLoginStatus()),
        expect: () => [Unauthenticated()]);
  });
}
