import 'dart:convert';
import 'dart:io';

import 'package:annoyer/database/dictionary.dart';
import 'package:annoyer/database/settings.dart';
import 'package:annoyer/database/word.dart';
import 'package:annoyer/global.dart';
import 'package:annoyer/training_system.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'debug_page.dart';

const backupFilename = 'backup.json';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
  Settings _settings = Settings();

  _loadSettings() async {
    // load settings
    Box<Settings> box = await Hive.openBox<Settings>(Settings.boxName);
    _settings = box.get(Settings.key) ?? Settings();

    // turn off alarm if it's not available
    if (_settings.alarmEnabled) {
      String? errorMsg = await TrainingSystem.checkAvailability();
      if (errorMsg != null) {
        _settings.alarmEnabled = false;
        Global.showMessage(msg: errorMsg, type: ShowMessageType.error);
      }
    }

    // update the state
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _loadSettings();
  }

  Future<void> _alarmSwitch(bool newAlarmEnabled) async {
    try {
      // check if it's available
      if (newAlarmEnabled) {
        String? errorMsg = await TrainingSystem.checkAvailability();
        if (errorMsg != null) {
          Global.showMessage(msg: errorMsg, type: ShowMessageType.error);
          return;
        }
      }

      // set the new settings
      Settings newSettings = Settings.from(_settings);
      newSettings.alarmEnabled = newAlarmEnabled;

      // update alarms
      final List<Future> futures = [];
      if (newAlarmEnabled) {
        // set the schedules
        for (int weekday = 0; weekday < 7; weekday++) {
          if (newSettings.alarmWeekdays[weekday]) {
            TimeOfDay time = TimeOfDay(
              hour: newSettings.alarmTimeHour,
              minute: newSettings.alarmTimeMinute,
            );
            futures.add(TrainingSystem.setAlarm(time, weekday));
          } else {
            futures.add(TrainingSystem.cancelAlarm(weekday));
          }
        }
      } else {
        // cancel all alarms
        for (int weekday = 0; weekday < 7; weekday++) {
          futures.add(TrainingSystem.cancelAlarm(weekday));
        }
      }
      await Future.wait(futures);

      // save to local storage
      Box<Settings> box = await Hive.openBox<Settings>(Settings.boxName);
      await box.put(Settings.key, newSettings);

      // update the state
      setState(() {
        _settings = newSettings;
      });
    } on Exception catch (e) {
      debugPrint(e.toString());
    } finally {}
  }

  _pickAlarmTime(BuildContext context) async {
    // get alarm time
    TimeOfDay? alarmTimeSelected = await showTimePicker(
      initialTime: TimeOfDay(
        hour: _settings.alarmTimeHour,
        minute: _settings.alarmTimeMinute,
      ),
      context: context,
    );

    // Did user chose the time?
    if (alarmTimeSelected != null) {
      try {
        // set the new settings
        Settings newSettings = Settings.from(_settings);
        newSettings.alarmTimeHour = alarmTimeSelected.hour;
        newSettings.alarmTimeMinute = alarmTimeSelected.minute;

        // reschedule
        if (_settings.alarmEnabled) {
          for (int weekday = 0; weekday < 7; weekday++) {
            if (newSettings.alarmWeekdays[weekday]) {
              await TrainingSystem.setAlarm(alarmTimeSelected, weekday);
            }
          }
        }

        // save to the local storage
        Box<Settings> box = await Hive.openBox<Settings>(Settings.boxName);
        await box.put(Settings.key, newSettings);

        // update state
        setState(() {
          _settings = newSettings;
        });
      } on Exception catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  _toggleWeekday(BuildContext context, int weekday) async {
    try {
      // set the new settings
      Settings newSettings = Settings.from(_settings);
      newSettings.alarmWeekdays[weekday] = !newSettings.alarmWeekdays[weekday];

      if (newSettings.alarmEnabled && newSettings.alarmWeekdays[weekday]) {
        // reschedule
        await TrainingSystem.setAlarm(
          TimeOfDay(
            hour: newSettings.alarmTimeHour,
            minute: newSettings.alarmTimeMinute,
          ),
          weekday,
        );
      } else {
        // cancel
        await TrainingSystem.cancelAlarm(weekday);
      }

      // save to the local storage
      Box<Settings> box = await Hive.openBox<Settings>(Settings.boxName);
      await box.put(Settings.key, newSettings);

      // update state
      setState(() {
        _settings = newSettings;
      });
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  void _backup() async {
    try {
      // make a backup list
      final Box<Word> box = await Hive.openBox<Word>(Dictionary.boxName);
      final List backup = [];
      for (Word word in box.values) {
        backup.add(word.toMap());
      }

      if (backup.isEmpty) {
        Global.showMessage(
          msg: 'You have no word!',
          type: ShowMessageType.error,
        );
      } else {
        // save the backup list to a file
        final Directory directory = await getApplicationDocumentsDirectory();
        File backupFile = File('${directory.path}/$backupFilename');
        await backupFile.writeAsString(jsonEncode(backup));

        // share the file
        await Share.shareFiles([backupFile.path]);

        // delete the backup file
        await backupFile.delete();
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  void _restore() async {
    try {
      // let the user pick the file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null) {
        //-- User selected a file --//

        // read from file
        final File file = File(result.files.single.path!);
        final String backupJson = await file.readAsString();
        final List<dynamic> backup = jsonDecode(backupJson);

        // prepare as Word
        final List<Word> words = [];
        for (Map<String, dynamic> map in backup) {
          try {
            words.add(Word.fromMap(map));
          } on Exception catch (e) {
            debugPrint(e.toString());
          }
        }

        // restore to the database
        final Box<Word> box = await Hive.openBox<Word>(Dictionary.boxName);
        await box.addAll(words);

        // show success indicator
        Global.showSuccess();
      }
    } on PlatformException catch (e) {
      if (e.code == 'read_external_storage_denied') {
        Global.showMessage(
          msg: AppLocalizations.of(context)!.storagePermissionRequired,
          type: ShowMessageType.error,
        );
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settings)),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text(AppLocalizations.of(context)!.alarm),
            dense: true,
            trailing: Switch(
              value: _settings.alarmEnabled,
              onChanged: _alarmSwitch,
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.alarm_outlined),
              title: TextButton(
                onPressed: _settings.alarmEnabled
                    ? () => _pickAlarmTime(context)
                    : null,
                child: Text(
                  TimeOfDay(
                    hour: _settings.alarmTimeHour,
                    minute: _settings.alarmTimeMinute,
                  ).format(context),
                ),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.event_outlined),
              title: Wrap(
                children: [
                  AppLocalizations.of(context)!.sun,
                  AppLocalizations.of(context)!.mon,
                  AppLocalizations.of(context)!.tue,
                  AppLocalizations.of(context)!.wed,
                  AppLocalizations.of(context)!.thu,
                  AppLocalizations.of(context)!.fri,
                  AppLocalizations.of(context)!.sat,
                ].asMap().entries.map((entry) {
                  return TextButton(
                    onPressed: _settings.alarmEnabled
                        ? () => _toggleWeekday(context, entry.key)
                        : null,
                    child: Text(
                      entry.value,
                      style: _settings.alarmEnabled
                          ? (TextStyle(
                              color: _settings.alarmWeekdays[entry.key]
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey,
                            ))
                          : null,
                    ),
                  );
                }).toList(),
                alignment: WrapAlignment.center,
                spacing: 10.0,
              ),
            ),
          ),
          // const ListTile(
          //   title: Text(
          //     'Sync',
          //   ),
          //   dense: true,
          // ),

          ListTile(
            title: Text(
                '${AppLocalizations.of(context)!.backup}/${AppLocalizations.of(context)!.restore}'),
            dense: true,
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.backup_outlined),
              title: Text(AppLocalizations.of(context)!.backup),
              onTap: _backup,
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.restore_outlined),
              title: Text(AppLocalizations.of(context)!.restore),
              onTap: _restore,
            ),
          ),

          Visibility(
            visible: kDebugMode,
            child: ListTile(
              title: const Text('DEBUG'),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => DebugPage()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
