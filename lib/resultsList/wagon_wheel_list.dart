import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuetor/videoGallery/video_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class WagonWheelList extends StatefulWidget {
  const WagonWheelList({super.key});

  @override
  State<WagonWheelList> createState() => _WagonWheelListState();
}

class _WagonWheelListState extends State<WagonWheelList> {
  Future<void> _deleteVideo(String videoId, String videoUrl) async {
    await FirebaseStorage.instance.refFromURL(videoUrl).delete();
    await FirebaseFirestore.instance
        .collection('wagon_wheel_results')
        .doc(videoId)
        .delete();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wagon Wheel Results'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('wagon_wheel_results')
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          final videos = snapshot.data?.docs;

          return ListView.builder(
            itemCount: videos?.length,
            itemBuilder: (context, index) {
              final video = videos?[index];

              // Extract video data from the document
              final videoUrl = video?['url'];
              final videoScore = video?['score'];
              final videoTitle = video?['title'];
              final scoredShots = video?['scored_shots'];

              return ListTile(
                title: Text('$videoTitle \n'
                    'Score: ${videoScore.toString()} \n'
                    'Scored Shots: ${scoredShots.toString()}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Video'),
                        content: const Text(
                            'Are you sure you want to delete this video?'),
                        actions: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Delete'),
                            onPressed: () async {
                              _deleteVideo(video!.id, videoUrl).then((_) {
                                Navigator.of(context).pop();
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayerPage(videoUrl: videoUrl),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
