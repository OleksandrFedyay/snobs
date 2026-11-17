import 'package:equatable/equatable.dart';

abstract class AppException extends Equatable implements Exception {
  const AppException();

  const factory AppException.unknown(String details) = AppExceptionUnknown;

  const factory AppException.connectionError(String details) = ConnectionError;

  const factory AppException.serverBadResponse(String details) =
      ServerBadResponse;

  const factory AppException.firebaseAuthError() = AppExceptionFirebaseAuth;

  const factory AppException.platformError() = AppExceptionPlatform;

  const factory AppException.incorrectData() = AppExceptionIncorrectData;

  const factory AppException.notSignedIn() = AppExceptionNotSignedIn;

  const factory AppException.userNotContainsInDb() =
      AppExceptionUserNotContainsInDb;

  const factory AppException.anyError() = AppExceptionAnyError;

  String? get details => null;
}

class AppExceptionUnknown extends AppException {
  const AppExceptionUnknown(this.details);

  @override
  final String details;

  @override
  List<Object?> get props => <Object?>[details];
}

class ConnectionError extends AppException {
  const ConnectionError(this.details);

  @override
  final String details;

  @override
  List<Object?> get props => <Object?>[details];
}

class ServerBadResponse extends AppException {
  const ServerBadResponse(this.details);

  @override
  final String details;

  @override
  List<Object?> get props => <Object?>[details];
}

class AppExceptionIncorrectData extends AppException {
  const AppExceptionIncorrectData();

  @override
  List<Object?> get props => <Object?>[];
}

class AppExceptionNotSignedIn extends AppException {
  const AppExceptionNotSignedIn();

  @override
  List<Object?> get props => <Object?>[];
}

class AppExceptionUserNotContainsInDb extends AppException {
  const AppExceptionUserNotContainsInDb();

  @override
  List<Object?> get props => <Object?>[];
}

class AppExceptionAnyError extends AppException {
  const AppExceptionAnyError();

  @override
  List<Object?> get props => <Object?>[];
}

class AppExceptionFirebaseAuth extends AppException {
  const AppExceptionFirebaseAuth();

  @override
  List<Object?> get props => <Object?>[];
}

class AppExceptionPlatform extends AppException {
  const AppExceptionPlatform();

  @override
  List<Object?> get props => <Object?>[];
}
