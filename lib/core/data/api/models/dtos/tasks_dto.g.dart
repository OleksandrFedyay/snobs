// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TasksDto _$TasksDtoFromJson(Map<String, dynamic> json) => TasksDto(
      description: json['description'] as String? ?? '',
      title: json['title'] as String? ?? '',
      xp: (json['xp'] as num?)?.toInt() ?? 0,
      id: json['id'] as String? ?? '',
    );

Map<String, dynamic> _$TasksDtoToJson(TasksDto instance) => <String, dynamic>{
      'description': instance.description,
      'title': instance.title,
      'xp': instance.xp,
      'id': instance.id,
    };
