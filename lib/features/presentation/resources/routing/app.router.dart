import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_collection.dto.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/enums/genres_enum.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/genre_subgenres_page.dart';
import 'package:kingfishertom/features/presentation/resources/legal_docs/privacy_page.dart';
import 'package:kingfishertom/features/presentation/resources/legal_docs/terms_page.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.animations.dart';
import 'package:kingfishertom/features/presentation/screens/auth/code_page/code_page.dart';
import 'package:kingfishertom/features/presentation/screens/auth/email_page/email_page.dart';
import 'package:kingfishertom/features/presentation/screens/auth/login/login_page.dart';
import 'package:kingfishertom/features/presentation/screens/auth/login/options_page.dart';
import 'package:kingfishertom/features/presentation/screens/auth/password_page/password_page.dart';
import 'package:kingfishertom/features/presentation/screens/auth/phone_page/phone_page.dart';
import 'package:kingfishertom/features/presentation/screens/home/home_page.dart';
import 'package:kingfishertom/features/presentation/screens/library_page/view/my_liked_artist/my_liked_artist_page.dart';
import 'package:kingfishertom/features/presentation/screens/onboarding/name/name_page.dart';
import 'package:kingfishertom/features/presentation/screens/onboarding/select_genre/select_genre_page.dart';
import 'package:kingfishertom/features/presentation/screens/profile_page/pages/notifications/notification_page.dart';
import 'package:kingfishertom/features/presentation/screens/profile_page/pages/profile_edit/profile_edit_page.dart';
import 'package:kingfishertom/features/presentation/screens/profile_page/pages/sbob_artists/get_music_page.dart';
import 'package:kingfishertom/features/presentation/screens/profile_page/pages/settings/settings_page.dart';

import 'package:kingfishertom/features/presentation/screens/splash/splash_page.dart';

part 'app.router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppAutoRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => <AutoRoute>[
        CustomRoute<AutoRoute>(
          page: SplashRoute.page,
          initial: true,
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: AppAnimations.defaultDurationInMilliseconds,
        ),
        CustomRoute<AutoRoute>(
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: AppAnimations.defaultDurationInMilliseconds,
          page: CodeRoute.page,
        ),
        CustomRoute<AutoRoute>(
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: AppAnimations.defaultDurationInMilliseconds,
          page: PasswordRoute.page,
        ),
        CustomRoute<AutoRoute>(
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: AppAnimations.defaultDurationInMilliseconds,
          page: EmailRoute.page,
        ),
        CustomRoute<AutoRoute>(
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: AppAnimations.defaultDurationInMilliseconds,
          page: PhoneRoute.page,
        ),
        CustomRoute<AutoRoute>(
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: AppAnimations.defaultDurationInMilliseconds,
          page: HomeRoute.page,
        ),
        CustomRoute<AutoRoute>(
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: AppAnimations.defaultDurationInMilliseconds,
          page: ProfileEditRoute.page,
        ),
        CustomRoute<AutoRoute>(
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: AppAnimations.defaultDurationInMilliseconds,
          page: SettingsRoute.page,
        ),
        CustomRoute<AutoRoute>(
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: AppAnimations.defaultDurationInMilliseconds,
          page: MyLikedArtistRoute.page,
        ),
        CustomRoute<AutoRoute>(
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: AppAnimations.defaultDurationInMilliseconds,
          page: NotificationRoute.page,
        ),
        CustomRoute<AutoRoute>(
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: AppAnimations.defaultDurationInMilliseconds,
          page: LoginRoute.page,
        ),
        CustomRoute<AutoRoute>(
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: AppAnimations.defaultDurationInMilliseconds,
          page: TermsRoute.page,
        ),
        CustomRoute<AutoRoute>(
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: AppAnimations.defaultDurationInMilliseconds,
          page: PrivacyRoute.page,
        ),
        CustomRoute<AutoRoute>(
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: AppAnimations.defaultDurationInMilliseconds,
          page: OptionsRoute.page,
        ),
        CustomRoute<AutoRoute>(
          transitionsBuilder: TransitionsBuilders.slideLeft,
          durationInMilliseconds: AppAnimations.defaultDurationInMilliseconds,
          page: NameRoute.page,
        ),
        CustomRoute<AutoRoute>(
          transitionsBuilder: TransitionsBuilders.slideLeft,
          durationInMilliseconds: AppAnimations.defaultDurationInMilliseconds,
          page: SelectGenreRoute.page,
        ),
        CustomRoute<AutoRoute>(
          transitionsBuilder: TransitionsBuilders.slideLeft,
          durationInMilliseconds: AppAnimations.defaultDurationInMilliseconds,
          page: GenreSubgenresRoute.page,
        ),
        CustomRoute<AutoRoute>(
          transitionsBuilder: TransitionsBuilders.slideLeft,
          durationInMilliseconds: AppAnimations.defaultDurationInMilliseconds,
          page: GetMusicRoute.page,
        ),
      ];
}
