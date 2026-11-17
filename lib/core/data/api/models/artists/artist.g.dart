// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Artist _$ArtistFromJson(Map<String, dynamic> json) => Artist(
      name: json['name'] as String,
      id: (json['id'] as num?)?.toInt() ?? 0,
      popularity: (json['popularity'] as num?)?.toInt(),
      image: json['image'] as String?,
      bio: json['bio'] as String?,
      genre: json['genre'] as String? ?? '',
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      unlikes: (json['unlikes'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ArtistToJson(Artist instance) => <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'name': instance.name,
      'popularity': instance.popularity,
      'bio': instance.bio,
      'genre': instance.genre,
      'likes': instance.likes,
      'unlikes': instance.unlikes,
    };
