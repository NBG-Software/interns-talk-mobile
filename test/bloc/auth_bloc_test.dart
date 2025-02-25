import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interns_talk_mobile/common/result.dart';
import 'package:interns_talk_mobile/data/model/user_model.dart';
import 'package:interns_talk_mobile/data/repository/auth_repository.dart';
import 'package:interns_talk_mobile/data/repository/user_repository.dart';
import 'package:interns_talk_mobile/ui/bloc/auth_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late AuthBloc authBloc;
  late MockAuthRepository mockAuthRepository;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockUserRepository = MockUserRepository();
    authBloc = AuthBloc(mockAuthRepository, mockUserRepository);
    registerFallbackValue(AuthLoginEvent(email: '', password: ''));
    registerFallbackValue(AuthSignUpEvent(
        firstName: '',
        lastName: '',
        email: '',
        password: '',
        confirmPassword: ''));
    registerFallbackValue(AuthLogoutEvent());
    registerFallbackValue(AuthForgotPasswordEvent(email: ''));
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when login succeeds',
      build: () {
        when(() => mockAuthRepository.logIn(
                email: any(named: 'email'), password: any(named: 'password')))
            .thenAnswer((_) async => Future.value(Result.success('token')));
        when(() => mockUserRepository.getUserInfo()).thenAnswer((_) async =>
            Result.success(User(id: 1, firstName: 'John', lastName: 'Doe')));
        return authBloc;
      },
      act: (bloc) => bloc
          .add(AuthLoginEvent(email: 'test@example.com', password: 'password')),
      expect: () => [AuthLoading(), AuthAuthenticated('Welcome John Doe')],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when login fails',
      build: () {
        when(() => mockAuthRepository.logIn(
                email: any(named: 'email'), password: any(named: 'password')))
            .thenAnswer((_) async => Result.error('Login failed'));
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthLoginEvent(
          email: 'wrong@example.com', password: 'wrongpassword')),
      expect: () => [AuthLoading(), AuthError('Login failed')],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when sign up succeeds',
      build: () {
        when(() => mockAuthRepository.signUp(
              firstName: any(named: 'firstName'),
              lastName: any(named: 'lastName'),
              email: any(named: 'email'),
              password: any(named: 'password'),
              passwordConfirmation: any(named: 'passwordConfirmation'),
            )).thenAnswer((_) async => Result.success('token'));
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthSignUpEvent(
          firstName: 'Jane',
          lastName: 'Doe',
          email: 'jane@example.com',
          password: 'password',
          confirmPassword: 'password')),
      expect: () => [AuthLoading(), AuthAuthenticated('Welcome Jane Doe')],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoggedOut] when logout is called',
      build: () {
        when(() => mockAuthRepository.logOut()).thenAnswer((_) async {});
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthLogoutEvent()),
      expect: () => [AuthLoggedOut()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when forgot password succeeds',
      build: () {
        when(() =>
                mockAuthRepository.sendResetEmail(email: any(named: 'email')))
            .thenAnswer((_) async => Result.success('Email Sent'));
        return authBloc;
      },
      act: (bloc) =>
          bloc.add(AuthForgotPasswordEvent(email: 'test@example.com')),
      expect: () => [AuthLoading(), AuthAuthenticated('Email Sent')],
    );
  });
}
