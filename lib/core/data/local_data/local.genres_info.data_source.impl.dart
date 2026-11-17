import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/dtos/subgenre_liked.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class LocalGenresInfoDataSourceImpl {
  LocalGenresInfoDataSourceImpl(this._storage);
  final SharedPreferences _storage;

  static const String _allGenresKey = '_allGenresKey';
  static const String _allSubgenresKey = '_allSubgenresKey';
  static const String _key = 'Key';
  static const String _versionKey = '_genreVersion';

  List<String> getGenres() => _storage.getStringList(_allGenresKey) ?? <String>[];

  Future<void> setGenre(List<String> genres) async {
    await _storage.setStringList(_allGenresKey, genres);
  }

  List<SubgenreLiked> getSubgenres() {
    final List<String> res = _storage.getStringList(_allSubgenresKey) ?? <String>[];
    return res
        .map(
          (String g) => SubgenreLiked.fromJson(jsonDecode(g) as Map<String, dynamic>),
        )
        .toList();
  }

  Future<void> setSubgenre(List<SubgenreLiked> genres) async {
    await _storage.setStringList(
      _allSubgenresKey,
      genres.map((SubgenreLiked g) => jsonEncode(g.toJson())).toList(),
    );
  }

  List<String> getSubgenresByGenre(String genre) {
    return _storage.getStringList('$genre$_key') ?? <String>[];
  }

  Future<void> setSubgenresByGenre(String genre, List<String> subgenres) async {
    await _storage.setStringList('$genre$_key', subgenres);
  }

  int getVersion() => _storage.getInt(_versionKey) ?? 0;

  Future<void> setVersion(int version) async {
    await _storage.setInt(_versionKey, version);
  }
}
