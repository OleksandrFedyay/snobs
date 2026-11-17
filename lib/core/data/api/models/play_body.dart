import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'play_body.g.dart';

@JsonSerializable()
class PlayBody extends Equatable {
  const PlayBody({
    this.favorites = const <int>[],
    this.upvotes = const <int>[],
    this.downvotes = const <int>[],
    this.exclude = const <int>[],
  });

  factory PlayBody.fromJson(Map<String, dynamic> json) {
    return _$PlayBodyFromJson(json);
  }

  final List<int> favorites;
  final List<int> exclude;

  //TODO: Implement later upvotes & downvotes

  @JsonKey(includeToJson: false)
  final List<int> upvotes;
  @JsonKey(includeToJson: false)
  final List<int> downvotes;

  Map<String, dynamic> toJson() => _$PlayBodyToJson(this);

  @override
  List<Object> get props => <Object>[favorites, upvotes, downvotes, exclude];
}
