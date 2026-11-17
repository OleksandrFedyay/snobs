import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/data/data_sources/remote.user.data_source.dart';
import 'package:kingfishertom/core/data/local_data/local.app_info.data_source.impl.dart';
import 'package:kingfishertom/core/data/local_data/user_model_stream.dart';
import 'package:kingfishertom/core/domain/exception/app.exception.dart';
import 'package:kingfishertom/core/domain/repositories/auth.repository.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/user_jwt_token_bearer.dart';
import 'package:kingfishertom/core/services/di/injection.dart';
import 'package:kingfishertom/core/services/purchases/purchases_cat.dart';
import 'package:sentry_flutter/sentry_flutter.dart' as sentry;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl extends AuthRepository {
  AuthRepositoryImpl(
    this._localAppInfoDataSource,
    this._remoteUserDataSource,
    this._userJwtTokenBearer,
  );

  final LocalAppInfoDataSource _localAppInfoDataSource;
  final RemoteUserDataSource _remoteUserDataSource;
  final UserJwtTokenBearer _userJwtTokenBearer;
  String _verificationIdValue = '';

  Future<UserModel?> _updateUserInFireStore(User? authUser) async {
    if (authUser == null) throw const AppException.firebaseAuthError();

    try {
      if (!kIsWeb) {
        unawaited(
          FacebookAppEvents().setUserData(
            email: authUser.email,
            firstName: authUser.displayName,
            phone: authUser.phoneNumber,
          ),
        );
        await getIt<PurchasesCat>().logIn(authUser.uid);
      }

      await sentry.Sentry.configureScope((sentry.Scope scope) => scope.setUser(
            sentry.SentryUser(
              id: authUser.uid,
              username: authUser.displayName,
              email: authUser.email,
            ),
          ));

      //Note: getUser() method is used to throw [userNotContainsInDb()] to create a new user db, if the User null
      final UserModel user = await _remoteUserDataSource.getUser();

      final UserModel modelForJwt = UserModel(
        name: user.name,
        lastName: user.lastName,
        id: user.id,
        email: user.email,
        imageUrl: user.imageUrl,
      );

      ///Retrieves jwt token
      ///This method is need to check if the Token is saved in the Local storage, if the storage was cleared
      await _userJwtTokenBearer(modelForJwt);

      return user;
    } on AppExceptionUserNotContainsInDb {
      final List<String> names = authUser.displayName?.split(' ') ?? <String>[];
      final UserModel user = UserModel(
        name: names.firstOrNull,
        lastName: names.length > 1 ? names[1] : null,
        id: authUser.uid,
        email: authUser.email,
        imageUrl: authUser.photoURL,
      );

      if (!kIsWeb) unawaited(FacebookAppEvents().logCompletedRegistration());
      unawaited(
        FirebaseAnalytics.instance.logEvent(name: 'created_account'),
      );

      //Todo(Issa): Check after migration, may need to remove
      await getIt<UserModelStream>().updateSaveUserModel(user);

      ///Retrieves jwt token
      await _userJwtTokenBearer(user);

      return user;
    }
  }

  @override
  Future<void> signInViaEmail({
    required String email,
    required String password,
  }) async {
    await _localAppInfoDataSource.setUsePasswordForLogin(
      usePasswordForLogin: true,
    );

    await makeErrorParsedCall(() async {
      final UserCredential credential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _updateUserInFireStore(credential.user);
    });
  }

  @override
  Future<void> registerViaEmail({
    required String email,
    required String password,
  }) async {
    await _localAppInfoDataSource.setUsePasswordForLogin(
      usePasswordForLogin: true,
    );

    await makeErrorParsedCall(() async {
      final UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _updateUserInFireStore(credential.user);
    });
  }

  @override
  Future<bool> userExist(String email) async {
    try {
      final List<String> list =
          // ignore: deprecated_member_use
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(
        email,
      );

      if (list.isNotEmpty) return true;

      return false;
    } catch (error) {
      return false;
    }
  }

  @override
  Future<void> signInViaApple() async {
    await _localAppInfoDataSource.setUsePasswordForLogin(
      usePasswordForLogin: false,
    );

    await makeErrorParsedCall(() async {
      final String rawNonce = _generateNonce();
      final String nonce = _sha256ofString(rawNonce);
      final AuthorizationCredentialAppleID appleCredential =
          await SignInWithApple.getAppleIDCredential(
        scopes: <AppleIDAuthorizationScopes>[
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final OAuthCredential oAuthCredential =
          OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
        accessToken: appleCredential.authorizationCode,
      );

      final UserCredential credential =
          await FirebaseAuth.instance.signInWithCredential(
        oAuthCredential,
      );

      await _updateUserInFireStore(credential.user);
    });
  }

  @override
  Future<void> signInViaGoogle() async {
    await _localAppInfoDataSource.setUsePasswordForLogin(
      usePasswordForLogin: false,
    );

    await makeErrorParsedCall(() async {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final OAuthCredential oAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final UserCredential credential =
          await FirebaseAuth.instance.signInWithCredential(
        oAuthCredential,
      );
      await _updateUserInFireStore(credential.user);
    });
  }

  @override
  Future<void> forgetPassword(String email) async {
    await makeErrorParsedCall(() async {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    });
  }

  @override
  Future<void> signInViaPhone(String phone) async {
    await _localAppInfoDataSource.setUsePasswordForLogin(
      usePasswordForLogin: false,
    );

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
        await FirebaseAuth.instance.signInWithCredential(
          phoneAuthCredential,
        );
      },
      verificationFailed: (FirebaseAuthException error) => throw error,
      codeSent: (String verificationId, int? forceResendingToken) {
        _verificationIdValue = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationIdValue = verificationId;
      },
    );
  }

  @override
  Future<String?> verifyOTP(String otp) async {
    UserCredential credential;

    try {
      credential = await FirebaseAuth.instance.signInWithCredential(
        PhoneAuthProvider.credential(
          verificationId: _verificationIdValue,
          smsCode: otp,
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
      }

      rethrow;
    }
    final User? authUser = credential.user;

    if (authUser == null) {
      throw const AppException.firebaseAuthError();
    }
    final UserModel? user = await _updateUserInFireStore(authUser);

    return user?.name;
  }

  @override
  Future<void> clear() async {}

  @override
  Future<void> logout() => FirebaseAuth.instance.signOut();

  @override
  Future<void> updateEmail(String email) async {
    await makeErrorParsedCall(() async {
      final User? user = FirebaseAuth.instance.currentUser;

      await user?.verifyBeforeUpdateEmail(email);
    });
  }

  @override
  Future<void> updatePassword(String password, String oldPassword) async {
    await makeErrorParsedCall(() async {
      final User? user = FirebaseAuth.instance.currentUser;

      await user?.reauthenticateWithCredential(
        EmailAuthProvider.credential(
          email: user.email ?? '',
          password: oldPassword,
        ),
      );

      await user?.updatePassword(password);
    });
  }

  @override
  Future<void> updatePhone(String phone) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
        await FirebaseAuth.instance.currentUser
            ?.updatePhoneNumber(phoneAuthCredential);
      },
      verificationFailed: (FirebaseAuthException error) => throw error,
      codeSent: (String verificationId, int? forceResendingToken) {
        _verificationIdValue = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationIdValue = verificationId;
      },
    );
  }

  @override
  Future<String> updatePhotoUrl(File image) async {
    return makeErrorParsedCall(() async {
      final User? user = FirebaseAuth.instance.currentUser;
      final String? id = user?.uid;
      if (id == null) return '';

      final Reference ref = FirebaseStorage.instance.ref().child(id);
      await ref.putFile(image);

      final String photoUrl = await ref.getDownloadURL();
      await user?.updatePhotoURL(photoUrl);
      return photoUrl;
    });
  }

  @override
  Future<void> verifyOTPForNewPhone(String otp) async {
    try {
      await FirebaseAuth.instance.currentUser?.updatePhoneNumber(
        PhoneAuthProvider.credential(
          verificationId: _verificationIdValue,
          smsCode: otp,
        ),
      );
    } on FirebaseAuthException {
      rethrow;
    }
  }

  @override
  Future<void> deleteAccount() async {
    await FirebaseAuth.instance.currentUser?.delete();
  }

  String generateRandomString(int length) {
    final Random random = Random.secure();
    final List<int> values =
        List<int>.generate(length, (int i) => random.nextInt(256));
    return base64Url.encode(values);
  }

  String _generateNonce([int length = 32]) {
    const String charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final Random random = Random.secure();
    return List<String>.generate(
        length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  String _sha256ofString(String input) {
    final Uint8List bytes = utf8.encode(input);
    final Digest digest = sha256.convert(bytes);
    return digest.toString();
  }
}
