import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/recommendations/track.dart';
import 'package:kingfishertom/core/data/data_sources/remote.tracks.data_source.dart';
import 'package:kingfishertom/core/domain/exception/base_exception_service.dart';

@injectable
class LikeTrackUseCase extends BaseExceptionService {
  LikeTrackUseCase(this._remoteTracksDataSource);

  final RemoteTracksDataSource _remoteTracksDataSource;

  Future<Track?> call(String? artistId, String? userId, String trackId) async {
    return makeErrorParsedCall(() async {
      if (artistId == null) return null;
      if (userId == null) return null;

      return _remoteTracksDataSource.likeTracks(
        artistId,
        trackId,
        userId,
      );
    });
  }
}
