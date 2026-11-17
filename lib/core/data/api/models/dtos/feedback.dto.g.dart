// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedbackDto _$FeedbackDtoFromJson(Map<String, dynamic> json) => FeedbackDto(
      type: $enumDecode(_$FeedbackTypeEnumMap, json['type']),
      files:
          (json['files'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const <String>[],
      text: json['text'] as String? ?? '',
      needUpdate: json['needUpdate'] as String?,
      artistName: json['artistName'] as String?,
      subgenre: json['subgenre'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$FeedbackDtoToJson(FeedbackDto instance) =>
    <String, dynamic>{
      'type': FeedbackType.toJson(instance.type),
      'text': instance.text,
      'artistName': instance.artistName,
      'subgenre': instance.subgenre,
      'email': instance.email,
      'files': instance.files,
      'needUpdate': instance.needUpdate,
    };

const _$FeedbackTypeEnumMap = {
  FeedbackType.reportIssue: 'reportIssue',
  FeedbackType.feature: 'feature',
  FeedbackType.artistIssue: 'artistIssue',
  FeedbackType.missingArtist: 'missingArtist',
  FeedbackType.support: 'support',
  FeedbackType.subgenreRequest: 'subgenreRequest',
};
