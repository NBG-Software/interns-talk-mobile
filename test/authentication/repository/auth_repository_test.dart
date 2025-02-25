import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:interns_talk_mobile/common/result.dart';
import 'package:interns_talk_mobile/data/datasources/auth_local_datasource.dart';
import 'package:interns_talk_mobile/data/datasources/auth_remote_datasource.dart';
import 'package:interns_talk_mobile/data/repository/auth_repository.dart';

class MockAuthLocalDatasource extends Mock implements AuthLocalDatasource {}

class MockAuthRemoteDatasource extends Mock implements AuthRemoteDatasource {}

void main() {
  late AuthRepository authRepository;
  late MockAuthLocalDatasource mockLocalDS;
  late MockAuthRemoteDatasource mockRemoteDS;

  setUp(() {
    mockLocalDS = MockAuthLocalDatasource();
    mockRemoteDS = MockAuthRemoteDatasource();
    authRepository =
        AuthRepository(localDS: mockLocalDS, remoteDS: mockRemoteDS);
  });

  group('AuthRepository', () {
    const String testEmail = 'test@example.com';
    const String testPassword = 'password123';
    const String testToken = 'mocked_token';
    const int testUserId = 1;
    const String testFirstName = 'John';
    const String testLastName = 'Doe';

    test('should call remoteDS.logIn and return token on success', () async {
      when(() => mockRemoteDS.logIn(email: testEmail, password: testPassword))
          .thenAnswer((_) async => Result.success(testToken));

      final result =
          await authRepository.logIn(email: testEmail, password: testPassword);

      expect(result.isSuccess, true);
      expect(result.data, testToken);
      verify(() => mockRemoteDS.logIn(email: testEmail, password: testPassword))
          .called(1);
    });

    test('should call localDS.saveToken', () async {
      when(() => mockLocalDS.saveToken(token: testToken))
          .thenAnswer((_) async {});

      await authRepository.saveToken(token: testToken);

      verify(() => mockLocalDS.saveToken(token: testToken)).called(1);
    });

    test('should call localDS.saveUserInfo', () async {
      when(() =>
              mockLocalDS.saveUserInfo(testUserId, testFirstName, testLastName))
          .thenAnswer((_) async {});

      await authRepository.saveUserInfo(
          testUserId, testFirstName, testLastName);

      verify(() =>
              mockLocalDS.saveUserInfo(testUserId, testFirstName, testLastName))
          .called(1);
    });

    test('should call localDS.isLoggedIn and return true', () async {
      when(() => mockLocalDS.isLoggedIn()).thenAnswer((_) async => true);

      final result = await authRepository.isLoggedIn();

      expect(result, true);
      verify(() => mockLocalDS.isLoggedIn()).called(1);
    });

    test('should call remoteDS.sendResetEmail and return success message',
        () async {
      when(() => mockRemoteDS.sendResetEmail(email: testEmail))
          .thenAnswer((_) async => Result.success('Reset link sent'));

      final result = await authRepository.sendResetEmail(email: testEmail);

      expect(result.isSuccess, true);
      expect(result.data, 'Reset link sent');
      verify(() => mockRemoteDS.sendResetEmail(email: testEmail)).called(1);
    });

    test('should call remoteDS.signUp and return token on success', () async {
      when(() => mockRemoteDS.signUp(
            firstName: testFirstName,
            lastName: testLastName,
            email: testEmail,
            password: testPassword,
            passwordConfirmation: testPassword,
          )).thenAnswer((_) async => Result.success(testToken));

      final result = await authRepository.signUp(
        firstName: testFirstName,
        lastName: testLastName,
        email: testEmail,
        password: testPassword,
        passwordConfirmation: testPassword,
      );

      expect(result.isSuccess, true);
      expect(result.data, testToken);
      verify(() => mockRemoteDS.signUp(
            firstName: testFirstName,
            lastName: testLastName,
            email: testEmail,
            password: testPassword,
            passwordConfirmation: testPassword,
          )).called(1);
    });

    test('should call remoteDS.logOut and localDS.deleteToken', () async {
      when(() => mockRemoteDS.logOut()).thenAnswer((_) async {});
      when(() => mockLocalDS.deleteToken()).thenAnswer((_) async {});

      await authRepository.logOut();

      verify(() => mockRemoteDS.logOut()).called(1);
      verify(() => mockLocalDS.deleteToken()).called(1);
    });
  });
}
