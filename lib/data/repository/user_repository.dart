import 'package:injectable/injectable.dart';
import 'package:interns_talk_mobile/data/datasources/user_remote_datasource.dart';
import 'package:interns_talk_mobile/data/model/mentor_model.dart';

import '../../common/result.dart';
import '../model/user_model.dart';

@lazySingleton
class UserRepository {
  final UserRemoteDatasource remoteDatasource;

  UserRepository({required this.remoteDatasource});

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

  Future<Result<List<Mentor>>> getMentorList() async {
    return await remoteDatasource.getMentorList();
  }
}
