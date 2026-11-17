import 'package:json_annotation/json_annotation.dart';

part 'subgenre_liked.g.dart';

@JsonSerializable(includeIfNull: false)
class SubgenreLiked {
  const SubgenreLiked({
    this.likes = 0,
    this.unlikes = 0,
    this.subGenre = '',
  });

  factory SubgenreLiked.fromJson(Map<String, dynamic> json) =>
      _$SubgenreLikedFromJson(json);
  final int likes;
  final int unlikes;
  final String subGenre;

  SubgenreLiked copyWith({
    int? likes,
    int? unlikes,
    String? subGenre,
  }) {
    return SubgenreLiked(
      likes: likes ?? this.likes,
      unlikes: unlikes ?? this.unlikes,
      subGenre: subGenre ?? this.subGenre,
    );
  }

  Map<String, dynamic> toJson() => _$SubgenreLikedToJson(this);
}
