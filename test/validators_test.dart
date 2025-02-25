import 'package:flutter_test/flutter_test.dart';
import 'package:interns_talk_mobile/common/validators.dart';
import 'package:interns_talk_mobile/utils/string.dart';

void main() {
  group('Password Validator', () {
    test('should return error if password is empty', () {
      expect(Validators.passwordValidator(''), kPasswordEmptyErrorText);
    });

    test('should return error if password is less than 8 characters', () {
      expect(Validators.passwordValidator('Pass12'), kPasswordShortErrorText);
    });

    test('should return error if password has no uppercase letter', () {
      expect(Validators.passwordValidator('password123'),
          kPasswordUpperCaseErrorText);
    });

    test('should return error if password has no lowercase letter', () {
      expect(Validators.passwordValidator('PASSWORD123'),
          kPasswordLowerCaseErrorText);
    });

    test('should return error if password has no digit', () {
      expect(Validators.passwordValidator('Password'), kPasswordDigitErrorText);
    });

    test('should return null for valid password', () {
      expect(Validators.passwordValidator('Password123'), null);
    });
  });

  group('Email Validator', () {
    test('should return error if email is empty', () {
      expect(Validators.emailValidator(''), kEmailEmptyErrorText);
    });

    test('should return error if email is invalid', () {
      expect(
          Validators.emailValidator('invalid-email'), kEmailInvalidErrorText);
    });

    test('should return null for valid email', () {
      expect(Validators.emailValidator('test@example.com'), null);
    });
  });
}
