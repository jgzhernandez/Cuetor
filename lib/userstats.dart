import 'package:cuetor/videoGallery/stopShotVideoGalleryPage.dart';
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
              // const SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   padding: EdgeInsets.all(20),
              //   child: Text(
              //     'Profile',
              //     style: TextStyle(fontSize: 30),
              //   ),
              // ),
              const Text('Stop Shot Videos'),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StopShotVideoGalleryPage(),
                    ),
                  );
                },
                title: const Text('Stop Shot Videos: '),
                // trailing: Text('0'),
              ),
              // SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
