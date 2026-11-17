import 'dart:async';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/dtos/swipe.dto.dart';
import 'package:kingfishertom/core/services/firebase_messaging_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

@LazySingleton()
class LocalSwipesDataSource {
  LocalSwipesDataSource(this._storage);

  final SharedPreferences _storage;

  static const String _lastSwipeTimeKey = '_lastSwipeTimeKey';
  static const String _swipesStreakKey = '_swipesStreakKey';
  static const String _daySwipesCountKey = '_daySwipesCountKey';

  Future<SwipeDto> addSwipe(
    ValueSetter<int> addStreak,
    ValueSetter<int> onChangedStreak,
  ) async {
    final SwipeDto swipe = SwipeDto(
      lastSwipeTime: _storage.getInt(_lastSwipeTimeKey) ?? 0,
      swipesStreak: _storage.getInt(_swipesStreakKey) ?? 1,
      daySwipesCount: _storage.getInt(_daySwipesCountKey) ?? 0,
    );

    final tz.TZDateTime nowDate = tz.TZDateTime.now(tz.local);
    final tz.TZDateTime lastSwipeDate =
        tz.TZDateTime.fromMicrosecondsSinceEpoch(
      tz.local,
      swipe.lastSwipeTime,
    );
    await _showNotifications(nowDate.microsecondsSinceEpoch);
    SwipeDto res = swipe;
    if (nowDate.difference(lastSwipeDate) >= const Duration(days: 2)) {
      res = SwipeDto(
        daySwipesCount: 1,
        lastSwipeTime: nowDate.microsecondsSinceEpoch,
        swipesStreak: 1,
      );
      onChangedStreak(1);
      await _showNotifications(nowDate.microsecondsSinceEpoch);
    } else if (nowDate.difference(lastSwipeDate) >= const Duration(days: 1)) {
      final int streak = swipe.swipesStreak + 1;
      res = SwipeDto(
        daySwipesCount: 1,
        lastSwipeTime: nowDate.microsecondsSinceEpoch,
        swipesStreak: streak,
      );
      addStreak(streak);
      onChangedStreak(streak);
      await _showNotifications(nowDate.microsecondsSinceEpoch);
    } else {
      res = SwipeDto(
        daySwipesCount: swipe.daySwipesCount + 1,
        lastSwipeTime: swipe.lastSwipeTime,
        swipesStreak: swipe.swipesStreak,
      );
    }

    await _storage.setInt(_lastSwipeTimeKey, res.lastSwipeTime);
    await _storage.setInt(_swipesStreakKey, res.swipesStreak);
    await _storage.setInt(_daySwipesCountKey, res.daySwipesCount);
    return res;
  }

  Future<void> _showNotifications(int swipeTime) async {
    final tz.TZDateTime lastSwipeTime = tz.TZDateTime.from(
      DateTime.fromMicrosecondsSinceEpoch(swipeTime),
      tz.local,
    );

    await showLocalNotificationInDate(
      lastSwipeTime.add(const Duration(days: 1)),
    );
    unawaited(
      showLocalNotificationInDate(
        lastSwipeTime.add(const Duration(days: 2)),
      ),
    );
    unawaited(
      showLocalNotificationInDate(
        lastSwipeTime.add(const Duration(days: 3)),
      ),
    );
    unawaited(
      showLocalNotificationInDate(
        lastSwipeTime.add(const Duration(days: 4)),
      ),
    );
  }

  Future<SwipeDto> getSwipeInfo() async {
    final SwipeDto swipe = SwipeDto(
      lastSwipeTime: _storage.getInt(_lastSwipeTimeKey) ?? 0,
      swipesStreak: _storage.getInt(_swipesStreakKey) ?? 0,
      daySwipesCount: _storage.getInt(_daySwipesCountKey) ?? 0,
    );

    final tz.TZDateTime nowDate = tz.TZDateTime.now(tz.local);
    final tz.TZDateTime lastSwipeDate =
        tz.TZDateTime.fromMicrosecondsSinceEpoch(
      tz.local,
      swipe.lastSwipeTime,
    );
    if (nowDate.difference(lastSwipeDate) >= const Duration(days: 1)) {
      return swipe.copyWith(daySwipesCount: 0);
    }

    return swipe;
  }
}
