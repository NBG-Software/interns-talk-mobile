import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:interns_talk_mobile/data/datasources/user_remote_datasource.dart';
import 'package:interns_talk_mobile/data/model/mentor_model.dart';
import 'package:interns_talk_mobile/data/model/user_model.dart';
import 'package:interns_talk_mobile/data/repository/user_repository.dart';
import 'package:interns_talk_mobile/common/result.dart';

class MockUserRemoteDatasource extends Mock implements UserRemoteDatasource {}

class FakeFile extends Fake implements File {}

void main() {
  late UserRepository userRepository;
  late MockUserRemoteDatasource mockRemoteDatasource;

  setUpAll(() => {
        registerFallbackValue(FakeFile()),
      });

  setUp(() {
    mockRemoteDatasource = MockUserRemoteDatasource();
    userRepository = UserRepository(remoteDatasource: mockRemoteDatasource);
  });

  group('UserRepository', () {
    test('should return user data when getUserInfo succeeds', () async {
      final user = User(
          id: 1, firstName: 'John', lastName: 'Doe', email: 'john@example.com');
      when(() => mockRemoteDatasource.getUserInfo())
          .thenAnswer((_) async => Result.success(user));

      final result = await userRepository.getUserInfo();

      expect(result.isSuccess, true);
      expect(result.data, equals(user));
    });

    test('should return error when getUserInfo fails', () async {
      when(() => mockRemoteDatasource.getUserInfo())
          .thenAnswer((_) async => Result.error('Failed to fetch user'));

      final result = await userRepository.getUserInfo();

      expect(result.isError, true);
      expect(result.error, 'Failed to fetch user');
    });

    test('should return success message when password change succeeds',
        () async {
      when(() => mockRemoteDatasource.changePassword(any(), any())).thenAnswer(
          (_) async => Result.success('Password changed successfully'));

      final result = await userRepository.changePassword('oldPass', 'newPass');

      expect(result.isSuccess, true);
      expect(result.data, 'Password changed successfully');
    });

    test('should return error when password change fails', () async {
      when(() => mockRemoteDatasource.changePassword(any(), any()))
          .thenAnswer((_) async => Result.error('Failed to change password'));

      final result = await userRepository.changePassword('oldPass', 'newPass');

      expect(result.isError, true);
      expect(result.error, 'Failed to change password');
    });

    test('should return updated user when profile update succeeds', () async {
      final updatedUser = User(
          id: 1, firstName: 'John', lastName: 'Doe', email: 'john@example.com');
      when(() => mockRemoteDatasource.updateUserProfile(
              firstName: any(named: 'firstName'),
              lastName: any(named: 'lastName')))
          .thenAnswer((_) async => Result.success(updatedUser));

      final result = await userRepository.updateUserProfile(
          firstName: 'John', lastName: 'Doe');

      expect(result.isSuccess, true);
      expect(result.data, equals(updatedUser));
    });

    test('should return error when profile update fails', () async {
      when(() => mockRemoteDatasource.updateUserProfile(
              firstName: any(named: 'firstName'),
              lastName: any(named: 'lastName')))
          .thenAnswer((_) async => Result.error('Profile update failed'));

      final result = await userRepository.updateUserProfile(
          firstName: 'John', lastName: 'Doe');

      expect(result.isError, true);
      expect(result.error, 'Profile update failed');
    });

    test('should return success message when profile picture upload succeeds',
        () async {
      when(() => mockRemoteDatasource.uploadProfilePicture(any()))
          .thenAnswer((_) async => Result.success('Profile picture updated'));

      final result = await userRepository.uploadProfilePicture(FakeFile());

      expect(result.isSuccess, true);
      expect(result.data, 'Profile picture updated');
    });

    test('should return error when profile picture upload fails', () async {
      when(() => mockRemoteDatasource.uploadProfilePicture(any())).thenAnswer(
          (_) async => Result.error('Failed to upload profile picture'));

      final result = await userRepository.uploadProfilePicture(FakeFile());

      expect(result.isError, true);
      expect(result.error, 'Failed to upload profile picture');
    });

    test('should return mentor list when fetching mentors succeeds', () async {
      final mentors = [
        Mentor(
            id: 1, firstName: 'Mentor', lastName: 'One', expertise: 'Flutter')
      ];
      when(() => mockRemoteDatasource.getMentorList())
          .thenAnswer((_) async => Result.success(mentors));

      final result = await userRepository.getMentorList();

      expect(result.isSuccess, true);
      expect(result.data, equals(mentors));
    });

    test('should return error when fetching mentor list fails', () async {
      when(() => mockRemoteDatasource.getMentorList())
          .thenAnswer((_) async => Result.error('Failed to fetch mentors'));

      final result = await userRepository.getMentorList();

      expect(result.isError, true);
      expect(result.error, 'Failed to fetch mentors');
    });
  });
}
