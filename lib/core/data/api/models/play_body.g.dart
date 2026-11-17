// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'play_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayBody _$PlayBodyFromJson(Map<String, dynamic> json) => PlayBody(
      favorites: (json['favorites'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const <int>[],
      upvotes: (json['upvotes'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const <int>[],
      downvotes: (json['downvotes'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const <int>[],
      exclude: (json['exclude'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const <int>[],
    );

Map<String, dynamic> _$PlayBodyToJson(PlayBody instance) => <String, dynamic>{
      'favorites': instance.favorites,
      'exclude': instance.exclude,
    };
