import 'package:json_annotation/json_annotation.dart';

part 'tasks_dto.g.dart';

@JsonSerializable(includeIfNull: false)
class TasksDto {
  const TasksDto({
    this.description = '',
    this.title = '',
    this.xp = 0,
    this.id = '',
  });

  factory TasksDto.fromJson(Map<String, dynamic> json) =>
      _$TasksDtoFromJson(json);

  final String description;
  final String title;
  final int xp;
  final String id;

  Map<String, dynamic> toJson() => _$TasksDtoToJson(this);
}

extension TasksExt on TasksDto {
  static List<TasksDto> fromJson(List<dynamic> json) {
    return json.map((dynamic item) {
      return TasksDto.fromJson(item as Map<String, dynamic>);
    }).toList();
  }
}
