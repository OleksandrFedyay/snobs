import 'package:json_annotation/json_annotation.dart';

part 'user_subgenre_liked.g.dart';

@JsonSerializable(includeIfNull: false)
class UserSubgenreLiked {
  const UserSubgenreLiked({
    this.likes = 0,
    this.unlikes = 0,
    this.genre = '',
    this.userId = '',
  });

  factory UserSubgenreLiked.fromJson(Map<String, dynamic> json) =>
      _$UserSubgenreLikedFromJson(json);
  final int likes;
  final int unlikes;
  final String genre;
  final String userId;

  UserSubgenreLiked copyWith({
    int? likes,
    int? unlikes,
    String? genre,
    String? userId,
  }) {
    return UserSubgenreLiked(
      likes: likes ?? this.likes,
      unlikes: unlikes ?? this.unlikes,
      genre: genre ?? this.genre,
      userId: userId ?? this.userId,
    );
  }
}
