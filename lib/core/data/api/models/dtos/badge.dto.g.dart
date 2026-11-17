// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BadgeDto _$BadgeDtoFromJson(Map<String, dynamic> json) => BadgeDto(
      subgenre: json['subgenre'] as String,
      type: BadgesType.fromJson(json['type'] as String),
    );

Map<String, dynamic> _$BadgeDtoToJson(BadgeDto instance) => <String, dynamic>{
      'subgenre': instance.subgenre,
      'type': BadgesType.toJson(instance.type),
    };
