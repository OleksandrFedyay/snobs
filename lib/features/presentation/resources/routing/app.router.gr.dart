// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app.router.dart';

/// generated route for
/// [CodePage]
class CodeRoute extends PageRouteInfo<CodeRouteArgs> {
  CodeRoute({
    required String phone,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          CodeRoute.name,
          args: CodeRouteArgs(
            phone: phone,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'CodeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CodeRouteArgs>();
      return WrappedRoute(
          child: CodePage(
        phone: args.phone,
        key: args.key,
      ));
    },
  );
}

class CodeRouteArgs {
  const CodeRouteArgs({
    required this.phone,
    this.key,
  });

  final String phone;

  final Key? key;

  @override
  String toString() {
    return 'CodeRouteArgs{phone: $phone, key: $key}';
  }
}

/// generated route for
/// [EmailPage]
class EmailRoute extends PageRouteInfo<EmailRouteArgs> {
  EmailRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          EmailRoute.name,
          args: EmailRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'EmailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<EmailRouteArgs>(orElse: () => const EmailRouteArgs());
      return WrappedRoute(child: EmailPage(key: args.key));
    },
  );
}

class EmailRouteArgs {
  const EmailRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'EmailRouteArgs{key: $key}';
  }
}

/// generated route for
/// [GenreSubgenresPage]
class GenreSubgenresRoute extends PageRouteInfo<GenreSubgenresRouteArgs> {
  GenreSubgenresRoute({
    required String genre,
    required String subgenre,
    required dynamic Function(
      String,
      String,
    ) exploreSubgenre,
    required GenrePageType genrePageType,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          GenreSubgenresRoute.name,
          args: GenreSubgenresRouteArgs(
            genre: genre,
            subgenre: subgenre,
            exploreSubgenre: exploreSubgenre,
            genrePageType: genrePageType,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'GenreSubgenresRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<GenreSubgenresRouteArgs>();
      return WrappedRoute(
          child: GenreSubgenresPage(
        args.genre,
        args.subgenre,
        args.exploreSubgenre,
        genrePageType: args.genrePageType,
        key: args.key,
      ));
    },
  );
}

class GenreSubgenresRouteArgs {
  const GenreSubgenresRouteArgs({
    required this.genre,
    required this.subgenre,
    required this.exploreSubgenre,
    required this.genrePageType,
    this.key,
  });

  final String genre;

  final String subgenre;

  final dynamic Function(
    String,
    String,
  ) exploreSubgenre;

  final GenrePageType genrePageType;

  final Key? key;

  @override
  String toString() {
    return 'GenreSubgenresRouteArgs{genre: $genre, subgenre: $subgenre, exploreSubgenre: $exploreSubgenre, genrePageType: $genrePageType, key: $key}';
  }
}

/// generated route for
/// [GetMusicPage]
class GetMusicRoute extends PageRouteInfo<void> {
  const GetMusicRoute({List<PageRouteInfo>? children})
      : super(
          GetMusicRoute.name,
          initialChildren: children,
        );

  static const String name = 'GetMusicRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const GetMusicPage();
    },
  );
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const HomePage());
    },
  );
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const LoginPage());
    },
  );
}

/// generated route for
/// [MyLikedArtistPage]
class MyLikedArtistRoute extends PageRouteInfo<MyLikedArtistRouteArgs> {
  MyLikedArtistRoute({
    required ArtistCollectionDto currentCollection,
    required bool delete,
    required dynamic Function(
      String,
      String,
    ) exploreSubgenre,
    Key? key,
    String? userId,
    List<PageRouteInfo>? children,
  }) : super(
          MyLikedArtistRoute.name,
          args: MyLikedArtistRouteArgs(
            currentCollection: currentCollection,
            delete: delete,
            exploreSubgenre: exploreSubgenre,
            key: key,
            userId: userId,
          ),
          initialChildren: children,
        );

  static const String name = 'MyLikedArtistRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MyLikedArtistRouteArgs>();
      return WrappedRoute(
          child: MyLikedArtistPage(
        args.currentCollection,
        delete: args.delete,
        exploreSubgenre: args.exploreSubgenre,
        key: args.key,
        userId: args.userId,
      ));
    },
  );
}

class MyLikedArtistRouteArgs {
  const MyLikedArtistRouteArgs({
    required this.currentCollection,
    required this.delete,
    required this.exploreSubgenre,
    this.key,
    this.userId,
  });

  final ArtistCollectionDto currentCollection;

  final bool delete;

  final dynamic Function(
    String,
    String,
  ) exploreSubgenre;

  final Key? key;

  final String? userId;

  @override
  String toString() {
    return 'MyLikedArtistRouteArgs{currentCollection: $currentCollection, delete: $delete, exploreSubgenre: $exploreSubgenre, key: $key, userId: $userId}';
  }
}

/// generated route for
/// [NamePage]
class NameRoute extends PageRouteInfo<void> {
  const NameRoute({List<PageRouteInfo>? children})
      : super(
          NameRoute.name,
          initialChildren: children,
        );

  static const String name = 'NameRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const NamePage());
    },
  );
}

/// generated route for
/// [NotificationPage]
class NotificationRoute extends PageRouteInfo<void> {
  const NotificationRoute({List<PageRouteInfo>? children})
      : super(
          NotificationRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const NotificationPage());
    },
  );
}

/// generated route for
/// [OptionsPage]
class OptionsRoute extends PageRouteInfo<void> {
  const OptionsRoute({List<PageRouteInfo>? children})
      : super(
          OptionsRoute.name,
          initialChildren: children,
        );

  static const String name = 'OptionsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const OptionsPage());
    },
  );
}

/// generated route for
/// [PasswordPage]
class PasswordRoute extends PageRouteInfo<PasswordRouteArgs> {
  PasswordRoute({
    required String email,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          PasswordRoute.name,
          args: PasswordRouteArgs(
            email: email,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'PasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PasswordRouteArgs>();
      return WrappedRoute(
          child: PasswordPage(
        email: args.email,
        key: args.key,
      ));
    },
  );
}

class PasswordRouteArgs {
  const PasswordRouteArgs({
    required this.email,
    this.key,
  });

  final String email;

  final Key? key;

  @override
  String toString() {
    return 'PasswordRouteArgs{email: $email, key: $key}';
  }
}

/// generated route for
/// [PhonePage]
class PhoneRoute extends PageRouteInfo<PhoneRouteArgs> {
  PhoneRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          PhoneRoute.name,
          args: PhoneRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'PhoneRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<PhoneRouteArgs>(orElse: () => const PhoneRouteArgs());
      return WrappedRoute(child: PhonePage(key: args.key));
    },
  );
}

class PhoneRouteArgs {
  const PhoneRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'PhoneRouteArgs{key: $key}';
  }
}

/// generated route for
/// [PrivacyPage]
class PrivacyRoute extends PageRouteInfo<void> {
  const PrivacyRoute({List<PageRouteInfo>? children})
      : super(
          PrivacyRoute.name,
          initialChildren: children,
        );

  static const String name = 'PrivacyRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PrivacyPage();
    },
  );
}

/// generated route for
/// [ProfileEditPage]
class ProfileEditRoute extends PageRouteInfo<void> {
  const ProfileEditRoute({List<PageRouteInfo>? children})
      : super(
          ProfileEditRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileEditRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const ProfileEditPage());
    },
  );
}

/// generated route for
/// [SelectGenrePage]
class SelectGenreRoute extends PageRouteInfo<SelectGenreRouteArgs> {
  SelectGenreRoute({
    required String? name,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          SelectGenreRoute.name,
          args: SelectGenreRouteArgs(
            name: name,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'SelectGenreRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SelectGenreRouteArgs>();
      return WrappedRoute(
          child: SelectGenrePage(
        name: args.name,
        key: args.key,
      ));
    },
  );
}

class SelectGenreRouteArgs {
  const SelectGenreRouteArgs({
    required this.name,
    this.key,
  });

  final String? name;

  final Key? key;

  @override
  String toString() {
    return 'SelectGenreRouteArgs{name: $name, key: $key}';
  }
}

/// generated route for
/// [SettingsPage]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const SettingsPage());
    },
  );
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const SplashPage());
    },
  );
}

/// generated route for
/// [TermsPage]
class TermsRoute extends PageRouteInfo<void> {
  const TermsRoute({List<PageRouteInfo>? children})
      : super(
          TermsRoute.name,
          initialChildren: children,
        );

  static const String name = 'TermsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TermsPage();
    },
  );
}
