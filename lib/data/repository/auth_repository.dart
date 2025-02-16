import 'package:interns_talk_mobile/common/result.dart';
import 'package:interns_talk_mobile/data/datasources/auth_local_datasource.dart';
import 'package:interns_talk_mobile/data/datasources/auth_remote_datasource.dart';
import 'package:interns_talk_mobile/data/model/user_model.dart';

class AuthRepository {
  final AuthLocalDatasource localDS;
  final AuthRemoteDatasource remoteDS;

  AuthRepository({required this.localDS, required this.remoteDS});

  Future<Result<String>> logIn({
    required String email,
    required String password,
  }) async {
    return await remoteDS.logIn(
      email: email,
      password: password,
    );
  }

  Future<void> saveToken({required String token}) async {
    await localDS.saveToken(token: token);
  }

  Future<bool> isLoggedIn() async {
    return await localDS.isLoggedIn();
  }

  Future<Result<String>> sendResetEmail({required String email})async{
    return await remoteDS.sendResetEmail(email: email);
  }

  Future<Result<String>> signUp(
      {required String firstName,
      required String lastName,
      required String email,
      required String password,
      required String passwordConfirmation}) async {
    return await remoteDS.signUp(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }



  Future<void> logOut() async {
    await remoteDS.logOut();
    await localDS.deleteToken();
  }
}
