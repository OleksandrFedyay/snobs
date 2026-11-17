import 'package:json_annotation/json_annotation.dart';
import 'package:kingfishertom/core/data/api/models/recommendations/track.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';

part 'artist_chart.dto.g.dart';

@JsonSerializable(includeIfNull: false)
class ArtistChartDto {
  const ArtistChartDto({
    required this.id,
    required this.name,
    this.likes = 0,
    this.unlikes = 0,
    this.popularity = 0,
    this.image = '',
    this.subgenres = const <String>[],
    this.bio,
    this.rebelationTracks = const <Track>[],
    this.tracks = const <String>[],
    this.productLink = '',
    this.productEventName = '',
  });

  factory ArtistChartDto.fromJson(Map<String, dynamic> json) =>
      _$ArtistChartDtoFromJson(json);
  @JsonKey(fromJson: StringExt.fromJson)
  final String id;
  final int likes;
  final int unlikes;
  final String name;
  final String image;
  final int popularity;
  final List<String> subgenres;
  final String? bio;
  @JsonKey(includeToJson: false)
  final List<Track> rebelationTracks;
  final List<String> tracks;
  @JsonKey(includeToJson: false)
  final String productLink;
  @JsonKey(includeToJson: false)
  final String productEventName;

  Map<String, dynamic> toJson() => _$ArtistChartDtoToJson(this);

  ArtistChartDto copyWith({
    String? id,
    int? likes,
    int? unlikes,
    String? name,
    String? image,
    int? popularity,
    List<String>? subgenres,
    String? bio,
    List<Track>? rebelationTracks,
    List<String>? tracks,
    String? productLink,
    String? productEventName,
  }) {
    return ArtistChartDto(
      id: id ?? this.id,
      likes: likes ?? this.likes,
      unlikes: unlikes ?? this.unlikes,
      name: name ?? this.name,
      image: image ?? this.image,
      popularity: popularity ?? this.popularity,
      subgenres: subgenres ?? this.subgenres,
      bio: bio ?? this.bio,
      rebelationTracks: rebelationTracks ?? this.rebelationTracks,
      tracks: tracks ?? this.tracks,
      productLink: productLink ?? this.productLink,
      productEventName: productEventName ?? this.productEventName,
    );
  }
}
