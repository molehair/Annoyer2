import 'package:annoyer/background_worker.dart';
import 'package:annoyer/database/database.dart';
import 'package:annoyer/notification_center.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'database/word.dart';
import 'firebase_options.dart';
import 'global.dart';
import 'i18n/strings.g.dart';
import 'log.dart';
import 'pages/home_page.dart';
import 'sync.dart';
import 'training.dart';

Future<void> initialization() async {
  // The initialization order must be maintained.

  // local database
  await Database.initialization();
  logger.i('Initialized Local Database');

  // firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  logger.i('Initialized Firebase');

  // background worker
  await BackgroundWorker.initialization();
  logger.i('Initialized Background worker');

  // sync
  await Sync.initialization();
  logger.i('Initialized Sync');

  // notification center
  await NotificationCenter.initialization();
  logger.i('Initialized Notification center');

  // word
  await Word.initialization();
  logger.i('Initialized Word');

  // training system
  await Training.initialization();
  logger.i('Initialized Training');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  LocaleSettings.useDeviceLocale();
  runApp(TranslationProvider(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static final _initialization = initialization();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Annoyer',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        // fontFamily: 'Georgia',
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          // headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      navigatorKey: Global.navigatorKey,
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            debugPrint(snapshot.error.toString());
            return const Text('SomethingWentWrong();');
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return const HomePage();
          }

          return const Text('Loading...');
        },
      ),
    );
  }
}
