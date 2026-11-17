import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:kingfishertom/core/services/di/injection.dart';
import 'package:kingfishertom/core/services/firebase_messaging_service.dart';
import 'package:kingfishertom/firebase_options.dart';

Future<void> firebaseInitializeApp() => Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

Future<void> initFirebaseServices() async {
  final FirebaseApp firebaseApp = Firebase.app();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  getIt.registerSingleton<FirebaseApp>(firebaseApp);
  await firebaseMessaging.getInitialMessage();
  final FirebaseMessagingService fcmService = FirebaseMessagingService(
    firebaseMessaging: firebaseMessaging,
    details: getDefaultNotificationDetails(),
  );

  if (!kIsWeb) {
    await fcmService.init(backgroundMessageHandler: showNotification);
  }

  getIt.registerSingleton<FirebaseMessagingService>(fcmService);
}

// Note: It has to be a top-level function or else it results
// in Exception being thrown
Future<void> showNotification(RemoteMessage message) async {
  /// Ignore, notification will be already shown by FCM under the hood
  if (message.notification != null) return;

  await showLocalNotification(getDefaultNotificationDetails(), message);
}
