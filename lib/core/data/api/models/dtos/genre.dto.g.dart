// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'genre.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenreDto _$GenreDtoFromJson(Map<String, dynamic> json) => GenreDto(
      subgenres: (json['subgenres'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      enabled: json['enabled'] as bool? ?? true,
    );

Map<String, dynamic> _$GenreDtoToJson(GenreDto instance) => <String, dynamic>{
      'subgenres': instance.subgenres,
      'enabled': instance.enabled,
    };
