import 'package:cuetor/login/sign_in_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      const CueTor(),
    );
    _init();
  });
}

_init() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("userID");
  if (token != null) {
    Get.offAll(() => const CueTorHomePage(title: 'CueTor: Billiards Trainer'));
  } else {
    Get.offAll(() => const SignInScreen());
  }
}

class CueTor extends StatelessWidget {
  const CueTor({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CueTor',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const SignInScreen(),
    );
  }
}
