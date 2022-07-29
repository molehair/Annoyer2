import 'package:annoyer/database/local_settings.dart';
import 'package:annoyer/database/training_instance.dart';
import 'package:annoyer/database/training_data.dart';
import 'package:annoyer/database/word.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class Database {
  //---------------------------------------------------------------//
  //        instance variables
  //---------------------------------------------------------------//

  //---------------------------------------------------------------//
  //        static variables
  //---------------------------------------------------------------//

  /// Initialized this class?
  static bool _inited = false;

  // isar instance
  static late Isar isar;

  //---------------------------------------------------------------//
  //        exported methods
  //---------------------------------------------------------------//

  static Future<void> initialization() async {
    // init only once
    if (_inited) {
      return;
    }

    final dir = await getApplicationSupportDirectory();

    isar = await Isar.open(
      schemas: [
        WordSchema,
        TrainingInstanceSchema,
        TrainingDataSchema,
        LocalSettingsSchema,
      ],
      directory: dir.path,
    );

    // mark as finished initialization
    _inited = true;
  }

  //---------------------------------------------------------------//
  //        internal methods
  //---------------------------------------------------------------//
}
