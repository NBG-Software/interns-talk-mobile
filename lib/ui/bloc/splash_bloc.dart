import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:interns_talk_mobile/data/repository/auth_repository.dart';

// Events
abstract class SplashEvent {}

class CheckLoginStatus extends SplashEvent {}

// States
abstract class SplashState {}

class SplashInitial extends SplashState {}

class Authenticated extends SplashState {}

class Unauthenticated extends SplashState {}

@lazySingleton
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final AuthRepository authRepository;

  SplashBloc(this.authRepository) : super(SplashInitial()) {
    on<CheckLoginStatus>((event, emit) async {
      bool isLoggedIn = await authRepository.isLoggedIn();
      if (isLoggedIn) {
        emit(Authenticated());
      } else {
        emit(Unauthenticated());
      }
    });
  }
}
