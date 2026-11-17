import 'dart:async';
import 'dart:convert';

import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/dtos/level_dto.dart';
import 'package:kingfishertom/core/data/api/models/radio/radio_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class LocalAppInfoDataSource {
  LocalAppInfoDataSource(this._storage);

  final SharedPreferences _storage;

  static const String _genreKey = '_genreKey';
  static const String _subgenreKey = '_subgenreKey';
  static const String _selectedGenreOrSubKey = '_selectedGenreOrSubKey';
  static const String _usePasswordForLoginKey = '_usePasswordForLoginKey';
  static const String _isGenreWithAllWordKey = '_isGenreWithAllWordKey';
  static const String _firstLoginKey = '_firstLoginKey';
  static const String _notificationKey = '_notificationKey';
  static const String _shownSwipeWalkthroughKey = '_shownSwipeWalkthroughKey';

  static const String _radioHistoryKey = '_radioHistoryKey';
  static const String _levelKey = '_levelKey';

  String getGenre() {
    final String? genre = _storage.getString(_genreKey);
    if (genre != null) {
      return genre.toLowerCase();
    }
    return '';
  }

  Future<void> setGenre(String genre) async {
    await _storage.setString(_genreKey, genre.toLowerCase());
  }

  String getSubgenre() => _storage.getString(_subgenreKey) ?? '';

  Future<void> setSubgenre(String subgenre) async {
    await _storage.setString(_subgenreKey, subgenre);
  }

  String getSelectedGenreOrSub() =>
      _storage.getString(_selectedGenreOrSubKey) ?? getGenre();

  Future<void> setSelectedGenreOrSub(String subgenre) async {
    await _storage.setString(_selectedGenreOrSubKey, subgenre);
  }

  bool getUsePasswordForLogin() {
    return _storage.getBool(_usePasswordForLoginKey) ?? false;
  }

  Future<void> setUsePasswordForLogin({
    required bool usePasswordForLogin,
  }) async {
    await _storage.setBool(_usePasswordForLoginKey, usePasswordForLogin);
  }

  Future<void> setFirstSession() async {
    final bool firstLogin = _storage.getBool(_firstLoginKey) ?? false;
    if (firstLogin) return;

    await _storage.setBool(_firstLoginKey, true);
    unawaited(
      FirebaseAnalytics.instance.logEvent(name: 'second_session'),
    );
    if (!kIsWeb) {
      unawaited(FacebookAppEvents().logEvent(name: 'second_session'));
    }
  }

  Future<void> setNotifications({required bool notificationTurn}) async {
    await _storage.setBool(_notificationKey, notificationTurn);
  }

  bool? getNotifications() => _storage.getBool(_notificationKey);

  bool getShownSwipeWalkthrough() {
    return _storage.getBool(_shownSwipeWalkthroughKey) ?? false;
  }

  Future<void> showSwipeWalkthrough() async {
    await _storage.setBool(_shownSwipeWalkthroughKey, true);
  }

  List<RadioDto> getRadioHistory() {
    try {
      return (_storage.getStringList(_radioHistoryKey) ?? <String>[])
          .map((String r) =>
              RadioDto.fromJson(jsonDecode(r) as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _storage.setStringList(_radioHistoryKey, <String>[]);
      return <RadioDto>[];
    }
  }

  Future<void> setRadioHistory(RadioDto radio) async {
    final List<String> list = <String>{
      jsonEncode(radio.toJson()),
      ..._storage.getStringList(_radioHistoryKey) ?? <String>[],
    }.toList();

    await _storage.setStringList(
      _radioHistoryKey,
      list.sublist(0, list.length < 5 ? list.length : 5),
    );
  }

  LevelDto? getCurrentLevel() {
    final String? json = _storage.getString(_levelKey);
    if (json == null) return null;

    return LevelDto.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  Future<void> setCurrentLevel(LevelDto level) async {
    await _storage.setString(_levelKey, jsonEncode(level.toJson()));
  }

  Future<void> clearSharedPreferencesData() async {
    await _storage.clear();
  }

  bool getIsGenreWithAllWord() {
    return _storage.getBool(_isGenreWithAllWordKey) ?? false;
  }

  Future<void> setIsGenreWithAllWord({required bool value}) async {
    await _storage.setBool(_isGenreWithAllWordKey, value);
  }
}
