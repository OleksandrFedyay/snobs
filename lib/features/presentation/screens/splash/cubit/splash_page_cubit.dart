import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/data_sources/remote.version.data_source.dart';
import 'package:kingfishertom/core/data/local_data/local.app_info.data_source.impl.dart';
import 'package:kingfishertom/core/data/local_data/local.genres_info.data_source.impl.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_genre_subgenres.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_genres.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_subgenre.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/set_fcm_token.dart';
import 'package:kingfishertom/core/services/base/base_cubit.dart';
import 'package:kingfishertom/core/services/di/injection.dart';
import 'package:kingfishertom/core/services/purchases/purchases_cat.dart';
import 'package:kingfishertom/core/services/snackbar/snack_bar_service.dart';
import 'package:kingfishertom/features/utils/snackbar_views.dart';
import 'package:sentry_flutter/sentry_flutter.dart' as sentry;

part 'splash_page_state.dart';

@injectable
class SplashPageCubit extends BaseCubit<SplashPageState> {
  SplashPageCubit(
    this.getGenresUseCase,
    this.getSubgenreUseCase,
    this.getGenreSubgenreUseCase,
    this._firebaseAuth,
    this.localGenresInfoDataSourceImpl,
    this.remoteVersionDataSource,
    this.localAppInfoDataSource,
    this.setFcmTokenUseCase,
    //  this._userJwtTokenBearer,
  ) : super(const SplashPageState.loading());

  static SplashPageCubit create() {
    return GetIt.I<SplashPageCubit>();
  }

  final GetGenresUseCase getGenresUseCase;
  final GetSubgenreUseCase getSubgenreUseCase;
  final GetGenreSubgenreUseCase getGenreSubgenreUseCase;
  final FirebaseAuth _firebaseAuth;
  final LocalGenresInfoDataSourceImpl localGenresInfoDataSourceImpl;
  final RemoteVersionDataSource remoteVersionDataSource;
  final LocalAppInfoDataSource localAppInfoDataSource;
  final SetFcmTokenUseCase setFcmTokenUseCase;

  // final UserJwtTokenBearer _userJwtTokenBearer;

  Future<void> init() async {
    unawaited(FirebaseAnalytics.instance.logAppOpen());
    await performSafeAction(() async {
      await Connectivity()
          .checkConnectivity()
          .then((List<ConnectivityResult> results) async {
        if (results.contains(ConnectivityResult.none)) {
          getIt<SnackBarService>()
              .showMessage(infoSnackBar('No or bad internet connection.'));
        } else {
          /// This method is needed for pinging to check the actual internet access, e.g. Connected to Wi-Fi but does not have internet access from provider.
          await InternetAddress.lookup('kingfishertom-e7576.uc.r.appspot.com');
          await prepareAndNavigateToPage();
        }
      });
    });
  }

  Future<void> prepareAndNavigateToPage() async {
    await Future<void>.delayed(
      const Duration(milliseconds: 100),
      () async {
        try {
          final String? userId = _firebaseAuth.currentUser?.uid;

          if (userId != null) {
            await sentry.Sentry.configureScope(
              (sentry.Scope scope) {
                return scope.setUser(
                  sentry.SentryUser(
                    id: userId,
                    username: _firebaseAuth.currentUser?.displayName,
                    email: _firebaseAuth.currentUser?.email,
                  ),
                );
              },
            );

            //Todo(Issa): Need to check if JWT token is available from our server, the api for token needs a User model
            await setFcmTokenUseCase(
              await FirebaseMessaging.instance.getToken() ?? '',
            );

            if (!kIsWeb) await getIt<PurchasesCat>().logIn(userId);

            //Todo(Issa): Need to check if JWT token is available from our server

            //Todo(Issa): Check this method for New Users to fix the issue
            final String genre = localAppInfoDataSource.getGenre();
            if (genre.isEmpty) {
              final int remoteVersion =
                  await remoteVersionDataSource.getVersion();
              await localGenresInfoDataSourceImpl.setVersion(remoteVersion);
              //Todo(Issa): Need to check the logic for [getSubgenreUseCase, GetSubgenreUseCase, GetGenreSubgenreUseCase]

              //These needs to get genres for Genre/Home page for the first run
              await getGenresUseCase(updateInfo: true);
              await getSubgenreUseCase(updateInfo: true);

              emit(const SplashPageState.selectGenre());
            } else {
              emit(const SplashPageState.goToApp());
            }
          } else {
            emit(const SplashPageState.notSignedIn());
          }
        } catch (e) {
          emit(const SplashPageState.notSignedIn());
        }
      },
    );
  }

  @override
  void handleError(String errorMessage) {
    emit(const SplashPageState.notSignedIn());
  }
}
