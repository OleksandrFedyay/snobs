// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist_collection.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArtistCollectionDto _$ArtistCollectionDtoFromJson(Map<String, dynamic> json) =>
    ArtistCollectionDto(
      name: json['name'] as String,
      artists: (json['artists'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$ArtistCollectionDtoToJson(
        ArtistCollectionDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'artists': instance.artists,
    };
