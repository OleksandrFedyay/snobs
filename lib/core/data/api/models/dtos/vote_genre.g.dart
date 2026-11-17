// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vote_genre.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VoteGenre _$VoteGenreFromJson(Map<String, dynamic> json) => VoteGenre(
      genre: json['genre'] as String,
      downvote: (json['downvote'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      upvote: (json['upvote'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$VoteGenreToJson(VoteGenre instance) => <String, dynamic>{
      'genre': instance.genre,
      'upvote': instance.upvote,
      'downvote': instance.downvote,
    };
