import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/recommendations/track.dart';
import 'package:kingfishertom/core/data/data_sources/remote.tracks.data_source.dart';
import 'package:kingfishertom/core/domain/exception/base_exception_service.dart';

///Replaced with GetLikedSubgenreTrackUseCase to provide proper logic at the SubgenrePage -
///to show only songs played by artist tagged with subgenre.
///TODO delete this if no further usage
@injectable
class GetLikedTracksUseCase extends BaseExceptionService {
  GetLikedTracksUseCase(
    this._remoteTracksDataSource,
  );

  final RemoteTracksDataSource _remoteTracksDataSource;

  Future<List<Track>> call(String userId) async {
    return makeErrorParsedCall(() async {
      return _remoteTracksDataSource.getLikedTracks(userId);
    });
  }
}
