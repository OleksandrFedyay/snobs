import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'artist.g.dart';

@JsonSerializable()
class Artist extends Equatable {
  const Artist({
    required this.name,
    this.id = 0,
    this.popularity,
    this.image,
    this.bio,
    this.genre = '',
    this.likes = 0,
    this.unlikes = 0,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return _$ArtistFromJson(json);
  }
  final int id;
  final String? image;
  final String name;
  final int? popularity;
  final String? bio;
  final String genre;
  final int likes;
  final int unlikes;

  Map<String, dynamic> toJson() => _$ArtistToJson(this);

  @override
  List<Object?> get props {
    return <Object?>[
      id,
      image,
      name,
      popularity,
      bio,
      genre,
      likes,
      unlikes,
    ];
  }
}
