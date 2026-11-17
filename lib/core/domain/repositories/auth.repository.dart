import 'dart:io';

import 'package:kingfishertom/core/domain/exception/base_exception_service.dart';
import 'package:kingfishertom/core/services/clearable.dart';

abstract class AuthRepository extends BaseExceptionService implements Clearable {
  Future<void> signInViaApple();

  Future<void> signInViaGoogle();

  Future<void> signInViaEmail({
    required String email,
    required String password,
  });

  Future<void> registerViaEmail({
    required String email,
    required String password,
  });

  Future<bool> userExist(String email);

  Future<void> forgetPassword(String email);

  Future<void> signInViaPhone(String phone);

  Future<String?> verifyOTP(String otp);

  Future<void> logout();

  Future<void> updateEmail(String email);

  Future<void> updatePassword(String password, String oldPassword);

  Future<String> updatePhotoUrl(File image);

  Future<void> updatePhone(String phone);

  Future<void> verifyOTPForNewPhone(String otp);

  Future<void> deleteAccount();
}
