import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:interns_talk_mobile/utils/string.dart';

class AuthLocalDatasource {
  final storage = FlutterSecureStorage();

  Future<void> saveToken({required String token}) async {
    await storage.write(key: kAuthTokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await storage.read(key: kAuthTokenKey);
  }
}
