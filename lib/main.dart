import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'database/database.dart';
import 'global.dart';
import 'notification_manager.dart';
import 'pages/home_page.dart';
import 'training_system.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static NotificationAppLaunchDetails? notificationAppLaunchDetails;

  static var initialization = _init();

  static _init() async {
    // timezone
    tz.initializeTimeZones();
    final String currentTimeZone =
        await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    // notification system
    await NotificationManager.initialization();
    notificationAppLaunchDetails =
        NotificationManager.notificationAppLaunchDetails;

    // database
    await DB.initialization();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // launch by tapping notification?
      if (notificationAppLaunchDetails!.didNotificationLaunchApp) {
        debugPrint(
            'launch by notification. Payload: ${notificationAppLaunchDetails!.payload}');

        // run callback
        NotificationManager.onSelectNotification(
            notificationAppLaunchDetails!.payload);
      }
    });

    // training system
    await TrainingSystem.initialization();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Annoyer',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
        // Locale('ko', ''),
      ],
      theme: ThemeData(
        primarySwatch: Colors.teal,
        // fontFamily: 'Georgia',
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          // headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      navigatorKey: Global.navigatorKey,
      home: FutureBuilder(
        future: initialization,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            debugPrint(snapshot.error.toString());
            return const Text('SomethingWentWrong();');
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            // ordinary launch
            debugPrint('ordinary launch');
            return const HomePage();
          }

          return const Text('Loading...');
        },
      ),
    );
  }
}
