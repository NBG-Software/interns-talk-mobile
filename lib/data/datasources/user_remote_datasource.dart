import 'package:dio/dio.dart';
import 'package:interns_talk_mobile/data/model/mentor_model.dart';

import '../../common/handler.dart';
import '../../common/result.dart';
import '../model/user_model.dart';
import '../service/dio_client.dart';

class UserRemoteDatasource {
  final DioClient dioClient;
  final Dio dio = DioClient().dio;

  UserRemoteDatasource(this.dioClient);

  Future<Result<User>> getUserInfo() async {
    try {
      final response = await dio.get('/user');
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
      final response = await dio.patch('/user', data: {
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
    // return Result.success(User(
    //     firstName:firstName,
    //     lastName: lastName,
    //     email: 'petapaka@gmail.com'
    // ));
  }

  Future<Result<String>> uploadProfilePicture(String imagePath) async {
    try {
      FormData formData = FormData.fromMap({
        'profile_picture': await MultipartFile.fromFile(imagePath),
      });
      final response =
          await dio.post('/user/upload-profile-picture', data: formData);
      if (response.data != null) {
        return Result.success("Profile picture updated successfully");
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
      final response = await dio.get('/mentor');
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
}
