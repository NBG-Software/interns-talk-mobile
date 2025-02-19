import 'dart:io';

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

  Future<Result<String>> changePassword(String currentPassword, String newPassword) async{
    return await remoteDatasource.changePassword(currentPassword,newPassword);
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

  Future<Result<String>> uploadProfilePicture(File profileImage) async {
    return await remoteDatasource.uploadProfilePicture(profileImage);
  }

  Future<Result<List<Mentor>>> getMentorList() async {
    return await remoteDatasource.getMentorList();
  }
}
