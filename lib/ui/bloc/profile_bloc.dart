import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interns_talk_mobile/data/model/user_model.dart';
import 'package:interns_talk_mobile/data/repository/user_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository userRepository;

  ProfileBloc(this.userRepository) : super(ProfileInitial()) {
    on<GetUserInfoEvent>(_onGetUserInfo);
    on<EditProfileEvent>(_onEditProfile);
    on<UploadProfilePictureEvent>(_onUploadProfilePicture);
  }

  Future<void> _onGetUserInfo(
      GetUserInfoEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final result = await userRepository.getUserInfo();

    if (result.isSuccess) {
      emit(ProfileLoaded(result.data!));
    } else {
      emit(ProfileError(result.error ?? "Failed to load user info"));
    }
  }

  Future<void> _onEditProfile(
      EditProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final result = await userRepository.updateUserProfile(
      firstName: event.firstName,
      lastName: event.lastName,
    );

    if (result.isSuccess) {
      emit(ProfileUpdated(result.data!));
    } else {
      emit(ProfileError(result.error ?? "Failed to update profile"));
    }
  }

  Future<void> _onUploadProfilePicture(
      UploadProfilePictureEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final result = await userRepository.uploadProfilePicture(event.imagePath);

    if (result.isSuccess) {
      emit(ProfilePictureUpdated("Profile picture updated successfully"));
    } else {
      emit(ProfileError(result.error ?? "Failed to upload profile picture"));
    }
  }
}

// Events
abstract class ProfileEvent {}

class GetUserInfoEvent extends ProfileEvent {}

class EditProfileEvent extends ProfileEvent {
  final String firstName;
  final String lastName;

  EditProfileEvent({
    required this.firstName,
    required this.lastName,
  });
}

class UploadProfilePictureEvent extends ProfileEvent {
  final String imagePath;
  UploadProfilePictureEvent(this.imagePath);
}

// States
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final User user;
  ProfileLoaded(this.user);
}

class ProfileUpdated extends ProfileState {
  final User updatedUser;
  ProfileUpdated(this.updatedUser);
}

class ProfilePictureUpdated extends ProfileState {
  final String message;
  ProfilePictureUpdated(this.message);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
