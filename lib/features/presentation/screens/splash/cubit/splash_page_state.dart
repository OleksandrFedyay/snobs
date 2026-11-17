part of 'splash_page_cubit.dart';

abstract class SplashPageState extends Equatable {
  const SplashPageState();

  const factory SplashPageState.loading() = SplashPageStateLoading;

  const factory SplashPageState.goToApp() = SplashPageStateGoToApp;

  const factory SplashPageState.notSignedIn() = SplashPageStateNotSignedIn;

  const factory SplashPageState.selectGenre() = SplashPageSelectGenre;
}

class SplashPageStateLoading extends SplashPageState {
  const SplashPageStateLoading();

  @override
  List<Object?> get props => <Object?>[];
}

class SplashPageStateNoFoundSubscription extends SplashPageState {
  const SplashPageStateNoFoundSubscription();

  @override
  List<Object?> get props => <Object?>[];
}

class SplashPageStateNotSignedIn extends SplashPageState {
  const SplashPageStateNotSignedIn();

  @override
  List<Object?> get props => <Object?>[];
}

class SplashPageStateGoToApp extends SplashPageState {
  const SplashPageStateGoToApp();

  @override
  List<Object?> get props => <Object?>[];
}

class SplashPageStateInitError extends SplashPageState {
  const SplashPageStateInitError();

  @override
  List<Object?> get props => <Object?>[];
}

class SplashPageStateConnectionError extends SplashPageState {
  const SplashPageStateConnectionError();

  @override
  List<Object?> get props => <Object?>[];
}

class SplashPageSelectGenre extends SplashPageState {
  const SplashPageSelectGenre();

  @override
  List<Object?> get props => <Object?>[];
}
