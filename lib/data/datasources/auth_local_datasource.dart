import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:interns_talk_mobile/utils/string.dart';

@lazySingleton
class AuthLocalDatasource {
  final FlutterSecureStorage storage;

  AuthLocalDatasource(this.storage);

  Future<void> saveToken({required String token}) async {
    await storage.write(key: kAuthTokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await storage.read(key: kAuthTokenKey);
  }

  Future<void> deleteToken() async {
    await storage.delete(key: kAuthTokenKey);
  }

  Future<bool> isLoggedIn() async {
    String? token = await getToken();
    return token != null;
  }
}
