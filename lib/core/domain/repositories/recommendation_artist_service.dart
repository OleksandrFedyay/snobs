import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/tag_type.dart';
import 'package:kingfishertom/core/data/api/models/subgenre/subgenre.dart';
import 'package:kingfishertom/core/data/data_sources/remote.artist_chart.data_source.dart';
import 'package:kingfishertom/core/data/local_data/local.app_info.data_source.impl.dart';
import 'package:kingfishertom/core/domain/exception/base_exception_service.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_genre_subgenres.use_case.dart';

int size = 200;

@injectable
class RecommendationArtistService extends BaseExceptionService {
  RecommendationArtistService(
    this._remoteArtistChartDataSource,
    this._getGenreSubgenreUseCase,
    this._localAppInfoDataSource,
  );

  final RemoteArtistChartDataSource _remoteArtistChartDataSource;
  final GetGenreSubgenreUseCase _getGenreSubgenreUseCase;
  final LocalAppInfoDataSource _localAppInfoDataSource;
  DocumentSnapshot<Object?>? last;

  Future<ArtistsListDto> getArtists(
    String subgenre,
    List<String> usedArtist,
  ) async {
    return makeErrorParsedCall(() async {
      if (subgenre.isEmpty) {
        final List<Subgenre> subgenres = await _getGenreSubgenreUseCase(
          _localAppInfoDataSource.getGenre(),
        );
        final List<String> subgenresNamesList =
            subgenres.map((Subgenre s) => s.name).toList();
        final ArtistsWithLastDto artists = await _remoteArtistChartDataSource
            .getRecommendationsArtistChartsForAllSubgenre(subgenresNamesList);
        last = artists.last;
        return _sortAndFilterRecommendations(
          artists.artists,
          usedArtist,
        );
      }
      final ArtistsWithLastDto artists =
          await _remoteArtistChartDataSource.getRecommendationsArtistCharts(
        subgenre,
      );
      last = artists.last;
      return _sortAndFilterRecommendations(
        artists.artists,
        usedArtist,
      );
    });
  }

  Future<ArtistsListDto> getNextArtists(
    String subgenre,
    List<String> usedArtist,
  ) async {
    return makeErrorParsedCall(() async {
      final DocumentSnapshot<Object?>? documentSnapshot = last;
      if (documentSnapshot == null) return const ArtistsListDto();

      if (subgenre.isEmpty) {
        final List<Subgenre> subgenres = await _getGenreSubgenreUseCase(
          _localAppInfoDataSource.getGenre(),
        );
        final List<String> subgenresNamesList =
            subgenres.map((Subgenre s) => s.name).toList();
        final ArtistsWithLastDto artists = await _remoteArtistChartDataSource
            .getRecommendationsNextArtistChartsForAllSubgenre(
          subgenresNamesList,
          documentSnapshot,
        );
        last = artists.last;
        return _sortAndFilterRecommendations(
          artists.artists,
          usedArtist,
        );
      }
      final ArtistsWithLastDto artists =
          await _remoteArtistChartDataSource.getRecommendationsNextArtistCharts(
        subgenre,
        documentSnapshot,
      );
      last = artists.last;
      return _sortAndFilterRecommendations(
        artists.artists,
        usedArtist,
      );
    });
  }

  ArtistsListDto _sortAndFilterRecommendations(
    List<ArtistChartDto> artists,
    List<String> usedArtist,
  ) {
    final List<ArtistChartDto> filteredArtists =
        artists.where((ArtistChartDto artist) {
      return !usedArtist.contains(artist.id);
    }).toList()
          ..sort((ArtistChartDto a, ArtistChartDto b) {
            if (a.likes == b.likes) {
              return b.popularity.compareTo(a.popularity);
            }
            return b.likes.compareTo(a.likes);
          });

    final List<ArtistChartDto> newArtists = <ArtistChartDto>[];
    final List<ArtistChartDto> emergingArtists = <ArtistChartDto>[];
    final List<ArtistChartDto> hotArtists = <ArtistChartDto>[];
    for (final ArtistChartDto a in filteredArtists) {
      final TagType? tag = TagType.getTag(a.likes, a.unlikes);
      switch (tag) {
        case TagType.newArtist:
          newArtists.add(a);
        case TagType.hot:
          hotArtists.add(a);
        case TagType.emerging:
          emergingArtists.add(a);
        case null:
      }
    }

    int i = 10;

    while (i < filteredArtists.length) {
      for (int j = 0; j < i; j++) {
        final ArtistChartDto removedArtist = filteredArtists[j];
        newArtists.remove(removedArtist);
        emergingArtists.remove(removedArtist);
        hotArtists.remove(removedArtist);
      }
      ArtistChartDto? insertedArtists;
      switch (i / 10 % 3) {
        case 1:
          if (emergingArtists.isEmpty) {
            insertedArtists = null;
            break;
          }

          insertedArtists = emergingArtists.first;
          emergingArtists.removeAt(0);

        case 2:
          if (hotArtists.isEmpty) {
            insertedArtists = null;
            break;
          }

          insertedArtists = hotArtists.first;
          hotArtists.removeAt(0);
        case 0:
          if (newArtists.isEmpty) {
            insertedArtists = null;
            break;
          }

          insertedArtists = newArtists.first;
          newArtists.removeAt(0);
      }
      if (insertedArtists == null && newArtists.isEmpty) {
        i += 10;
        continue;
      }
      if (insertedArtists == null) {
        insertedArtists = newArtists.first;
        newArtists.removeAt(0);
      }

      filteredArtists
        ..remove(insertedArtists)
        ..insert(i - 1, insertedArtists);

      i += 10;
    }

    return ArtistsListDto(
      artists: filteredArtists,
      last: size > artists.length,
    );
  }
}

class ArtistsListDto {
  const ArtistsListDto({
    this.artists = const <ArtistChartDto>[],
    this.last = false,
  });

  final bool last;
  final List<ArtistChartDto> artists;
}

class ArtistsWithLastDto {
  const ArtistsWithLastDto({
    this.artists = const <ArtistChartDto>[],
    this.last,
  });

  final DocumentSnapshot<Object?>? last;
  final List<ArtistChartDto> artists;
}
