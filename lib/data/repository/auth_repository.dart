import 'package:interns_talk_mobile/common/result.dart';
import 'package:interns_talk_mobile/data/datasources/auth_local_datasource.dart';
import 'package:interns_talk_mobile/data/datasources/auth_remote_datasource.dart';

class AuthRepository {
  final localDS = AuthLocalDatasource();
  final remoteDS = AuthRemoteDatasource();

  Future<Result<String>> logIn({
    required String email,
    required String password,
  }) async {
    return await remoteDS.logIn(
      email: email,
      password: password,
    );
  }

  Future<Result<String>> signUp(
      {required String firstName,
      required String lastName,
      required String email,
      required String password,
      required String passwordConfrimation}) async {
    return await remoteDS.signUp(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      passwordConfirmation: passwordConfrimation,
    );
  }

  Future<void> logOut() async {
    await remoteDS.logOut();
    await localDS.storage.delete(key: 'authToken');
  }
}
