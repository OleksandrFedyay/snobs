import 'package:json_annotation/json_annotation.dart';

part 'vote_genre.g.dart';

@JsonSerializable()
class VoteGenre {
  const VoteGenre({
    required this.genre,
    this.downvote = const <String>[],
    this.upvote = const <String>[],
  });

  factory VoteGenre.fromJson(Map<String, dynamic> json) =>
      _$VoteGenreFromJson(json);

  final String genre;
  final List<String> upvote;
  final List<String> downvote;

  int upvoteLength({required bool useDefault}) =>
      (useDefault ? 10 : 0) + upvote.length;
  int get downvoteLength => downvote.length;

  int _total(bool useDefault) =>
      upvoteLength(useDefault: useDefault) + downvoteLength;
  int summary({required bool useDefault}) {
    final int total = _total(useDefault);

    return total == 0 ? 1 : total;
  }

  Map<String, dynamic> toJson() => _$VoteGenreToJson(this);

  VoteGenre copyWith({
    String? genre,
    List<String>? upvote,
    List<String>? downvote,
  }) {
    return VoteGenre(
      genre: genre ?? this.genre,
      upvote: upvote ?? this.upvote,
      downvote: downvote ?? this.downvote,
    );
  }
}
