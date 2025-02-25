import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:interns_talk_mobile/data/repository/auth_repository.dart';
import 'package:interns_talk_mobile/data/repository/user_repository.dart';

@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final UserRepository userRepository;

  AuthBloc(this.authRepository, this.userRepository) : super(AuthInitial()) {
    on<AuthLoginEvent>(_onLogin);
    on<AuthSignUpEvent>(_onSignUp);
    on<AuthLogoutEvent>(_onLogout);
    on<AuthForgotPasswordEvent>(_onForgotPassword);
  }

  Future<void> _onForgotPassword(
      AuthForgotPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await authRepository.sendResetEmail(email: event.email);

    if (result.isSuccess) {
      emit(AuthAuthenticated(result.data!));
    } else {
      emit(AuthError(result.error ?? "Failed send email"));
    }
  }

  Future<void> _onLogin(AuthLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await authRepository.logIn(
        email: event.email, password: event.password);
    if (result.isSuccess) {
      await authRepository.saveToken(token: result.data!);
      final userInfoResult = await userRepository.getUserInfo();
      if (userInfoResult.isSuccess) {
        final userInfo = userInfoResult.data!;
        await authRepository.saveUserInfo(userInfo.id,
            userInfo.firstName ?? 'Unknown', userInfo.lastName ?? 'User');
        emit(AuthAuthenticated(
            "Welcome ${userInfo.firstName} ${userInfo.lastName}"));
      } else {
        emit(AuthError(userInfoResult.error ?? 'Fail to fetch user info'));
      }
    } else {
      emit(AuthError(result.error ?? 'Login failed'));
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

  Future<void> _onLogout(AuthLogoutEvent event, Emitter<AuthState> emit) async {
    await authRepository.logOut();
    emit(AuthLoggedOut());
  }
}

abstract class AuthEvent {}

class AuthForgotPasswordEvent extends AuthEvent {
  final String email;

  AuthForgotPasswordEvent({required this.email});
}

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

class AuthLogoutEvent extends AuthEvent {}

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String message;

  AuthAuthenticated(this.message);
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

class AuthLoggedOut extends AuthState {}
