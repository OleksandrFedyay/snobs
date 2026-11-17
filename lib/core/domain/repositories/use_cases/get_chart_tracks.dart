import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/artists/artist.dart';
import 'package:kingfishertom/core/data/api/models/recommendations/track.dart';
import 'package:kingfishertom/core/data/api/rebelation_api/rebelation_api_client.dart';
import 'package:kingfishertom/core/data/data_sources/remote.tracks.data_source.dart';
import 'package:kingfishertom/core/domain/exception/base_exception_service.dart';
import 'package:kingfishertom/core/services/di/injection.dart';

@injectable
class GetChartTracksUseCase extends BaseExceptionService {
  GetChartTracksUseCase(
    this._remoteTracksDataSource,
  );

  final RemoteTracksDataSource _remoteTracksDataSource;

  Future<List<Track>> call(String subgenre) async {
    return makeErrorParsedCall(() async {
      final List<Artist> subgenreArtists = await getIt<RebelationApiClient>()
          .getArtists(subgenre.trim().toLowerCase());

      final Set<String> subgenreArtistNames =
          subgenreArtists.map((Artist artist) => artist.name).toSet();

      final List<Track> chartAllTracks =
          await _remoteTracksDataSource.getChartTracks();

      final List<Track> tracksBySubgenre = chartAllTracks
          .where((Track track) =>
              subgenreArtistNames.contains(track.displayArtists))
          .toList();

      return tracksBySubgenre;
    });
  }
}
