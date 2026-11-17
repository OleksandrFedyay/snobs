import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/data/local_data/user_model_stream.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/complete_task.use_case.dart';
import 'package:kingfishertom/core/services/di/injection.dart';

@injectable
class StreakUseCase {
  StreakUseCase(
    this.completeTaskUseCase,
  );

  final CompleteTaskUseCase completeTaskUseCase;

  Future<void> call(int streak) async {
    final UserModel? user = await getIt<UserModelStream>().getUserModel();
    if (user == null) return;

    if (streak == 2) {
      await completeTaskUseCase('2dayswipestreak');
    } else if (streak == 4) {
      await completeTaskUseCase('4dayswipestreak');
    } else if (streak == 5) {
      await completeTaskUseCase('5dayswipestreak');
    } else if (streak == 9) {
      await completeTaskUseCase('9dayswipestreak');
    } else if (streak == 15) {
      await completeTaskUseCase('15dayswipestreak');
    }
  }
}
