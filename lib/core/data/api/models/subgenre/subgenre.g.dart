// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subgenre.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subgenre _$SubgenreFromJson(Map<String, dynamic> json) => Subgenre(
      id: (json['id'] as num).toInt(),
      genreId: (json['genreId'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      enabled: json['enabled'] as bool,
    );

Map<String, dynamic> _$SubgenreToJson(Subgenre instance) => <String, dynamic>{
      'id': instance.id,
      'genreId': instance.genreId,
      'name': instance.name,
      'description': instance.description,
      'enabled': instance.enabled,
    };
