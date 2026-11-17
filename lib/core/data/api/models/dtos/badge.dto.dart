import 'package:json_annotation/json_annotation.dart';
import 'package:kingfishertom/features/presentation/screens/home/view/badges/badges_enum.dart';

part 'badge.dto.g.dart';

@JsonSerializable()
class BadgeDto {
  const BadgeDto({
    required this.subgenre,
    required this.type,
  });

  factory BadgeDto.fromJson(Map<String, dynamic> json) =>
      _$BadgeDtoFromJson(json);
  final String subgenre;
  @JsonKey(fromJson: BadgesType.fromJson, toJson: BadgesType.toJson)
  final BadgesType type;

  Map<String, dynamic> toJson() => _$BadgeDtoToJson(this);
}
