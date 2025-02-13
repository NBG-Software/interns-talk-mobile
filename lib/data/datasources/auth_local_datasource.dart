import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:interns_talk_mobile/utils/string.dart';

class AuthLocalDatasource {
  final FlutterSecureStorage storage;

  AuthLocalDatasource({FlutterSecureStorage? storage})
      : storage = storage ?? const FlutterSecureStorage();

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
