import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/subgenre/subgenre.dart';
import 'package:kingfishertom/core/data/data_sources/remote.artist_chart.data_source.dart';
import 'package:kingfishertom/core/data/local_data/local.app_info.data_source.impl.dart';
import 'package:kingfishertom/core/domain/exception/base_exception_service.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_genre_subgenres.use_case.dart';

@injectable
class GetArtistChartUseCase extends BaseExceptionService {
  GetArtistChartUseCase(
    this.remoteArtistChartDataSource,
    this._getGenreSubgenreUseCase,
    this._localAppInfoDataSource,
  );

  final RemoteArtistChartDataSource remoteArtistChartDataSource;
  final GetGenreSubgenreUseCase _getGenreSubgenreUseCase;
  final LocalAppInfoDataSource _localAppInfoDataSource;

  Future<List<ArtistChartDto>> call(String subgenre) async {
    return makeErrorParsedCall(() async {
      if (subgenre.isEmpty) {
        final List<Subgenre> subgenres = await _getGenreSubgenreUseCase(
          _localAppInfoDataSource.getGenre(),
        );
        final List<String> subgenresNamesList =
            subgenres.map((Subgenre s) => s.name).toList();

        return remoteArtistChartDataSource.getArtistChartsForAllSubGenres(
          subgenresNamesList,
        );
      }
      return remoteArtistChartDataSource.getArtistCharts(subgenre);
    });
  }
}

@injectable
class GetAllLikedArtistsUseCase extends BaseExceptionService {
  GetAllLikedArtistsUseCase(this.remoteArtistChartDataSource);

  final RemoteArtistChartDataSource remoteArtistChartDataSource;

  Future<List<ArtistChartDto>> call(List<String> artists) async {
    return makeErrorParsedCall(() async {
      final List<ArtistChartDto> resultArtists = <ArtistChartDto>[];

      for (int i = 0; i < artists.length; i = i + 10) {
        final List<ArtistChartDto> response =
            await remoteArtistChartDataSource.getAllLikedArtist(
          artists.sublist(
            i,
            (artists.length > i + 10) ? i + 10 : artists.length,
          ),
        );

        resultArtists.addAll(response);
      }
      return resultArtists;
    });
  }
}
