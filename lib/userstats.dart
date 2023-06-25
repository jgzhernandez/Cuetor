import 'package:cuetor/videoGallery/ballPocketingVideoGallery.dart';
import 'package:cuetor/videoGallery/stopShotVideoGallery.dart';
import 'package:cuetor/videoGallery/wagonWheelVideoGallery.dart';
import 'package:flutter/material.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profile, Statistics, and Videos'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text('Profile'),
              const Divider(),
              const Text('Statistics'),
              const Divider(),
              const Text('Videos'),
              ListTile(
                title: const Text('Stop Shot Videos'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StopShotVideoGallery(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('Ball Pocketing Videos'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BallPocketingVideoGallery(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('Wagon Wheel Videos'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WagonWheelVideoGallery(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
