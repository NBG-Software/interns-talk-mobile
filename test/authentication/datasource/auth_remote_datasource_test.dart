import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interns_talk_mobile/data/datasources/auth_remote_datasource.dart';
import 'package:interns_talk_mobile/data/service/dio_client.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockDioClient extends Mock implements DioClient {
  final mockDio = MockDio();

  @override
  Dio get dio => mockDio;
}

void main() {
  late AuthRemoteDatasource authRemoteDatasource;
  late MockDioClient mockDioClient;
  late MockDio mockDio;

  setUp(() {
    mockDioClient = MockDioClient();
    mockDio = mockDioClient.mockDio;
    authRemoteDatasource = AuthRemoteDatasource(mockDioClient);
  });

  group('AuthRemoteDatasource', () {
    test('should return token when login is successful', () async {
      final mockResponse = Response(
        requestOptions: RequestOptions(path: '/login'),
        statusCode: 200,
        data: {
          'data': {"token": "mocked_token"}
        },
      );

      when(() => mockDio.post(
            '/login',
            data: any(named: 'data'),
          )).thenAnswer((_) async => mockResponse);

      final result = await authRemoteDatasource.logIn(
          email: 'test@example.com', password: 'password');

      expect(result.isSuccess, true);
      expect(result.data, 'mocked_token');
    });

    test('should return error when login fails', () async {
      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
          )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 401,
          data: {'message': 'Invalid credentials'},
        ),
      ));

      final result = await authRemoteDatasource.logIn(
          email: 'wrong@example.com', password: 'wrongpassword');

      expect(result.isSuccess, false);
      expect(result.error, isNotNull);
    });

    test('should return token when sign-up is successful', () async {
      final mockResponse = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 201,
        data: {
          'data': {'token': 'mocked_token'}
        },
      );

      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
          )).thenAnswer((_) async => mockResponse);

      final result = await authRemoteDatasource.signUp(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        password: 'Password123',
        passwordConfirmation: 'Password123',
      );

      expect(result.isSuccess, true);
      expect(result.data, 'mocked_token');
    });

    test('should return error when sign-up fails', () async {
      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
          )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 400,
          data: {'message': 'Email already exists'},
        ),
      ));

      final result = await authRemoteDatasource.signUp(
        firstName: 'Jane',
        lastName: 'Doe',
        email: 'jane@example.com',
        password: 'Password123',
        passwordConfirmation: 'Password123',
      );

      expect(result.isSuccess, false);
      expect(result.error, 'Email already exists');
    });

    test('should call Dio logout without error', () async {
      when(() => mockDio.post(any()))
          .thenAnswer((_) async => Future.value(Response(
                requestOptions: RequestOptions(path: ''),
                statusCode: 200,
              )));

      await authRemoteDatasource.logOut();

      verify(() => mockDioClient.dio.post('/logout')).called(1);
    });

    test('should return success message when forgot password succeeds',
        () async {
      final mockResponse = Response(
        requestOptions: RequestOptions(path: '/password/forgot'),
        statusCode: 200,
        data: {'message': 'Reset link sent'},
      );

      when(() => mockDio.post('/password/forgot',
          data: {'email': 'test@example.com'})).thenAnswer((_) async {
        return Future.value(mockResponse);
      });

      final result =
          await authRemoteDatasource.sendResetEmail(email: 'test@example.com');
      expect(result.isSuccess, true);
      expect(result.data, 'Reset link sent');
    });

    test('should return error when forgot password fails', () async {
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 400,
            data: {'message': 'Email not found'},
          ),
        ),
      );

      final result = await authRemoteDatasource.sendResetEmail(
          email: 'unknown@example.com');

      expect(result.isSuccess, false);
      expect(result.error, 'Email not found');
    });
  });
}
