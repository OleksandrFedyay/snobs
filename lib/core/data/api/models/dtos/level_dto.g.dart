// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LevelDto _$LevelDtoFromJson(Map<String, dynamic> json) => LevelDto(
      nextName: json['nextName'] as String? ?? '',
      name: json['name'] as String? ?? '',
      xp: (json['xp'] as num?)?.toInt() ?? 0,
      tasks: json['tasks'] == null
          ? const <TasksDto>[]
          : TasksExt.fromJson(json['tasks'] as List),
    );

Map<String, dynamic> _$LevelDtoToJson(LevelDto instance) => <String, dynamic>{
      'name': instance.name,
      'nextName': instance.nextName,
      'xp': instance.xp,
      'tasks': instance.tasks,
    };
