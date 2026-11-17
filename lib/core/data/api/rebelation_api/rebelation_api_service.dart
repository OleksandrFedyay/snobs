import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/play_body.dart';
import 'package:kingfishertom/core/data/api/models/recommendations/track.dart';
import 'package:kingfishertom/core/data/api/rebelation_api/rebelation_api_client.dart';
import 'package:kingfishertom/core/domain/exception/base_exception_service.dart';

@injectable
class RebelationApiService extends BaseExceptionService {
  RebelationApiService(this.rebelationApiClient);

  final RebelationApiClient rebelationApiClient;

  Future<List<Track>> getArtistTracks(String id) async {
    return makeErrorParsedCall(() async {
      return rebelationApiClient.getArtistTracks(id);
    });
  }

  Future<List<Track>> getRadioTracks(PlayBody body) async {
    return makeErrorParsedCall(() async {
      final List<Track> tracks = await rebelationApiClient.getRadioTracks(body);
      tracks.sort(
          (Track a, Track b) => a.artists.length.compareTo(b.artists.length));
      return tracks;
    });
  }
}
