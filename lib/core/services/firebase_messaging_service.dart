// ignore_for_file: always_specify_types
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kingfishertom/l10n/generated/snobs_app_localizations_en.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

typedef MessageHandler = Future<void> Function(RemoteMessage);

const List<String> messages = <String>[
  "Let's discover music together! 🧭",
  'Time to explore music! ⏰',
  'Continue your musical journey! 🗺️',
  "It's swipe time! 👏",
];

NotificationDetails getDefaultNotificationDetails() {
  return getNotificationDetailsByChannel(
    channelId: 'snob_high_importance_channel',
    channelName: 'Snob Channel',
    channelDescription:
        'This channel is used for important notifications of SNOB App',
  );
}

NotificationDetails getNotificationDetailsByChannel({
  required String channelId,
  required String channelName,
  required String channelDescription,
}) {
  final AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    channelId,
    channelName,
    channelDescription: channelDescription,
    importance: Importance.max,
    priority: Priority.max,
    showWhen: false,
    visibility: NotificationVisibility.public,
    fullScreenIntent: true,
    styleInformation: const BigTextStyleInformation(''),
  );

  final NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );
  return platformChannelSpecifics;
}

FlutterLocalNotificationsPlugin _notificationPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> showLocalNotification(
  NotificationDetails details,
  RemoteMessage message,
) async {
  final Map? parsedMessageMap =
      json.decode(message.data['message'] as String? ?? '{}') as Map?;
  final String? messageString =
      (parsedMessageMap?['notification'] as Map?)?['message'] as String?;

  await _notificationPlugin.show(
    0,
    message.notification?.title ??
        SnobsAppLocalizationsEn().snobs.toUpperCase(),
    messageString ?? message.notification?.body,
    details,
  );
}

Future<void> showLocalNotificationInDate(tz.TZDateTime date) async {
  try {
    final int id = math.Random().nextInt(messages.length);
    await _notificationPlugin.zonedSchedule(
      id,
      'SNOBS',
      messages[id],
      date,
      getDefaultNotificationDetails(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exact,
    );
  } on PlatformException catch (e) {
    await Permission.scheduleExactAlarm.request();
    log(e.toString());
  }
}

/// This service is used for managing the Firebase Messages.
/// To use it, a `GlobalKey` has to be provided as well
/// as a `NotificationDetails` for defining a Notification Channel to
/// use (Android).
///
/// Set the minSdkVersion to 21 for Android and add the following lines to the
/// end of `<application ...>` section
/// in `example/android/app/src/main/AndroidManifest.xml`.
/// ```
/// <meta-data
///         android:name="com.google.firebase.messaging.default_notification_channel_id"
///         android:value="snob_high_importance_channel" />
/// ```
///
/// `"snob_high_importance_channel"` should be changed to your app's channel ID.
///
/// ```
class FirebaseMessagingService {
  FirebaseMessagingService({
    required this.firebaseMessaging,
    required this.details,
  }) {
    notificationDetails = details;
  }

  static NotificationDetails? notificationDetails;

  final FirebaseMessaging firebaseMessaging;
  final NotificationDetails details;

  Future<void> init({required MessageHandler backgroundMessageHandler}) async {
    try {
      await firebaseMessaging.requestPermission();
      await firebaseMessaging.setAutoInitEnabled(true);
      await firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        sound: true,
        badge: true,
      );

      final bool? status = await _initializeSettings();

      log('STATUS PLUGIN INIT =====> $status');

      if (Platform.isAndroid) {
        await _createAndroidNotificationChannel();
      }

      _initializeFcmListeners(backgroundMessageHandler);

      final String? token = await firebaseMessaging.getToken();

      log(token ?? 'No Token!', name: 'Token');
    } catch (exception) {
      log('Notification Error:', error: exception);
    }
  }

  Future<bool?> _initializeSettings() {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    return _notificationPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> _createAndroidNotificationChannel() async {
    final AndroidNotificationChannel channel = AndroidNotificationChannel(
      details.android!.channelId,
      details.android!.channelName,
      description: details.android!.channelDescription,
      importance: Importance.max,
    );

    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidImplementation?.createNotificationChannel(channel);
  }

  void _initializeFcmListeners(MessageHandler backgroundMessageHandler) {
    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (!kIsWeb) {
        unawaited(FacebookAppEvents().logEvent(name: 'notification_click'));
      }
      unawaited(
        FirebaseAnalytics.instance.logEvent(name: 'notification_click'),
      );
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showLocalNotification(details, message);
    });
  }
}
