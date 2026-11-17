import 'dart:async';

import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/dtos/level_dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/tasks_dto.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/data/data_sources/remote.user.data_source.dart';
import 'package:kingfishertom/core/data/local_data/user_model_stream.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_app_user_level.use_case.dart';
import 'package:kingfishertom/core/services/di/injection.dart';
import 'package:kingfishertom/features/utils/extensions/extensions.dart';

@injectable
class CompleteTaskUseCase {
  CompleteTaskUseCase(
    this.remoteUserDataSource,
    this.getLevelUseCase,
  );

  final RemoteUserDataSource remoteUserDataSource;
  final GetAppUserLevelUseCase getLevelUseCase;

  Future<void> call(String id) async {
    final Map<LevelValueType, Object> levelUseCase = await getLevelUseCase();
    final LevelDto level = levelUseCase[LevelValueType.levelData]! as LevelDto;
    TasksDto? task;
    for (final TasksDto t in level.tasks) {
      if (t.id == id) {
        task = t;
      }
    }
    if (task == null) return;

    final UserModel? user = await getIt<UserModelStream>().getUserModel();
    if (user == null) return;
    if (user.completedTasks.contains(id)) return;

    final List<String> taskIds = <String>[...user.completedTasks, id];
    final int xp = user.levelXp + task.xp;
   /// await remoteUserDataSource.completeTask(taskIds, xp);
    await getIt<UserModelStream>().updateSaveUserModel(
      user.update(
        completedTasks: taskIds,
        levelXp: xp,
      ),
    );

    if (xp >= level.xp) {
      final String eventName = 'rank_${level.xp.rankNextLevel}';
      unawaited(FirebaseAnalytics.instance.logEvent(name: eventName));
      if (!kIsWeb) unawaited(FacebookAppEvents().logEvent(name: eventName));
    }
  }
}
