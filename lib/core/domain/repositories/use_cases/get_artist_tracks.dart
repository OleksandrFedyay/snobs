import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/recommendations/track.dart';
import 'package:kingfishertom/core/data/api/rebelation_api/rebelation_api_service.dart';
import 'package:kingfishertom/core/data/data_sources/remote.tracks.data_source.dart';
import 'package:kingfishertom/core/domain/exception/base_exception_service.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';

@injectable
class GetArtistTracksUseCase extends BaseExceptionService {
  GetArtistTracksUseCase(
    this.remoteTracksDataSource,
    this.rebelationApiService,
  );

  final RemoteTracksDataSource remoteTracksDataSource;
  final RebelationApiService rebelationApiService;

  Future<List<Track>> call(String artistId) async {
    final List<Track> tracks =
        await remoteTracksDataSource.getArtistTracks(artistId);
    if (tracks.isEmpty) {
      final List<Track> rebelation = <Track>[];

      try {
        rebelation.addAll(await rebelationApiService.getArtistTracks(artistId));
        await remoteTracksDataSource.addTracks(artistId, rebelation);
      } catch (e) {
        rebelation.clear();
      }
      return _getDistinctList(rebelation);
    }

    return _getDistinctList(tracks);
  }

  List<Track> _getDistinctList(List<Track> tracks) {
    final List<Track> res = <Track>[];

    for (final Track t in tracks) {
      if (!_trackContains(res, t)) {
        res.add(t);
      }
    }

    res.sort(
        (Track a, Track b) => a.artists.length.compareTo(b.artists.length));
    return res;
  }

  bool _trackContains(List<Track> tracks, Track track) {
    for (final Track t in tracks) {
      if (t.displayArtists == track.displayArtists &&
          t.title.getSimpleString() == track.title.getSimpleString()) {
        return true;
      }
    }
    return false;
  }
}
