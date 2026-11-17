// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_subgenre_liked.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSubgenreLiked _$UserSubgenreLikedFromJson(Map<String, dynamic> json) =>
    UserSubgenreLiked(
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      unlikes: (json['unlikes'] as num?)?.toInt() ?? 0,
      genre: json['genre'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
    );

Map<String, dynamic> _$UserSubgenreLikedToJson(UserSubgenreLiked instance) =>
    <String, dynamic>{
      'likes': instance.likes,
      'unlikes': instance.unlikes,
      'genre': instance.genre,
      'userId': instance.userId,
    };
