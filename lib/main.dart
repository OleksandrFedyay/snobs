import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kingfishertom/core/data/local_data/local.app_info.data_source.impl.dart';
import 'package:kingfishertom/core/services/di/firebase_di.dart';
import 'package:kingfishertom/core/services/di/injection.dart';
import 'package:kingfishertom/core/services/purchases/purchases_cat.dart';
import 'package:kingfishertom/features/app/app.dart';
import 'package:kingfishertom/features/presentation/common_pages/audio_player/cubit/tracks_audio_player_cubit.dart';
import 'package:kingfishertom/features/presentation/resources/strings_res.dart';
import 'package:kingfishertom/features/utils/cubit_watcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(
      <DeviceOrientation>[DeviceOrientation.portraitUp]);
  if (!kIsWeb) await MobileAds.instance.initialize();

  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  if (kReleaseMode) {
    await SentryFlutter.init(
      (SentryFlutterOptions options) {
        options
          ..dsn = StringsRes.sentryDSN
          ..release = '${packageInfo.version}(${packageInfo.buildNumber})';
      },
      appRunner: initApp,
    );
  } else {
    await initApp();
  }
}

Future<void> initApp() async {
  await configureGitItDependencies();

  tz.initializeTimeZones();
  final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));

  await firebaseInitializeApp();
  await initFirebaseServices();
  await getIt<LocalAppInfoDataSource>().setFirstSession();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  await getIt<PurchasesCat>().configure();
  Bloc.observer = CubitWatcher();

//Todo(Issa): need to use another approach for Player!
  runApp(
    MultiProvider(
      providers: <SingleChildWidget>[
        BlocProvider<TrackAudioPlayerCubit>(
            create: (_) => TrackAudioPlayerCubit.create()),
      ],
      child: const Snobs(),
    ),
  );
}
