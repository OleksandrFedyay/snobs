import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/kingfishertom_api/kingfishertom_api_client.dart';
import 'package:kingfishertom/core/data/api/models/artists/artist.dart';
import 'package:kingfishertom/core/data/api/models/dtos/level_dto.dart';
import 'package:kingfishertom/core/data/api/models/genre/genre.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/domain/exception/base_exception_service.dart';
import 'package:retrofit/dio.dart';

///This service is used for retrieving data from Kingfishertom server
@injectable
class KingfishertomApiService extends BaseExceptionService {
  KingfishertomApiService(KingfishertomApiClient kingfishertomApiClient)
      : _kingfishertomApiClient = kingfishertomApiClient;
  final KingfishertomApiClient _kingfishertomApiClient;

  ///Retrieves jwt token
  Future<String?> getUserJwtToken({
    required UserModel user,
    required String token,
  }) async {
    return makeErrorParsedCall(() async {
      final HttpResponse<UserModel> result =
          await _kingfishertomApiClient.getUserModel(
        user: user,
        token: token,
      );

      return result.response.headers['jwt']?.firstOrNull;
    });
  }

  ///Receives Genres form kingfishertom server
  Future<List<Genre>> getGenres() async {
    return makeErrorParsedCall(() async {
      return _kingfishertomApiClient.getGenres();
    });
  }

  ///Receives Artist form kingfishertom server
  Future<Artist> getArtist({
    required String id,
    required String token,
  }) async {
    return makeErrorParsedCall(() async {
      return _kingfishertomApiClient.getArtist(id: id, jwt: token);
    });
  }

  ///Adds Artist to the kingfishertom server
  Future<Artist> postArtist({
    required Artist artist,
    required String token,
  }) async {
    return makeErrorParsedCall(() async {
      return _kingfishertomApiClient.postArtist(artist: artist, jwt: token);
    });
  }

  ///Adds Artist to the kingfishertom server (For copying the Artist only from firebase to the server)
  Future<Artist> addArtistToDB({
    required Artist artist,
    required String token,
  }) async {
    return makeErrorParsedCall(() async {
      return _kingfishertomApiClient.addArtistToDB(artist: artist, jwt: token);
    });
  }


  ///Deletes Artist from kingfishertom server
  Future<void> deleteArtist({
    required String id,
    required String token,
  }) async {
    return makeErrorParsedCall(() async {
      return _kingfishertomApiClient.deleteArtist(id: id, jwt: token);
    });
  }

  ///Retrieves all Levels from kingfishertom server:
  ///Normie, Fan, Scout, Nerd, Snob, Elite Snob
  Future<List<LevelDto>> getAllLevels({required String jwt}) async {
    return makeErrorParsedCall(() async {
      return _kingfishertomApiClient.getAllLevels(jwt: jwt);
    });
  }
}
