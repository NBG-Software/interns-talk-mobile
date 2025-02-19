import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:interns_talk_mobile/data/datasources/api_constants.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Dio provideDio() => Dio(BaseOptions(
        baseUrl: kBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {'Accept': 'application/json'},
      ));

  @lazySingleton
  FlutterSecureStorage provideSecureStorage() => const FlutterSecureStorage();
}
