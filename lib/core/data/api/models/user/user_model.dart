import 'package:json_annotation/json_annotation.dart';
import 'package:kingfishertom/features/utils/extensions/date_time_ext.dart';

part 'user_model.g.dart';

@JsonSerializable(includeIfNull: false)
class UserModel {
  const UserModel({
    required this.id,
    this.name,
    this.lastName,
    this.email,
    this.phone,
    this.zipCode,
    this.imageUrl,
    this.keys = 4,
    this.levelXp = 0,
    this.collections = const <Map<String, dynamic>>[],
    this.likes = const <String>[],
    this.unlockedSubgenres = const <String>[],
    this.skips = const <String>[],
    this.completedTasks = const <String>[],
    this.startTrialDate,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  final String id;
  final String? name;
  final String? lastName;
  final String? email;
  final String? imageUrl;
  //Todo(Issa): No need keys
  final int keys;
  final int levelXp;
  @JsonKey(name: 'like')
  final List<String> likes;
  final List<Map<String, dynamic>> collections;
  @JsonKey(name: 'skip')
  final List<String> skips;
  final List<String> unlockedSubgenres;
  final List<String> completedTasks;
  final String? phone;
  final String? zipCode;
  @JsonKey(fromJson: DateTimeExt.fromJsonInt, toJson: DateTimeExt.toJsonInt)
  final DateTime? startTrialDate;

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel update({
    String? id,
    String? email,
    String? name,
    String? lastName,
    String? phone,
    String? imageUrl,
    String? zipCode,
    DateTime? startTrialDate,
    int? keys,
    int? levelXp,
    List<String>? likes,
    List<Map<String, dynamic>>? collections,
    List<String>? skips,
    List<String>? unlockedSubgenres,
    List<String>? completedTasks,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      imageUrl: imageUrl ?? this.imageUrl,
      zipCode: zipCode ?? this.zipCode,
      startTrialDate: startTrialDate ?? this.startTrialDate,
      keys: keys ?? this.keys,
      levelXp: levelXp ?? this.levelXp,
      likes: likes ?? this.likes,
      completedTasks: completedTasks ?? this.completedTasks,
      collections: collections ?? this.collections,
      skips: skips ?? this.skips,
      unlockedSubgenres: unlockedSubgenres ?? this.unlockedSubgenres,
    );
  }
}
