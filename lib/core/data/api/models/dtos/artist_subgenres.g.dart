// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist_subgenres.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArtistSubgenres _$ArtistSubgenresFromJson(Map<String, dynamic> json) =>
    ArtistSubgenres(
      artistId: json['artistId'] as String? ?? '',
      subgenres: (json['subgenres'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      status: json['status'] == null
          ? ArtistSubgenresStatus.newStatus
          : ArtistSubgenresStatus.fromJson(json['status'] as String?),
    );

Map<String, dynamic> _$ArtistSubgenresToJson(ArtistSubgenres instance) =>
    <String, dynamic>{
      'artistId': instance.artistId,
      'subgenres': instance.subgenres,
      'status': ArtistSubgenresStatus.toJson(instance.status),
    };
