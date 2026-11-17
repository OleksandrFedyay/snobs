import 'package:json_annotation/json_annotation.dart';
import 'package:kingfishertom/core/data/api/models/dtos/tasks_dto.dart';

part 'level_dto.g.dart';

@JsonSerializable(includeIfNull: false)
class LevelDto {
  const LevelDto({
    this.nextName = '',
    this.name = '',
    this.xp = 0,
    this.tasks = const <TasksDto>[],
  });

  factory LevelDto.fromJson(Map<String, dynamic> json) =>
      _$LevelDtoFromJson(json);

  final String name;
  final String nextName;
  final int xp;
  @JsonKey(fromJson: TasksExt.fromJson)
  final List<TasksDto> tasks;

  Map<String, dynamic> toJson() => _$LevelDtoToJson(this);
}
