// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      name: json['name'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      zipCode: json['zipCode'] as String?,
      imageUrl: json['imageUrl'] as String?,
      keys: (json['keys'] as num?)?.toInt() ?? 4,
      levelXp: (json['levelXp'] as num?)?.toInt() ?? 0,
      collections: (json['collections'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const <Map<String, dynamic>>[],
      likes:
          (json['like'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const <String>[],
      unlockedSubgenres: (json['unlockedSubgenres'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      skips:
          (json['skip'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const <String>[],
      completedTasks: (json['completedTasks'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      startTrialDate:
          DateTimeExt.fromJsonInt((json['startTrialDate'] as num?)?.toInt()),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      if (instance.name case final value?) 'name': value,
      if (instance.lastName case final value?) 'lastName': value,
      if (instance.email case final value?) 'email': value,
      if (instance.imageUrl case final value?) 'imageUrl': value,
      'keys': instance.keys,
      'levelXp': instance.levelXp,
      'like': instance.likes,
      'collections': instance.collections,
      'skip': instance.skips,
      'unlockedSubgenres': instance.unlockedSubgenres,
      'completedTasks': instance.completedTasks,
      if (instance.phone case final value?) 'phone': value,
      if (instance.zipCode case final value?) 'zipCode': value,
      if (DateTimeExt.toJsonInt(instance.startTrialDate) case final value?)
        'startTrialDate': value,
    };
