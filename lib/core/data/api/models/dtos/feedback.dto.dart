import 'package:json_annotation/json_annotation.dart';
import 'package:kingfishertom/core/data/api/models/dtos/feedback_type.dart';

part 'feedback.dto.g.dart';

@JsonSerializable()
class FeedbackDto {
  const FeedbackDto({
    required this.type,
    this.files = const <String>[],
    this.text = '',
    this.needUpdate,
    this.artistName,
    this.subgenre,
    this.email,
  });

  factory FeedbackDto.fromJson(Map<String, dynamic> json) =>
      _$FeedbackDtoFromJson(json);
  @JsonKey(toJson: FeedbackType.toJson)
  final FeedbackType type;
  final String text;
  final String? artistName;
  final String? subgenre;
  final String? email;
  final List<String> files;
  final String? needUpdate;

  Map<String, dynamic> toJson() => _$FeedbackDtoToJson(this);

  FeedbackDto copyWith({
    FeedbackType? type,
    String? text,
    String? artistName,
    String? subgenre,
    String? email,
    List<String>? files,
    String? needUpdate,
  }) {
    return FeedbackDto(
      type: type ?? this.type,
      text: text ?? this.text,
      artistName: artistName ?? this.artistName,
      subgenre: subgenre ?? this.subgenre,
      email: email ?? this.email,
      files: files ?? this.files,
      needUpdate: needUpdate ?? this.needUpdate,
    );
  }
}
