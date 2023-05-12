import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home.dart';

void main() {
  runApp(
    const CueTor(),
  );
}

class CueTor extends StatelessWidget {
  const CueTor({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CueTor',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const CueTorHomePage(title: 'CueTor: Billiards Trainer'),
    );
  }
}





