import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:interns_talk_mobile/data/model/mentor_model.dart';

import '../../common/handler.dart';
import '../../common/result.dart';
import '../model/user_model.dart';
import '../service/dio_client.dart';

@lazySingleton
class UserRemoteDatasource {
  final DioClient dioClient;

  UserRemoteDatasource(this.dioClient);

  Future<Result<User>> getUserInfo() async {
    try {
      final response = await dioClient.dio.get('/user');
      if (response.data != null) {
        final user = response.data['data'];
        final userModel = User.fromJson(user);
        return Result.success(userModel);
      } else {
        return Result.error("Failed to fetch user data");
      }
    } on DioException catch (e) {
      final errorMessage = Handler.handleDioError(e);
      return Result.error(errorMessage);
    } catch (e) {
      return Result.error("Unexpected error occurred");
    }
    // return Result.success(User(
    //   firstName: 'Peter',
    //   lastName: 'Paka',
    //   email: 'petapaka@gmail.com'
    // ));
  }

  Future<Result<User>> updateUserProfile({
    required String firstName,
    required String lastName,
  }) async {
    try {
      final response = await dioClient.dio.patch('/user', data: {
        'first_name': firstName,
        'last_name': lastName,
      });
      if (response.data != null) {
        final user = response.data['data'];
        final userModel = User.fromJson(user);
        return Result.success(userModel);
      } else {
        return Result.error("Failed to update profile");
      }
    } on DioException catch (e) {
      final errorMessage = Handler.handleDioError(e);
      return Result.error(errorMessage);
    } catch (e) {
      return Result.error("Unexpected error occurred");
    }
  }

  Future<Result<String>> uploadProfilePicture(File profileImage) async {
    try {
      FormData formData = FormData.fromMap({
        'profile_picture': await MultipartFile.fromFile(profileImage.path),
      });
      final response =
          await dioClient.dio.post('/user/profile', data: formData);
      if (response.data != null) {
        return Result.success(response.data['message']);
      } else {
        return Result.error("Failed to upload profile picture");
      }
    } on DioException catch (e) {
      final errorMessage = Handler.handleDioError(e);
      return Result.error(errorMessage);
    } catch (e) {
      return Result.error("Unexpected error occurred");
    }
  }

  Future<Result<List<Mentor>>> getMentorList() async {
    try {
      final response = await dioClient.dio.get('/mentor');
      if (response.data != null) {
        return Result.success((response.data['data'] as List)
            .map((json) => Mentor.fromJson(json))
            .toList());
      } else {
        return Result.error('Data not found');
      }
    } on DioException catch (e) {
      final errorMessage = Handler.handleDioError(e);
      return Result.error(errorMessage);
    } catch (e) {
      return Result.error("Unexpected error occurred");
    }
  }

  Future<Result<String>> changePassword(
      String currentPassword, String newPassword) async {
    try {
      final response = await dioClient.dio.post(
        '/password/forgot',
        data: {
          "current_password": currentPassword,
          "new_password": newPassword
        },
      );
      if (response.data != null) {
        return Result.success(response.data['message']);
      } else {
        return Result.error("Fail to change password");
      }
    } on DioException catch (e) {
      final errorMessage = Handler.handleDioError(e);
      return Result.error(errorMessage);
    } catch (e) {
      return Result.error("Unexpected error occurred");
    }
  }
}
