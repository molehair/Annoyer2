// Home provides menus when the user signed in.

import 'package:annoyer/database/practice_instance.dart';
import 'package:annoyer/database/test_instance.dart';
import 'package:annoyer/i18n/strings.g.dart';
import 'package:annoyer/notification_center.dart';
import 'package:annoyer/pages/training_page.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'dictionary_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  bool _showTrainingBadge = false;

  @override
  void initState() {
    // add listener for training badge
    PracticeInstance.getStream().listen(_onInstanceUpdate);
    TestInstance.getStream().listen(_onInstanceUpdate);

    // set badge status
    _updateBadge();

    // launch practice / test page if launched by tapping a notification
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      NotificationAppLaunchDetails? nald = await NotificationCenter
          .flutterLocalNotificationsPlugin
          .getNotificationAppLaunchDetails();
      if (nald != null && nald.didNotificationLaunchApp) {
        //-- launched by tapping --//
        onTapNotification(nald.payload);
      }
    });

    super.initState();
  }

  void _onInstanceUpdate(_) {
    _updateBadge();
  }

  void _updateBadge() async {
    // must be mounted
    if (!mounted) {
      return;
    }

    int pracInstCount = await PracticeInstance.count();
    int testInstCount = await TestInstance.count();

    // update state
    setState(() {
      _showTrainingBadge = (pracInstCount + testInstCount > 0);
    });
  }

  // page setup
  int _index = 0;
  static final List<Widget> _bodies = <Widget>[
    const DictionaryPage(),
    const TrainingPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _bodies.elementAt(_index),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.menu_book_outlined),
            label: t.dictionary,
          ),
          BottomNavigationBarItem(
            icon: Badge(
              showBadge: _showTrainingBadge,
              badgeContent: null,
              child: const Icon(Icons.school_outlined),
            ),
            label: t.training,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_outlined),
            label: t.settings,
          ),
        ],
        currentIndex: _index,
        onTap: (index) => setState(() {
          _index = index;
        }),
      ),
    );
  }
}
