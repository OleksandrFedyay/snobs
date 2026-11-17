import 'package:json_annotation/json_annotation.dart';

part 'artist_collection.dto.g.dart';

@JsonSerializable(includeIfNull: false)
class ArtistCollectionDto {
  const ArtistCollectionDto({
    required this.name,
    this.artists = const <String>[],
  });

  factory ArtistCollectionDto.fromJson(Map<String, dynamic> json) =>
      _$ArtistCollectionDtoFromJson(json);
  final String name;
  final List<String> artists;

  ArtistCollectionDto copyWith({
    String? name,
    List<String>? artists,
  }) {
    return ArtistCollectionDto(
      name: name ?? this.name,
      artists: artists ?? this.artists,
    );
  }

  Map<String, dynamic> toJson() => _$ArtistCollectionDtoToJson(this);
}
