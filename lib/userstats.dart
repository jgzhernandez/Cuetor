import 'package:cuetor/resultsList/ballPocketingList.dart';
import 'package:cuetor/resultsList/stopShotList.dart';
import 'package:cuetor/resultsList/wagonWheelList.dart';
import 'package:cuetor/videoGallery/ballPocketingVideoGallery.dart';
import 'package:cuetor/videoGallery/stopShotVideoGallery.dart';
import 'package:cuetor/videoGallery/wagonWheelVideoGallery.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

Future<double> _getStopShotScore() async {

  double acc = 0;
  int totalsessions = 0;
  await FirebaseFirestore.instance.collection('stop_shot_results').where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid).get().then((QuerySnapshot query){
     for (var doc in query.docs){
      acc += doc['score'];
      totalsessions++;
   };
  }
  );
  double accuracytemp = acc / (totalsessions*10);
  return accuracytemp*100;


}


class _StatisticsPageState extends State<StatisticsPage> {
  @override
    void initState() {
    super.initState();
    _getStopShotScore();
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
              const Text('Profile'),
              const Divider(),
              const Text('Statistics'),
//GET VALUE
//               StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('stop_shot_results').where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
//             .snapshots(),
//         builder: (context, snapshot) {
//           final videos = snapshot.data?.docs;
//           for (DocumentSnapshot docs in videos?){

//           }

// },),


//GETVALUE
              // Stop Shot Accuracy
              FutureBuilder<double>(
                future: _getStopShotScore(),
                builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
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
              ListTile(
                title: Text('Ball Pocketing Accuracy: %'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BallPocketingList(),
                    ),
                  );
                }
              ),
              ListTile(
                title: Text('Wagon Wheel Accuracy: %'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WagonWheelList(),
                    ),
                  );
                }
              ),
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