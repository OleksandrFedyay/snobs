// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Track _$TrackFromJson(Map<String, dynamic> json) => Track(
      displayArtists: json['displayArtists'] as String,
      title: json['title'] as String,
      id: (json['id'] as num).toInt(),
      url: json['url'] as String,
      art: json['art'] as String? ?? '',
      likes:
          (json['likes'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const <String>[],
      artists: (json['artists'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const <int>[],
    );

Map<String, dynamic> _$TrackToJson(Track instance) => <String, dynamic>{
      'id': instance.id,
      'displayArtists': instance.displayArtists,
      'title': instance.title,
      'url': instance.url,
      'likes': instance.likes,
      'artists': instance.artists,
      'art': instance.art,
    };
