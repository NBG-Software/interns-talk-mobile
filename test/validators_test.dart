import 'package:flutter_test/flutter_test.dart';
import 'package:interns_talk_mobile/common/validators.dart';

void main() {
  group('Password Validator', () {
    test('should return error if password is empty', () {
      expect(Validators.passwordValidator(''), 'Password cannot be empty');
    });

    test('should return error if password is less than 8 characters', () {
      expect(Validators.passwordValidator('Pass12'),
          'Password must be at least 8 characters long');
    });

    test('should return error if password has no uppercase letter', () {
      expect(Validators.passwordValidator('password123'),
          'Password must contain at least one uppercase letter');
    });

    test('should return error if password has no lowercase letter', () {
      expect(Validators.passwordValidator('PASSWORD123'),
          'Password must contain at least one lowercase letter');
    });

    test('should return error if password has no digit', () {
      expect(Validators.passwordValidator('Password'),
          'Password must contain at least one digit');
    });

    test('should return null for valid password', () {
      expect(Validators.passwordValidator('Password123'), null);
    });
  });

  group('Email Validator', () {
    test('should return error if email is empty', () {
      expect(Validators.emailValidator(''), 'Please enter an email address');
    });

    test('should return error if email is invalid', () {
      expect(Validators.emailValidator('invalid-email'),
          'Please enter a valid email address');
    });

    test('should return null for valid email', () {
      expect(Validators.emailValidator('test@example.com'), null);
    });
  });
}
