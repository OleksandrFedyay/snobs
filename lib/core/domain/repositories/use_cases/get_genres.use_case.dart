import 'dart:async';
import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/kingfishertom_api/kingfishertom_api_service.dart';
import 'package:kingfishertom/core/data/api/models/genre/genre.dart';
import 'package:kingfishertom/core/data/local_data/local.genres_info.data_source.impl.dart';
import 'package:kingfishertom/core/domain/exception/base_exception_service.dart';

///Received all available genres from local storage or from the remote DB
@injectable
class GetGenresUseCase extends BaseExceptionService {
  GetGenresUseCase(
    LocalGenresInfoDataSourceImpl localGenresInfoDataSourceImpl,
    KingfishertomApiService kingfishertomApiService,
  )   : _kingfishertomApiService = kingfishertomApiService,
        _localGenresInfoDataSourceImpl = localGenresInfoDataSourceImpl;

  final LocalGenresInfoDataSourceImpl _localGenresInfoDataSourceImpl;
  final KingfishertomApiService _kingfishertomApiService;

  ///Returns a List of Genres objects or the Future
  FutureOr<List<Genre>> call({bool? updateInfo}) {
    late final List<Genre> genres;
    if (updateInfo ?? true) {
      ///Fetching Genres objects as a List of Strings from local storage
      final List<String> genresFromListOfString =
          _localGenresInfoDataSourceImpl.getGenres();

      ///Converting data from local storage to a List of Genres Objects
      genres = genresFromListOfString.map((String e) {
        // ignore: always_specify_types
        final decode = jsonDecode(e);
        return Genre.fromJson(decode as Map<String, dynamic>);
      }).toList();
    }

    ///If genres is empty, data will be fetched from remote [KingfishertomApiService],
    ///returned and cached into the local [LocalGenresInfoDataSourceImpl] storage.
    if (genres.isEmpty || (updateInfo ?? false)) {
      return _fetchGenreFromKingfisherService();
    } else {
      return genres;
    }
  }

  Future<List<Genre>> _fetchGenreFromKingfisherService() async {
    return makeErrorParsedCall(() async {
      /// Fetching a List of Genres objects form api service
      final List<Genre> genresFromKingsFisher =
          await _kingfishertomApiService.getGenres();

      ///Converting the List of Genres objects to a List of Strings
      ///which will be passed to the [LocalGenresInfoDataSourceImpl] local storage
      final List<String> genresAsListOfString = genresFromKingsFisher
          .map(
            (Genre e) => jsonEncode(
              e.toJson(),
            ),
          )
          .toList();

      ///Passing Genres objects as a List of Strings
      ///to the [LocalGenresInfoDataSourceImpl] local storage
      await _localGenresInfoDataSourceImpl.setGenre(genresAsListOfString);

      ///Returns List of Genres objects
      return genresFromKingsFisher;
    });
  }
}
