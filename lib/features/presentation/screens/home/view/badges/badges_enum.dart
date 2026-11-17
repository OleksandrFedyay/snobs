import 'package:kingfishertom/core/data/api/models/dtos/subgenre_liked.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_total_genre_subgenres.use_case.dart';

enum BadgesType {
  none,
  golden,
  silver,
  bronze;

  static BadgesType fromJson(String genre) => BadgesType.values.byName(genre);

  static String toJson(BadgesType type) => type.name;

  int getNumber() => switch (this) {
        BadgesType.none => 0,
        BadgesType.bronze => 20,
        BadgesType.silver => 50,
        BadgesType.golden => 100,
      };

  static String getGenreFromSubgenre(
    List<GenreSubgenresTotal> genres,
    String subgenre,
  ) {
    for (final GenreSubgenresTotal g in genres) {
      for (final SubgenreLiked sub in g.subgenres) {
        if (sub.subGenre.toLowerCase() == subgenre.toLowerCase()) return g.genre;
      }
    }
    return genres.firstOrNull?.genre ?? '';
  }
}
