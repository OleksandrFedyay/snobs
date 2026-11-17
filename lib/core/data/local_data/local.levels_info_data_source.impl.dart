import 'dart:convert';
import 'dart:core';

import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/dtos/level_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

///Keeps all users' levels: Normie, Fan, Scout, Nerd, Snob, Elite Snob.
@lazySingleton
class LocalLevelsInfoDataSourceImpl {
  const LocalLevelsInfoDataSourceImpl({
    required SharedPreferences storage,
  }) : _storage = storage;

  final SharedPreferences _storage;
  static const String _allLevels = 'allLevels';

  Future<void> setAllLevels(List<LevelDto> allLevels) async {
    final List<String> encodedLevels = allLevels.map((LevelDto l) => jsonEncode(l.toJson())).toList();
    await _storage.setStringList(_allLevels, encodedLevels);
  }

  Future<List<LevelDto>?> getAllLevels() async {
    final List<String>? result = _storage.getStringList(_allLevels);
    if (result != null) {
      final List<LevelDto> allLevels = result
          .map<LevelDto>(
            (String l) => LevelDto.fromJson(jsonDecode(l) as Map<String, dynamic>),
          )
          .toList();
      return allLevels;
    }
    return null;
  }
}
