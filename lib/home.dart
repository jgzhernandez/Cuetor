import 'package:cuetor/training.dart';
import 'package:cuetor/user_settings.dart';
import 'package:cuetor/user_stats.dart';
import 'package:flutter/material.dart';

class CueTorHomePage extends StatefulWidget {
  const CueTorHomePage({super.key, required this.title});

  final String title;

  @override
  State<CueTorHomePage> createState() => _CueTorHomePageState();
}

class _CueTorHomePageState extends State<CueTorHomePage> {
  int _selectedIndex = 1;

  static const List<Widget> _widgetOptions = <Widget>[
    StatisticsPage(),
    TrainingPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Image.asset('images/logo.png', fit: BoxFit.contain, height: 32),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueGrey[900],
        title: const Center(
          child: Text('CueTor'),
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blueGrey[900],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Training',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
