import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interns_talk_mobile/common/result.dart';
import 'package:interns_talk_mobile/ui/bloc/profile_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:interns_talk_mobile/data/model/user_model.dart';
import 'package:interns_talk_mobile/data/repository/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {}

class FakeFile extends Fake implements File {}

void main() {
  late ProfileBloc profileBloc;
  late MockUserRepository mockUserRepository;

  setUpAll(() => {
        registerFallbackValue(FakeFile()),
      });

  setUp(() {
    mockUserRepository = MockUserRepository();
    profileBloc = ProfileBloc(mockUserRepository);
  });

  tearDown(() {
    profileBloc.close();
  });

  final testUser = User(id: 1, firstName: 'John', lastName: 'Doe');
  const testPasswordChangeMessage = 'Password changed successfully';

  group('ProfileBloc', () {
    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileLoaded] when GetUserInfoEvent is added',
      build: () {
        when(() => mockUserRepository.getUserInfo())
            .thenAnswer((_) async => Result.success(testUser));
        return profileBloc;
      },
      act: (bloc) => bloc.add(GetUserInfoEvent()),
      expect: () => [ProfileLoading(), ProfileLoaded(testUser)],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileError] when GetUserInfoEvent fails',
      build: () {
        when(() => mockUserRepository.getUserInfo())
            .thenAnswer((_) async => Result.error('Failed to fetch user info'));
        return profileBloc;
      },
      act: (bloc) => bloc.add(GetUserInfoEvent()),
      expect: () =>
          [ProfileLoading(), ProfileError('Failed to fetch user info')],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileUpdated] when EditProfileEvent is added',
      build: () {
        when(() => mockUserRepository.updateUserProfile(
              firstName: any(named: 'firstName'),
              lastName: any(named: 'lastName'),
            )).thenAnswer((_) async => Result.success(testUser));
        return profileBloc;
      },
      act: (bloc) => bloc.add(EditProfileEvent(
        firstName: 'John',
        lastName: 'Doe',
      )),
      expect: () => [ProfileLoading(), ProfileUpdated(testUser)],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileError] when EditProfileEvent fails',
      build: () {
        when(() => mockUserRepository.updateUserProfile(
                  firstName: any(named: 'firstName'),
                  lastName: any(named: 'lastName'),
                ))
            .thenAnswer((_) async => Result.error('Failed to update profile'));
        return profileBloc;
      },
      act: (bloc) => bloc.add(EditProfileEvent(
        firstName: 'John',
        lastName: 'Doe',
      )),
      expect: () =>
          [ProfileLoading(), ProfileError('Failed to update profile')],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ChangePasswordSuccess] when ChangePasswordEvent is added',
      build: () {
        when(() => mockUserRepository.changePassword(any(), any()))
            .thenAnswer((_) async => Result.success(testPasswordChangeMessage));
        return profileBloc;
      },
      act: (bloc) => bloc.add(ChangePasswordEvent(
        currentPassword: 'oldPassword',
        newPassword: 'newPassword',
      )),
      expect: () =>
          [ProfileLoading(), ChangePasswordSuccess(testPasswordChangeMessage)],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileError] when ChangePasswordEvent fails',
      build: () {
        when(() => mockUserRepository.changePassword(any(), any()))
            .thenAnswer((_) async => Result.error('Failed to change password'));
        return profileBloc;
      },
      act: (bloc) => bloc.add(ChangePasswordEvent(
        currentPassword: 'oldPassword',
        newPassword: 'newPassword',
      )),
      expect: () => [
        ProfileLoading(),
        ChangePasswordFailure('Failed to change password')
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfilePictureUpdated] when UploadProfilePictureEvent is added',
      build: () {
        when(() => mockUserRepository.uploadProfilePicture(any())).thenAnswer(
            (_) async =>
                Result.success("Profile picture updated successfully"));
        return profileBloc;
      },
      act: (bloc) => bloc.add(UploadProfilePictureEvent(FakeFile())),
      expect: () => [
        ProfileLoading(),
        ProfilePictureUpdated("Profile picture updated successfully")
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileError] when UploadProfilePictureEvent fails',
      build: () {
        when(() => mockUserRepository.uploadProfilePicture(any())).thenAnswer(
            (_) async => Result.error('Failed to upload profile picture'));
        return profileBloc;
      },
      act: (bloc) => bloc.add(UploadProfilePictureEvent(FakeFile())),
      expect: () =>
          [ProfileLoading(), ProfileError('Failed to upload profile picture')],
    );
  });
}
