import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interns_talk_mobile/data/model/user_model.dart';
import 'package:interns_talk_mobile/data/repository/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<AuthLoginEvent>(_onLogin);
    on<AuthSignUpEvent>(_onSignUp);
    on<AuthLogoutEvent>(_onLogout);
    on<AuthGetUserInfoEvent>(_onGetUserInfo);
  }
  Future<void> _onGetUserInfo(
      AuthGetUserInfoEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await authRepository.getUserInfo();

    if (result.isSuccess) {
      emit(AuthUserLoaded(result.data!));
    } else {
      emit(AuthError(result.error ?? "Failed to load user info"));
    }
  }

  Future<void> _onLogin(AuthLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await authRepository.logIn(
        email: event.email, password: event.password);
    if (result.isSuccess) {
      await authRepository.saveToken(token: result.data!);
      emit(AuthAuthenticated("Welcome"));
    } else {
      emit(AuthError(result.error ?? 'Something went wrong'));
    }
  }

  Future<void> _onSignUp(AuthSignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await authRepository.signUp(
      firstName: event.firstName,
      lastName: event.lastName,
      email: event.email,
      passwordConfirmation: event.confirmPassword,
      password: event.password,
    );

    if (result.isSuccess) {
      await authRepository.saveToken(token: result.data!);
      emit(AuthAuthenticated("Welcome ${event.firstName} ${event.lastName}"));
    } else {
      emit(AuthError(result.error ?? 'Something went wrong'));
    }
  }

  void _onLogout(AuthLogoutEvent event, Emitter<AuthState> emit) {
    authRepository.logOut();
    emit(AuthLoggedOut());
  }
}

abstract class AuthEvent {}

class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;

  AuthLoginEvent({required this.email, required this.password});
}

class AuthSignUpEvent extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String confirmPassword;

  AuthSignUpEvent(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.password,
      required this.confirmPassword});
}

class AuthGetUserInfoEvent extends AuthEvent {}

class AuthLogoutEvent extends AuthEvent {}

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String message;
  AuthAuthenticated(this.message);
}

class AuthUserLoaded extends AuthState {
  final User user;
  AuthUserLoaded(this.user);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthLoggedOut extends AuthState {}
