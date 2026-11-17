import 'package:json_annotation/json_annotation.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';

part 'radio_dto.g.dart';

@JsonSerializable(includeIfNull: false)
class RadioDto {
  const RadioDto({
    required this.subgenres,
    required this.genre,
    this.artists = const <ArtistChartDto>[],
  });

  factory RadioDto.fromJson(Map<String, dynamic> json) =>
      _$RadioDtoFromJson(json);

  final List<String> subgenres;
  final List<ArtistChartDto> artists;
  final String genre;

  Map<String, dynamic> toJson() => _$RadioDtoToJson(this);
}
