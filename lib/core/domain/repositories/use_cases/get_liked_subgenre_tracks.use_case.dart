import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/artists/artist.dart';
import 'package:kingfishertom/core/data/api/models/recommendations/track.dart';
import 'package:kingfishertom/core/data/api/rebelation_api/rebelation_api_client.dart';
import 'package:kingfishertom/core/data/data_sources/remote.tracks.data_source.dart';
import 'package:kingfishertom/core/domain/exception/base_exception_service.dart';
import 'package:kingfishertom/core/services/di/injection.dart';

/// Received songs played by artist tagged with exact subgenre
@injectable
class GetLikedSubgenreTrackUseCase extends BaseExceptionService {
  GetLikedSubgenreTrackUseCase(
    RemoteTracksDataSource remoteTracksDataSource,
  ) : _remoteTracksDataSource = remoteTracksDataSource;
  final RemoteTracksDataSource _remoteTracksDataSource;

  Future<List<Track>> call(String userId, String subgenre) async {
    return makeErrorParsedCall(() async {
      final List<Artist> subgenreArtists = await getIt<RebelationApiClient>()
          .getArtists(subgenre.trim().toLowerCase());

      final Set<String> subgenreArtistNames =
          subgenreArtists.map((Artist artist) => artist.name).toSet();

      final List<Track> userLikedTracks =
          await _remoteTracksDataSource.getLikedTracks(userId);

      final List<Track> likedSubgenreTracks = userLikedTracks
          .where((Track track) =>
              subgenreArtistNames.contains(track.displayArtists))
          .toList();

      return likedSubgenreTracks;
    });
  }
}
