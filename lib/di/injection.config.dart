// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:interns_talk_mobile/data/datasources/auth_local_datasource.dart'
    as _i739;
import 'package:interns_talk_mobile/data/datasources/auth_remote_datasource.dart'
    as _i610;
import 'package:interns_talk_mobile/data/datasources/chat_remote_datasource.dart'
    as _i972;
import 'package:interns_talk_mobile/data/datasources/user_remote_datasource.dart'
    as _i542;
import 'package:interns_talk_mobile/data/repository/auth_repository.dart'
    as _i69;
import 'package:interns_talk_mobile/data/repository/chat_repository.dart'
    as _i835;
import 'package:interns_talk_mobile/data/repository/user_repository.dart'
    as _i58;
import 'package:interns_talk_mobile/data/service/dio_client.dart' as _i158;
import 'package:interns_talk_mobile/data/service/socket_service.dart' as _i28;
import 'package:interns_talk_mobile/di/register_module.dart' as _i704;
import 'package:interns_talk_mobile/ui/bloc/auth_bloc.dart' as _i607;
import 'package:interns_talk_mobile/ui/bloc/chat_room_bloc.dart' as _i996;
import 'package:interns_talk_mobile/ui/bloc/conversation_bloc.dart' as _i994;
import 'package:interns_talk_mobile/ui/bloc/profile_bloc.dart' as _i178;
import 'package:interns_talk_mobile/ui/bloc/splash_bloc.dart' as _i724;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i361.Dio>(() => registerModule.provideDio());
    gh.lazySingleton<_i558.FlutterSecureStorage>(
        () => registerModule.provideSecureStorage());
    gh.lazySingleton<_i739.AuthLocalDatasource>(
        () => _i739.AuthLocalDatasource(gh<_i558.FlutterSecureStorage>()));
    gh.singleton<_i28.SocketService>(
        () => _i28.SocketService(gh<_i739.AuthLocalDatasource>()));
    gh.factory<_i158.DioClient>(() => _i158.DioClient(
          gh<_i361.Dio>(),
          gh<_i558.FlutterSecureStorage>(),
        ));
    gh.lazySingleton<_i972.ChatRemoteDatasource>(
        () => _i972.ChatRemoteDatasource(gh<_i158.DioClient>()));
    gh.lazySingleton<_i610.AuthRemoteDatasource>(
        () => _i610.AuthRemoteDatasource(gh<_i158.DioClient>()));
    gh.lazySingleton<_i542.UserRemoteDatasource>(
        () => _i542.UserRemoteDatasource(gh<_i158.DioClient>()));
    gh.lazySingleton<_i69.AuthRepository>(() => _i69.AuthRepository(
          localDS: gh<_i739.AuthLocalDatasource>(),
          remoteDS: gh<_i610.AuthRemoteDatasource>(),
        ));
    gh.lazySingleton<_i835.ChatRepository>(() => _i835.ChatRepository(
        chatRemoteDatasource: gh<_i972.ChatRemoteDatasource>()));
    gh.lazySingleton<_i58.UserRepository>(() => _i58.UserRepository(
        remoteDatasource: gh<_i542.UserRemoteDatasource>()));
    gh.lazySingleton<_i724.SplashBloc>(
        () => _i724.SplashBloc(gh<_i69.AuthRepository>()));
    gh.lazySingleton<_i607.AuthBloc>(
        () => _i607.AuthBloc(gh<_i69.AuthRepository>()));
    gh.lazySingleton<_i994.ConversationBloc>(() => _i994.ConversationBloc(
          chatRepository: gh<_i835.ChatRepository>(),
          socketService: gh<_i28.SocketService>(),
        ));
    gh.lazySingleton<_i996.ChatRoomBloc>(() => _i996.ChatRoomBloc(
          chatRepository: gh<_i835.ChatRepository>(),
          userRepository: gh<_i58.UserRepository>(),
        ));
    gh.lazySingleton<_i178.ProfileBloc>(
        () => _i178.ProfileBloc(gh<_i58.UserRepository>()));
    return this;
  }
}

class _$RegisterModule extends _i704.RegisterModule {}
