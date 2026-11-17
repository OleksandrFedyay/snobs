import 'package:flutter/cupertino.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_collection.dto.dart';
import 'package:kingfishertom/core/services/di/injection.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/enums/genres_enum.dart';
import 'package:kingfishertom/features/presentation/resources/routing/app.router.dart';
import 'package:kingfishertom/features/presentation/resources/routing/base_route.dart';

SnobsRouter router = getIt<SnobsRouter>();

class SnobsRouter extends BaseRouter {
  SnobsRouter(super.router);

  Future<void> pushEmailRoute() async {
    await push<void>(EmailRoute());
  }

  Future<void> pushAndClearStackLoginRoute() async {
    await push<void>(const LoginRoute());
  }

  Future<void> pushPhoneRoute() async {
    await push<void>(PhoneRoute());
  }

  Future<void> pushAndClearStackSplashRoute() async {
    await pushAndClearStack(const SplashRoute());
  }

  Future<void> pushPasswordRoute(String email) async {
    await push<void>(PasswordRoute(email: email));
  }

  Future<void> pushCodeRoute(String phone) async {
    await push<void>(CodeRoute(phone: phone));
  }

  Future<void> pushAndClearStackHomeRoute() async {
    await pushAndClearStack(const HomeRoute());
  }

  Future<void> pushProfileRoute() async {
    await push<void>(const ProfileEditRoute());
  }

  Future<void> pushNotificationRoute() async {
    await push<void>(const NotificationRoute());
  }

  Future<void> pushSettingsRoute() async {
    await push<void>(const SettingsRoute());
  }

  Future<void> pushMyLikedArtistRoute(ArtistCollectionDto currentCollection, {
    bool delete = true,
    String? userId,
    required Function(String genre, String subgenre) exploreSubgenre,
  }) async {
    await push<void>(
      MyLikedArtistRoute(
          currentCollection: currentCollection,
          delete: delete,
          userId: userId,
          exploreSubgenre: exploreSubgenre,
      ),
    );
  }

  Future<void> pushTermsRoute() async {
    await push<void>(const TermsRoute());
  }

  Future<void> pushPrivacyRoute() async {
    await push<void>(const PrivacyRoute());
  }

  Future<void> pushOptionsRoute() async {
    await push<void>(const OptionsRoute());
  }

  Future<void> pushAndClearStackNameRoute() async {
    await pushAndClearStack(const NameRoute());
  }

  Future<void> pushSelectGenreRoute(String? name) async {
    await push<void>(SelectGenreRoute(name: name));
  }

  Future<void> pushGetMusicRoute() async {
    await push<void>(const GetMusicRoute());
  }

  Future<void> pushAndClearStackSelectGenreRoute(String? name) async {
    await pushAndClearStack(SelectGenreRoute(name: name));
  }

  Future<void> pushGenreSubgenresRouteRoute(String genre,
      String subgenre,
      Function(String genre, String subgenre) exploreSubgenre,
      GenrePageType genrePageType,) async {
    await push<void>(
      GenreSubgenresRoute(
        genre: genre,
        subgenre: subgenre,
        exploreSubgenre: exploreSubgenre,
        genrePageType: genrePageType,
      ),
    );
  }
}
