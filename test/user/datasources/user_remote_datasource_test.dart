import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interns_talk_mobile/data/datasources/user_remote_datasource.dart';
import 'package:interns_talk_mobile/data/model/mentor_model.dart';
import 'package:interns_talk_mobile/data/model/user_model.dart';
import 'package:interns_talk_mobile/data/service/dio_client.dart';
import 'package:interns_talk_mobile/utils/images.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockDioClient extends Mock implements DioClient {
  final mockDio = MockDio();

  @override
  Dio get dio => mockDio;
}

void main() {
  late UserRemoteDatasource userRemoteDatasource;
  late MockDioClient mockDioClient;
  late MockDio mockDio;

  setUp(() {
    mockDioClient = MockDioClient();
    mockDio = mockDioClient.mockDio;
    userRemoteDatasource = UserRemoteDatasource(mockDioClient);
  });

  group('UserRemoteDatasource', () {
    test('should return User when getUserInfo is successful', () async {
      final mockResponse = Response(
        requestOptions: RequestOptions(path: '/user'),
        statusCode: 200,
        data: {
          'data': {
            'id': 1,
            'first_name': 'John',
            'last_name': 'Doe',
            'email': 'john@example.com'
          }
        },
      );

      when(() => mockDio.get('/user')).thenAnswer((_) async => mockResponse);

      final result = await userRemoteDatasource.getUserInfo();

      expect(result.isSuccess, true);
      expect(result.data, isA<User>());
      expect(result.data?.firstName, 'John');
    });

    test('should return error when getUserInfo fails', () async {
      when(() => mockDioClient.dio.get('/user')).thenThrow(DioException(
        requestOptions: RequestOptions(path: '/user'),
        response: Response(
          requestOptions: RequestOptions(path: '/user'),
          statusCode: 400,
          data: {'message': 'User not found'},
        ),
      ));

      final result = await userRemoteDatasource.getUserInfo();

      expect(result.isSuccess, false);
      expect(result.error, 'User not found');
    });

    test('should return updated User when updateUserProfile is successful',
        () async {
      final mockResponse = Response(
        requestOptions: RequestOptions(path: '/user'),
        statusCode: 200,
        data: {
          'data': {'first_name': 'Updated', 'last_name': 'User'}
        },
      );

      when(() => mockDio.patch('/user',
              data: {'first_name': 'Updated', 'last_name': 'User'}))
          .thenAnswer((_) async => mockResponse);

      final result = await userRemoteDatasource.updateUserProfile(
          firstName: 'Updated', lastName: 'User');

      expect(result.isSuccess, true);
      expect(result.data?.firstName, 'Updated');
    });

    test('should return success message when uploading profile picture',
        () async {
      final file = File(kAppLogo);
      final mockResponse = Response(
        requestOptions: RequestOptions(path: '/user/profile'),
        statusCode: 200,
        data: {'message': 'Profile picture updated'},
      );

      when(() => mockDio.post('/user/profile', data: any(named: 'data')))
          .thenAnswer((_) async => mockResponse);

      final result = await userRemoteDatasource.uploadProfilePicture(file);

      expect(result.isSuccess, true);
      expect(result.data, 'Profile picture updated');
    });

    test('should return list of mentors when getMentorList is successful',
        () async {
      final mockResponse = Response(
        requestOptions: RequestOptions(path: '/mentor'),
        statusCode: 200,
        data: {
          'data': [
            {'id': 1, 'first_name': 'Mentor', 'last_name': 'One'},
            {'id': 2, 'first_name': 'Mentor', 'last_name': 'Two'}
          ]
        },
      );

      when(() => mockDio.get('/mentor')).thenAnswer((_) async => mockResponse);

      final result = await userRemoteDatasource.getMentorList();
      print(result.error);
      expect(result.isSuccess, true);
      expect(result.data, isA<List<Mentor>>());
      expect(result.data?.length, 2);
    });

    test('should return success message when changing password is successful',
        () async {
      final mockResponse = Response(
        requestOptions: RequestOptions(path: '/password'),
        statusCode: 200,
        data: {'message': 'Password changed successfully'},
      );

      when(() => mockDio.post('/password',
              data: {'old_password': 'oldPass', 'new_password': 'newPass'}))
          .thenAnswer((_) async => mockResponse);

      final result =
          await userRemoteDatasource.changePassword('oldPass', 'newPass');

      expect(result.isSuccess, true);
      expect(result.data, 'Password changed successfully');
    });
  });
}
