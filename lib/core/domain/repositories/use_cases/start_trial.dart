import 'dart:async';

import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/data_sources/remote.user.data_source.dart';
import 'package:kingfishertom/core/data/local_data/local.app_info.data_source.impl.dart';

@injectable
class StartTrialUseCase {
  StartTrialUseCase(
    this.remoteUserDataSource,
    this.localAppInfoDataSource,
  );

  final RemoteUserDataSource remoteUserDataSource;
  final LocalAppInfoDataSource localAppInfoDataSource;

  Future<void> call() async {
    if (!kIsWeb) unawaited(FacebookAppEvents().logEvent(name: 'started_trial'));
    unawaited(
      FirebaseAnalytics.instance.logEvent(name: 'started_trial'),
    );

    await remoteUserDataSource.startTrial();
  }
}
