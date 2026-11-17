import 'package:json_annotation/json_annotation.dart';

part 'genres.dto.g.dart';

@JsonSerializable(includeIfNull: false)
class GenresDto {
  const GenresDto({ this.genre = '', required this.subgenres});

  factory GenresDto.fromJson(Map<String, dynamic> json) =>
      _$GenresDtoFromJson(json);

  final String genre;
  final List<String> subgenres;

  Map<String, dynamic> toJson() => _$GenresDtoToJson(this);
}
