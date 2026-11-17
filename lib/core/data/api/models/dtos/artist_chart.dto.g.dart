// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist_chart.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArtistChartDto _$ArtistChartDtoFromJson(Map<String, dynamic> json) =>
    ArtistChartDto(
      id: StringExt.fromJson(json['id']),
      name: json['name'] as String,
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      unlikes: (json['unlikes'] as num?)?.toInt() ?? 0,
      popularity: (json['popularity'] as num?)?.toInt() ?? 0,
      image: json['image'] as String? ?? '',
      subgenres: (json['subgenres'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      bio: json['bio'] as String?,
      rebelationTracks: (json['rebelationTracks'] as List<dynamic>?)
              ?.map((e) => Track.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Track>[],
      tracks: (json['tracks'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      productLink: json['productLink'] as String? ?? '',
      productEventName: json['productEventName'] as String? ?? '',
    );

Map<String, dynamic> _$ArtistChartDtoToJson(ArtistChartDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'likes': instance.likes,
      'unlikes': instance.unlikes,
      'name': instance.name,
      'image': instance.image,
      'popularity': instance.popularity,
      'subgenres': instance.subgenres,
      if (instance.bio case final value?) 'bio': value,
      'tracks': instance.tracks,
    };
