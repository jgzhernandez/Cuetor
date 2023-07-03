import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login/sign_in_screen.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('About'),
            leading: const Icon(Icons.info),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AboutDialog(
                  applicationName: 'CueTor',
                  applicationVersion: '1.0.0',
                  applicationIcon: Image.asset('images/logo.png',
                      height: 48, width: 48, fit: BoxFit.contain),
                  children: const [
                    Text(
                        'CueTor is a billiards training app that uses computer vision through YOLOv5.'
                        '\n\nThis app was developed by the following students of the University of the Philippines Diliman:'
                        '\n -Jared Arbolado'
                        '\n -Jett Hernandez'
                        '\n -Kobe Rivera'),
                  ],
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Logout'),
            leading: const Icon(Icons.logout),
            onTap: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Logout'),
                    content: const Text('Are you sure you want to log out?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Logout'),
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.clear();
                          if (context.mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignInScreen(),
                              ),
                              (route) => false,
                            );
                          }
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
