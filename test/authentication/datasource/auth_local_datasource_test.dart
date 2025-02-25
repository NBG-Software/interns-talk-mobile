import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interns_talk_mobile/data/datasources/auth_local_datasource.dart';
import 'package:interns_talk_mobile/utils/string.dart';
import 'package:mocktail/mocktail.dart';

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late AuthLocalDatasource authLocalDatasource;
  late MockSecureStorage mockStorage;

  setUp(() {
    mockStorage = MockSecureStorage();
    authLocalDatasource = AuthLocalDatasource(mockStorage);
  });

  group('AuthLocalDatasource', () {
    const testToken = 'mocked_token';
    const testUserId = 123;
    const testFirstName = 'John';
    const testLastName = 'Doe';

    test('should save token', () async {
      when(() => mockStorage.write(key: kAuthTokenKey, value: testToken))
          .thenAnswer((_) async {});

      await authLocalDatasource.saveToken(token: testToken);

      verify(() => mockStorage.write(key: kAuthTokenKey, value: testToken))
          .called(1);
    });

    test('should retrieve token', () async {
      when(() => mockStorage.read(key: kAuthTokenKey))
          .thenAnswer((_) async => testToken);

      final result = await authLocalDatasource.getToken();

      expect(result, testToken);
      verify(() => mockStorage.read(key: kAuthTokenKey)).called(1);
    });

    test('should delete token', () async {
      when(() => mockStorage.delete(key: kAuthTokenKey))
          .thenAnswer((_) async {});

      await authLocalDatasource.deleteToken();

      verify(() => mockStorage.delete(key: kAuthTokenKey)).called(1);
    });

    test('should return true when user is logged in', () async {
      when(() => mockStorage.read(key: kAuthTokenKey))
          .thenAnswer((_) async => testToken);

      final result = await authLocalDatasource.isLoggedIn();

      expect(result, true);
      verify(() => mockStorage.read(key: kAuthTokenKey)).called(1);
    });

    test('should return false when user is not logged in', () async {
      when(() => mockStorage.read(key: kAuthTokenKey))
          .thenAnswer((_) async => null);

      final result = await authLocalDatasource.isLoggedIn();

      expect(result, false);
      verify(() => mockStorage.read(key: kAuthTokenKey)).called(1);
    });

    test('should save user info', () async {
      when(() => mockStorage.write(key: 'userId', value: testUserId.toString()))
          .thenAnswer((_) async {});
      when(() => mockStorage.write(
          key: 'userName',
          value: '$testFirstName $testLastName')).thenAnswer((_) async {});

      await authLocalDatasource.saveUserInfo(
          testUserId, testFirstName, testLastName);

      verify(() =>
              mockStorage.write(key: 'userId', value: testUserId.toString()))
          .called(1);
      verify(() => mockStorage.write(
          key: 'userName', value: '$testFirstName $testLastName')).called(1);
    });

    test('should load user info', () async {
      when(() => mockStorage.read(key: 'userId'))
          .thenAnswer((_) async => testUserId.toString());
      when(() => mockStorage.read(key: 'userName'))
          .thenAnswer((_) async => '$testFirstName $testLastName');

      final result = await authLocalDatasource.loadUserInfo();

      expect(result, isNotNull);
      expect(result?['userId'], testUserId.toString());
      expect(result?['userName'], '$testFirstName $testLastName');

      verify(() => mockStorage.read(key: 'userId')).called(1);
      verify(() => mockStorage.read(key: 'userName')).called(1);
    });

    test('should return null when user info is missing', () async {
      when(() => mockStorage.read(key: 'userId')).thenAnswer((_) async => null);
      when(() => mockStorage.read(key: 'userName'))
          .thenAnswer((_) async => null);

      final result = await authLocalDatasource.loadUserInfo();

      expect(result, isNull);
      verify(() => mockStorage.read(key: 'userId')).called(1);
      verify(() => mockStorage.read(key: 'userName')).called(1);
    });
  });
}
