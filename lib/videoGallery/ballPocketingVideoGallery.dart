import 'package:cuetor/videoGallery/videoPlayer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BallPocketingVideoGallery extends StatelessWidget {
  const BallPocketingVideoGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ball Pocketing Videos'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('ball_pocketing_videos')
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
                final videoTitle = video?['title'];

                return ListTile(
                  title: Text(videoTitle),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VideoPlayerPage(videoUrl: videoUrl),
                      ),
                    );
                  },
                );
              },
            );
          }),
    );
  }
}
