import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:annoyer/database/local_settings.dart';
import 'package:annoyer/database/word.dart';
import 'package:annoyer/global.dart';
import 'package:annoyer/i18n/strings.g.dart';
import 'package:annoyer/log.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool _alarmEnabled = false;
  TimeOfDay _alarmTime = const TimeOfDay(hour: 0, minute: 0);
  List<bool> _alarmWeekdays = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  @override
  void initState() {
    super.initState();

    _loadSettings();
  }

  _loadSettings() async {
    // alarmEnabled
    bool? ae = await LocalSettings.getAlarmEnabled();
    if (ae == null) {
      ae = false;
      await LocalSettings.setAlarmEnabled(ae);
    }
    _alarmEnabled = ae;

    // alarmTime
    int? ath = await LocalSettings.getAlarmTimeHour();
    int? atm = await LocalSettings.getAlarmTimeMinute();
    if (ath == null || atm == null) {
      ath = 9;
      atm = 0;
      await LocalSettings.setAlarmTimeHour(ath);
      await LocalSettings.setAlarmTimeMinute(atm);
    }
    _alarmTime = TimeOfDay(
      hour: ath,
      minute: atm,
    );

    // alarmWeekdays
    List<bool>? aw = await LocalSettings.getAlarmWeekdays();
    if (aw == null) {
      aw = [false, false, false, false, false, false, false];
      await LocalSettings.setAlarmWeekdays(aw);
    }
    _alarmWeekdays = aw;

    // update the state
    setState(() {});
  }

  Future<void> _alarmSwitch(bool newAlarmEnabled) async {
    try {
      // update db
      await LocalSettings.setAlarmEnabled(newAlarmEnabled);

      // log
      Log.info('newAlarmEnabled: $newAlarmEnabled');

      // update the state
      setState(() {
        _alarmEnabled = newAlarmEnabled;
      });
    } on Exception catch (e) {
      Log.error('_alarmSwitch in SettingsPage', exception: e);
      Global.showFailure();
    }
  }

  Future<void> _pickAlarmTime(BuildContext context) async {
    // get time from the user
    TimeOfDay? newAlarmTime = await showTimePicker(
      initialTime: _alarmTime,
      context: context,
    );

    try {
      if (newAlarmTime != null) {
        // update db
        await LocalSettings.setAlarmTimeHour(newAlarmTime.hour);
        await LocalSettings.setAlarmTimeMinute(newAlarmTime.minute);

        // log
        Log.info('newAlarmTime: $newAlarmTime');

        // update the state
        setState(() {
          _alarmTime = newAlarmTime;
        });
      }
    } on Exception catch (e) {
      Log.error('_onAlarmTimeChange in SettingsPage', exception: e);
      Global.showFailure();
    }
  }

  _toggleWeekday(BuildContext context, int weekday) async {
    try {
      assert(0 <= weekday && weekday < 7);

      // create new alarm weekdays
      List<bool> newAlarmWeekdays = List.from(_alarmWeekdays);
      newAlarmWeekdays[weekday] = !(newAlarmWeekdays[weekday]);

      // update db
      await LocalSettings.setAlarmWeekdays(newAlarmWeekdays);

      // log
      Log.info('newAlarmWeekdays: $newAlarmWeekdays');

      // update the state
      setState(() {
        _alarmWeekdays = newAlarmWeekdays;
      });
    } on Exception catch (e) {
      Log.error('_toggleWeekday in SettingsPage', exception: e);
      Global.showFailure();
    }
  }

  void _backup() async {
    try {
      // make a backup list
      List<Word> words = await Word.getAll();

      if (words.isEmpty) {
        //-- no word to backup --//
        Global.showMessage(
          msg: 'You have no word!',
          type: ShowMessageType.error,
        );
      } else {
        //-- do backup --//
        // convert words to map
        var wordsMap = words.map((e) {
          var m = e.toMap();
          m.remove('uid');
          m.remove('docId');
          return m;
        }).toList();

        // save the backup list to a file
        final Directory directory = await getApplicationDocumentsDirectory();
        File backupFile = File('${directory.path}/$backupFilename');
        await backupFile.writeAsString(jsonEncode(wordsMap));

        // share the file
        await Share.shareFiles([backupFile.path]);

        // delete the backup file
        await backupFile.delete();
      }
    } on Exception catch (e) {
      Log.error('_backup in SettingsPage', exception: e);
      Global.showFailure();
    }
  }

  void _restore() async {
    try {
      // let the user pick the file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        allowMultiple: false,
      );

      if (result != null) {
        //-- User selected a file --//

        // read from file
        final File file = File(result.files.single.path!);
        final String backupJson = await file.readAsString();
        final List<dynamic> backup = jsonDecode(backupJson);

        // prepare as Word
        final List<Word> words = backup.map((e) => Word.fromMap(e)).toList();

        // restore to the database
        // chunk into the maximum 500 bulk writes
        List<Future> futures = [];
        for (int i = 0; i < words.length; i += 500) {
          futures
              .add(Word.addAll(words.sublist(i, min(i + 500, words.length))));
        }
        await Future.wait(futures);

        // show success indicator
        Global.showSuccess();
      }
    } on PlatformException catch (e) {
      // Permission required
      if (e.code == 'read_external_storage_denied') {
        Global.showMessage(
          msg: t.storagePermissionRequired,
          type: ShowMessageType.error,
        );
      }
    } on Exception catch (e) {
      Log.error('_restore in SettingsPage', exception: e);
      Global.showFailure();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onLongPress: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const DebugPage()));
          },
          child: Text(t.settings),
        ),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text(t.training),
            dense: true,
            trailing: Switch(
              value: _alarmEnabled,
              onChanged: _alarmSwitch,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.alarm_outlined),
            title: TextButton(
              onPressed: _alarmEnabled ? () => _pickAlarmTime(context) : null,
              child: Text(_alarmTime.format(context)),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.event_outlined),
            title: Wrap(
              children: [
                t.sun,
                t.mon,
                t.tue,
                t.wed,
                t.thu,
                t.fri,
                t.sat,
              ].asMap().entries.map((entry) {
                return TextButton(
                  onPressed: _alarmEnabled
                      ? () => _toggleWeekday(context, entry.key)
                      : null,
                  child: Text(
                    entry.value,
                    style: _alarmEnabled
                        ? (TextStyle(
                            color: _alarmWeekdays[entry.key]
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.background,
                            fontWeight: _alarmWeekdays[entry.key]
                                ? FontWeight.bold
                                : null,
                          ))
                        : null,
                  ),
                );
              }).toList(),
              alignment: WrapAlignment.center,
              spacing: 10.0,
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(t.dataManagement),
            dense: true,
          ),
          // ListTile(
          //   leading: const Icon(Icons.sync_outlined),
          //   title: Text('sync'.tr()),
          //   onTap: () async {
          //   },
          // ),
          ListTile(
            leading: const Icon(Icons.backup_outlined),
            title: Text(t.backup),
            onTap: _backup,
          ),
          ListTile(
            leading: const Icon(Icons.restore_outlined),
            title: Text(t.restore),
            onTap: _restore,
          ),
          const Divider(),
          Visibility(
            visible: kDebugMode,
            child: ListTile(
              title: const Text('DEBUG'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const DebugPage()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
