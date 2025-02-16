import 'package:interns_talk_mobile/data/datasources/user_remote_datasource.dart';

import '../../common/result.dart';
import '../model/user_model.dart';

class UserRepository {
  final UserRemoteDatasource remoteDatasource;

  UserRepository(this.remoteDatasource);

  Future<Result<User>> getUserInfo() async {
    return await remoteDatasource.getUserInfo();
  }

  Future<Result<User>> updateUserProfile({
    required String firstName,
    required String lastName,
  }) async {
    return await remoteDatasource.updateUserProfile(
      firstName: firstName,
      lastName: lastName,
    );
  }

  Future<Result<String>> uploadProfilePicture(String imagePath) async {
    return await remoteDatasource.uploadProfilePicture(imagePath);
  }
}
