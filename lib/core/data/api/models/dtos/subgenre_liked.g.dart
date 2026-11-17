// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subgenre_liked.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubgenreLiked _$SubgenreLikedFromJson(Map<String, dynamic> json) =>
    SubgenreLiked(
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      unlikes: (json['unlikes'] as num?)?.toInt() ?? 0,
      subGenre: json['subGenre'] as String? ?? '',
    );

Map<String, dynamic> _$SubgenreLikedToJson(SubgenreLiked instance) =>
    <String, dynamic>{
      'likes': instance.likes,
      'unlikes': instance.unlikes,
      'subGenre': instance.subGenre,
    };
