import 'package:hive_flutter/hive_flutter.dart';

import 'word.dart';
import 'settings.dart';
import 'training_data.dart';
import 'dictionary.dart';

class DB {
  static Future<void> initialization() async {
    await Hive.initFlutter();

    // adapters
    Hive.registerAdapter(SettingsAdapter());
    Hive.registerAdapter(WordAdapter());
    Hive.registerAdapter(TrainingDataAdapter());

    // dictionary
    await Dictionary.initialization();
  }
}
