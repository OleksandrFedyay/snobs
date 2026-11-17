// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'radio_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RadioDto _$RadioDtoFromJson(Map<String, dynamic> json) => RadioDto(
      subgenres:
          (json['subgenres'] as List<dynamic>).map((e) => e as String).toList(),
      genre: json['genre'] as String,
      artists: (json['artists'] as List<dynamic>?)
              ?.map((e) => ArtistChartDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ArtistChartDto>[],
    );

Map<String, dynamic> _$RadioDtoToJson(RadioDto instance) => <String, dynamic>{
      'subgenres': instance.subgenres,
      'artists': instance.artists,
      'genre': instance.genre,
    };
