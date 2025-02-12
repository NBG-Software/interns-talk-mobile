import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:interns_talk_mobile/common/result.dart';
import 'package:interns_talk_mobile/data/datasources/api_constants.dart';
import 'package:interns_talk_mobile/utils/string.dart';

class AuthRemoteDatasource {
  final Dio dio;

  AuthRemoteDatasource()
      : dio = Dio(
      BaseOptions(
          baseUrl: kBaseUrl,
          connectTimeout: Duration(seconds: 60),
          receiveTimeout: Duration(seconds: 60),
        )) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final storage = FlutterSecureStorage();
          String? token = await storage.read(key: kAuthTokenKey);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          return handler.next(e);
        },
      ),
    );
  }

  Future<Result<String>> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      String? token = response.data['data']['token'];
      if (token != null) {
        return Result.success(response.data['message']);
      } else {
        return Result.error("Token not found");
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        return Result.error("Connection error");
      } else {
        return Result.error('Something went wrong');
      }
    } catch (e) {
      return Result.error('Unexpected error occurred');
    }
  }

  Future<Result<String>> signUp(
      {required String firstName,
      required String lastName,
      required String email,
      required String password,
      required String passwordConfirmation}) async {
    try {
      final response = await dio.post('/register', data: {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation
      });
      return response.data['message'];
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        return Result.error("Connection error");
      } else {
        return Result.error('Something went wrong');
      }
    } catch (e) {
      return Result.error('Unexpected error occurred');
    }
  }

  Future<void> logOut() async {}
}
