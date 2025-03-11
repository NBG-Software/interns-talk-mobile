import 'dart:ui';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:interns_talk_mobile/common/language_constants.dart';

@lazySingleton
class LanguageService {
  final FlutterSecureStorage storage;

  LanguageService(this.storage);

  Future<Locale> setLocale(String languageCode) async {
    await storage.write(key: LANGUAGE_CODE, value: languageCode);
    return _locale(languageCode);
  }

  Future<Locale> getLocale() async {
    final languageCode = await storage.read(key: LANGUAGE_CODE) ?? ENGLISH;
    return _locale(languageCode);
  }

  Locale _locale(String languageCode) {
    switch (languageCode) {
      case ENGLISH:
        return Locale(languageCode, 'US');
      case BURMESE:
        return Locale(languageCode, 'MY');
      default:
        return Locale(languageCode, 'US');
    }
  }
}
