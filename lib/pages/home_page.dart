// Home provides menus when the user signed in.

import 'package:flutter/material.dart';

import 'dictionary_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  // page setup
  int _index = 0;
  final List<String> _titles = [
    'Dictionary',
    'Settings',
  ];
  static final List<Widget> _bodies = <Widget>[
    const DictionaryPage(),
    const SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _bodies.elementAt(_index),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.list),
            label: _titles[0],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: _titles[1],
          ),
        ],
        currentIndex: _index,
        onTap: _onItemTapped,
      ),
    );
  }
}
