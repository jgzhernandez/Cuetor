import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuetor/resultsList/ball_pocketing_list.dart';
import 'package:cuetor/resultsList/stop_shot_list.dart';
import 'package:cuetor/resultsList/wagon_wheel_list.dart';
import 'package:cuetor/videoGallery/ball_pocketing_video_gallery.dart';
import 'package:cuetor/videoGallery/stop_shot_video_gallery.dart';
import 'package:cuetor/videoGallery/wagon_wheel_video_gallery.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

Future<double> _getScore(String collection) async {
  double acc = 0;
  int totalSessions = 0;
  await FirebaseFirestore.instance
      .collection('${collection}_results')
      .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
      .get()
      .then((QuerySnapshot query) {
    for (var doc in query.docs) {
      acc += doc['score'];
      totalSessions++;
    }
  });
  double accuracyTemp = acc / (totalSessions * 10);
  return accuracyTemp * 100;
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  void initState() {
    super.initState();
    var stop_shot_acc = _getScore('stop_shot');
    var ball_pocketing_acc = _getScore('ball_pocketing');
    var wagon_wheel_acc = _getScore('wagon_wheel');
  }

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
              // User Profile
              const Text('Profile'),
              // display name
              Row(
                children: [
                  const Text('User: '),
                  Text(FirebaseAuth.instance.currentUser?.displayName ?? ''),
                ],
              ),
              // email
              Row(
                children: [
                  const Text('Email: '),
                  Text(FirebaseAuth.instance.currentUser?.email ?? ''),
                ],
              ),
              // player rating
              Row(
                children: [
                  const Text('Player  Rating: '),
                  FutureBuilder<String>(
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        String rating = snapshot.data ?? '';
                        return Text(rating);
                      }
                    },
                  )
                ],
              ),
              const Divider(),

              // User Statistics
              const Text('Statistics'),
              // stop shot
              FutureBuilder<double>(
                future: _getScore('stop_shot'),
                builder:
                    (BuildContext context, AsyncSnapshot<double> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    double accuracy = snapshot.data ?? 0.0;
                    return ListTile(
                      title: Text('Stop Shot Accuracy: $accuracy %'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StopShotList(),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
              // ball pocketing
              FutureBuilder<double>(
                future: _getScore('ball_pocketing'),
                builder:
                    (BuildContext context, AsyncSnapshot<double> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    double accuracy = snapshot.data ?? 0.0;
                    return ListTile(
                      title: Text('Ball Pocketing Accuracy: $accuracy %'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BallPocketingList(),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
              // wagon wheel
              FutureBuilder<double>(
                future: _getScore('wagon_wheel'),
                builder:
                    (BuildContext context, AsyncSnapshot<double> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    double accuracy = snapshot.data ?? 0.0;
                    return ListTile(
                      title: Text('Wagon Wheel Accuracy: $accuracy %'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WagonWheelList(),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
              const Divider(),

              // Video Gallery
              const Text('Videos'),
              // Stop Shot
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
              // Ball Pocketing
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
              // Wagon Wheel
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
