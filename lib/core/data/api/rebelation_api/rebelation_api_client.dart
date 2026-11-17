import 'dart:async';

import 'package:dio/dio.dart';
import 'package:kingfishertom/core/data/api/api_constants.dart';
import 'package:kingfishertom/core/data/api/models/artists/artist.dart';
import 'package:kingfishertom/core/data/api/models/play_body.dart';
import 'package:kingfishertom/core/data/api/models/recommendations/track.dart';
import 'package:retrofit/retrofit.dart';

part 'rebelation_api_client.g.dart';

@RestApi(baseUrl: ApiConstants.rebelationApiUrl)
abstract class RebelationApiClient {
  factory RebelationApiClient(
    Dio dio, {
    String baseUrl,
  }) = _RebelationApiClient;

  @GET('artist/{id}/tracks')
  Future<List<Track>> getArtistTracks(
    @Path() String id, [
    @Query('limit') int limit = 20,
  ]);

  @GET('')
  Future<List<Artist>> getArtists(
    @Query('subgenre') String subgenre,
  );

  @POST('play')
  Future<List<Track>> getRadioTracks(
    @Body() PlayBody playBody,
  );

  @GET('spotify/{id}')
  Future<Artist> getRebelationId(
    @Path('id') String id,
  );

  @GET('artist/{id}')
  Future<Artist> getArtistById(
    @Path('id') String id,
  );
}
