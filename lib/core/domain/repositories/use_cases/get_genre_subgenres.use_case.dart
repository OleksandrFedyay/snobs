import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/genre/genre.dart';
import 'package:kingfishertom/core/data/api/models/subgenre/subgenre.dart';
import 'package:kingfishertom/core/data/local_data/local.genres_info.data_source.impl.dart';
import 'package:kingfishertom/core/domain/exception/base_exception_service.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_genres.use_case.dart';

@injectable
class GetGenreSubgenreUseCase extends BaseExceptionService {
  const GetGenreSubgenreUseCase(
    LocalGenresInfoDataSourceImpl localGenresInfoDataSourceImpl,
    GetGenresUseCase getGenresUseCase,
  )   : _localGenresInfoDataSourceImpl = localGenresInfoDataSourceImpl,
        _getGenresUseCase = getGenresUseCase;
  final LocalGenresInfoDataSourceImpl _localGenresInfoDataSourceImpl;
  final GetGenresUseCase _getGenresUseCase;

  Future<List<Subgenre>> call(String genreName, {bool? updateInfo}) async {
    return makeErrorParsedCall(() async {
      if (updateInfo ?? false) {
        ///Fetching a List of Genres objects form api service
        final List<Genre> genresFromKingsFisher = await _getGenresUseCase();

        ///Receive requested Genre
        final Genre requestedGenre =
            genresFromKingsFisher.firstWhere((Genre g) => g.name == genreName);

        ///Receive list of subgenres of the requested genre
        final List<Subgenre> subgenres = requestedGenre.subgenres;

        ///Convert the list of subgenres objects to a list of Strings for recording data into local Sheared Preferences storage
        final List<String> subgenreAsListOfString = subgenres
            .map(
              (Subgenre e) => jsonEncode(
                e.toJson(),
              ),
            )
            .toList();

        ///Passing Subgenre objects as a List of Strings to the Sheared Preferences local storage
        await _localGenresInfoDataSourceImpl.setSubgenresByGenre(
          genreName,
          subgenreAsListOfString,
        );
        return subgenres;
      }

      ///Receiving Subgenres as list of Strings from local storage
      final List<String> subgenresAsListOfStringFromLocalStorage =
          _localGenresInfoDataSourceImpl.getSubgenresByGenre(
        genreName,
      );

      ///Converting data from local storage to a list of Subgenre objects
      final List<Subgenre> subgenres =
          subgenresAsListOfStringFromLocalStorage.map((String s) {
        return Subgenre.fromJson(jsonDecode(s) as Map<String, dynamic>);
      }).toList();

      /// If local storage is empty, the callable GetGenreSubgenreUseCase will refresh itself.
      if (subgenres.isEmpty) {
        subgenres.addAll(await _refresh(genreName));
      }
      return subgenres;
    });
  }

  Future<List<Subgenre>> _refresh(String requestedGenreName) async {
    final List<Subgenre> subgenres =
        await call(requestedGenreName, updateInfo: true);
    debugPrint('REFRESH SUBGENRES');
    return subgenres;
  }
}
