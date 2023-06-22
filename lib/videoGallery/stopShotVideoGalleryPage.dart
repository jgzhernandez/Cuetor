import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StopShotVideoGalleryPage extends StatelessWidget {
  const StopShotVideoGalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stop Shot Videos'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('videos').snapshots(),
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
                  // Handle video playback or further actions
                  // E.g., navigate to a detailed video page
                  // or start video playback using a video player widget
                },
              );
            },
          );
        },
      ),
    );
  }
}
