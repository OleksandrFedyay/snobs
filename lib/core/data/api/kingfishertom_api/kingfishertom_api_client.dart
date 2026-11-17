import 'package:dio/dio.dart';
import 'package:kingfishertom/core/data/api/api_constants.dart';
import 'package:kingfishertom/core/data/api/models/artists/artist.dart';
import 'package:kingfishertom/core/data/api/models/dtos/level_dto.dart';
import 'package:kingfishertom/core/data/api/models/genre/genre.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:retrofit/retrofit.dart';

part 'kingfishertom_api_client.g.dart';

@RestApi(baseUrl: ApiConstants.kingfishertomApiUrl)
abstract class KingfishertomApiClient {
  factory KingfishertomApiClient(
    Dio dio, {
    String baseUrl,
  }) = _KingfishertomApiClient;

  ///Retrieves User Model and JWT token
  @POST('/me')
  Future<HttpResponse<UserModel>> getUserModel({
    @Body() required UserModel user,
    @Header('authorization') required String token,
  });

  ///Receives Genres from kingfishertom server
  @GET('/genres')
  Future<List<Genre>> getGenres();

  ///Receives Artist from kingfishertom server
  @GET('api/artist/{id}')
  Future<Artist> getArtist({
    @Path() required String id,
    @Header('authorization') required String jwt,
  });

  ///Adds Artist to the kingfishertom server
  @POST('api/artist')
  Future<Artist> postArtist({
    @Body() required Artist artist,
    @Header('authorization') required String jwt,
  });

  ///Adds Artist to the kingfishertom server (For copying the Artist only from firebase to the server)
  @POST('api/admin/artist')
  Future<Artist> addArtistToDB({
    @Body() required Artist artist,
    @Header('authorization') required String jwt,
  });

  ///Deletes Artist from kingfishertom server
  @DELETE('api/artist/{id}')
  Future<void> deleteArtist({
    @Path() required String id,
    @Header('authorization') required String jwt,
  });

  ///Retrieves user's level from kingfishertom server:
  ///Normie, Fan, Scout, Nerd, Snob, Elite Snob
  @GET('api/levels')
  Future<List<LevelDto>> getAllLevels({
    @Header('authorization') required String jwt,
  });
}
