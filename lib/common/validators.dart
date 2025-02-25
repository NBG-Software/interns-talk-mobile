import 'package:interns_talk_mobile/utils/string.dart';

class Validators {
  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return kPasswordEmptyErrorText;
    }
    if (value.length < 8) {
      return kPasswordShortErrorText;
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return kPasswordUpperCaseErrorText;
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return kPasswordLowerCaseErrorText;
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return kPasswordDigitErrorText;
    }

    return null;
  }

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return kEmailEmptyErrorText;
    }
    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
        .hasMatch(value)) {
      return kEmailInvalidErrorText;
    }
    return null;
  }
}
