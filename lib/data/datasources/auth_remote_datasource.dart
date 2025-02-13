import 'package:dio/dio.dart';
import 'package:interns_talk_mobile/common/result.dart';
import 'package:interns_talk_mobile/data/model/user_model.dart';

class AuthRemoteDatasource {
  final Dio dio;

  AuthRemoteDatasource(this.dio);

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
        return Result.success(token);
      } else {
        return Result.error("Token not found");
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        return Result.error("Connection error");
      } else {
        return Result.error(e.error.toString());
      }
    } catch (e) {
      return Result.error('Error : $e');
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
      String? token = response.data['data']['token'];
      if (token != null) {
        return Result.success(token);
      } else {
        return Result.error("Token not found");
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        return Result.error("Connection error");
      } else {
        return Result.error(e.error.toString());
      }
    } catch (e) {
      return Result.error('Unexpected error occurred');
    }
  }

  Future<void> logOut() async {
    try {
      await dio.post('/logout');
    } catch (e) {
      print("Logout failed: $e");
    }
  }

  Future<Result<User>> getUserInfo() async {
    try {
      final response = await dio.get('/user');
      if (response.statusCode == 200) {
        return Result.success(User.fromJson(response.data));
      } else {
        return Result.error("Failed to fetch user data");
      }
    } catch (e) {
      return Result.error("Error: $e");
    }
  }
}
