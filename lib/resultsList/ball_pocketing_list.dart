import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuetor/videoGallery/video_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class BallPocketingList extends StatefulWidget {
  const BallPocketingList({super.key});

  @override
  State<BallPocketingList> createState() => _BallPocketingListState();
}

class _BallPocketingListState extends State<BallPocketingList> {
  Future<void> _deleteVideo(String videoId, String videoUrl) async {
    await FirebaseStorage.instance.refFromURL(videoUrl).delete();
    await FirebaseFirestore.instance
        .collection('ball_pocketing_results')
        .doc(videoId)
        .delete();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ball Pocketing Results'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('ball_pocketing_results')
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
              final videoShots = video?['scored shots'];

              return ListTile(
                title: Text('${videoTitle} \n '
                'Score: ${videoScore.toString()} \n'  + 
                '${videoShots}'),
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
