import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const CueTor(),
  );
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
      home: const CueTorHomePage(title: 'CueTor: Billiards Trainer'),
    );
  }
}
