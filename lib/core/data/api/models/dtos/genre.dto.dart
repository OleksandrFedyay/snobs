import 'package:json_annotation/json_annotation.dart';

part 'genre.dto.g.dart';

@JsonSerializable(includeIfNull: false)
class GenreDto {
  const GenreDto({
    this.subgenres = const <String>[],
    this.enabled = true,
  });

  factory GenreDto.fromJson(Map<String, dynamic> json) =>
      _$GenreDtoFromJson(json);
  final List<String> subgenres;
  final bool enabled;

  Map<String, dynamic> toJson() => _$GenreDtoToJson(this);
}
