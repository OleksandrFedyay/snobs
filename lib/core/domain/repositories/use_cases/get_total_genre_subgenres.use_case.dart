import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/dtos/subgenre_liked.dart';
import 'package:kingfishertom/core/data/api/models/subgenre/subgenre.dart';
import 'package:kingfishertom/core/domain/exception/base_exception_service.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_genre_subgenres.use_case.dart';

@injectable
class GetTotalGenreSubgenreUseCase extends BaseExceptionService {
  GetTotalGenreSubgenreUseCase(
    this.getGenreSubgenreUseCase,
  );

  final GetGenreSubgenreUseCase getGenreSubgenreUseCase;

  Future<List<GenreSubgenresTotal>> call(
    List<String> genres,
    List<SubgenreLiked> subgenres,
  ) async {
    return makeErrorParsedCall(() async {
      final List<GenreSubgenresTotal> list = <GenreSubgenresTotal>[];
      for (final String genre in genres) {
        final List<Subgenre> s = await getGenreSubgenreUseCase(genre);

        final List<SubgenreLiked> sortSubgenres = s.map((Subgenre e) {
          return subgenres.where((SubgenreLiked sub) {
                return sub.subGenre == e.name;
              }).firstOrNull ??
              SubgenreLiked(subGenre: e.name);
        }).toList()
          ..sort(
              (SubgenreLiked a, SubgenreLiked b) => a.subGenre.compareTo(b.subGenre));

        final SubgenreLiked? allGenre = subgenres
            .firstWhereOrNull((SubgenreLiked s) => s.subGenre == '&$genre');
        list.add(
          GenreSubgenresTotal(
            genre: genre,
            totalSubgenres: <SubgenreLiked>[
              ...sortSubgenres,
              if (allGenre != null) allGenre
            ],
          ),
        );
      }
      return list;
    });
  }
}

class GenreSubgenresTotal {
  const GenreSubgenresTotal({
    required this.genre,
    required this.totalSubgenres,
  });

  final String genre;
  final List<SubgenreLiked> totalSubgenres;

  int get swipesCount => totalSubgenres.fold<int>(
        0,
        (int previousValue, SubgenreLiked sub) =>
            previousValue + sub.likes + sub.unlikes,
      );

  int get likesCount => totalSubgenres.fold<int>(
        0,
        (int previousValue, SubgenreLiked sub) => previousValue + sub.likes,
      );

  bool roundSwipes() {
    final int levels = level;
    final int swipes = levels * (levels - 1) * 10;
    return swipesCount == swipes;
  }

  int get level {
    if (swipesCount >= 3800) return 20;
    if (swipesCount >= 3420) return 19;
    if (swipesCount >= 3060) return 18;
    if (swipesCount >= 2720) return 17;
    if (swipesCount >= 2400) return 16;
    if (swipesCount >= 2100) return 15;
    if (swipesCount >= 1820) return 14;
    if (swipesCount >= 1560) return 13;
    if (swipesCount >= 1320) return 12;
    if (swipesCount >= 1100) return 11;
    if (swipesCount >= 900) return 10;
    if (swipesCount >= 720) return 9;
    if (swipesCount >= 560) return 8;
    if (swipesCount >= 420) return 7;
    if (swipesCount >= 300) return 6;
    if (swipesCount >= 200) return 5;
    if (swipesCount >= 120) return 4;
    if (swipesCount >= 60) return 3;
    if (swipesCount >= 20) return 2;
    return 1;
  }

  List<SubgenreLiked> get subgenres {
    return totalSubgenres
        .where((SubgenreLiked s) => !s.subGenre.contains('&'))
        .toList();
  }

  GenreSubgenresTotal copyWith({
    String? genre,
    List<SubgenreLiked>? totalSubgenres,
  }) {
    return GenreSubgenresTotal(
      genre: genre ?? this.genre,
      totalSubgenres: totalSubgenres ?? this.totalSubgenres,
    );
  }
}
