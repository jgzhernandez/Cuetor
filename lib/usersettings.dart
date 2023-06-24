import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login/signInScreen.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // ListTile(
          //   title: const Text('User Settings'),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const UserSettingsPage(),
          //       ),
          //     );
          //   },
          // ),
          // ListTile(
          //   title: const Text('App Settings'),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const AppSettingsPage(),
          //       ),
          //     );
          //   },
          // ),
          ListTile(
            title: const Text('Logout'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignInScreen()),
                  (route) => false,
                
              );
            },
          ),
        ],
      ),
    );
  }
}
