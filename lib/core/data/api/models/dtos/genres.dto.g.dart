// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'genres.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenresDto _$GenresDtoFromJson(Map<String, dynamic> json) => GenresDto(
      genre: json['genre'] as String? ?? '',
      subgenres:
          (json['subgenres'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$GenresDtoToJson(GenresDto instance) => <String, dynamic>{
      'genre': instance.genre,
      'subgenres': instance.subgenres,
    };
