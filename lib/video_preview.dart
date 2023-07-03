import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuetor/training.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoPreview extends StatefulWidget {
  const VideoPreview({
    Key? key,
    required this.filePath,
    required this.folder,
  }) : super(key: key);

  final String filePath;
  final String folder;

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  late VideoPlayerController _videoPlayerController;

  void _setLandscapeOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void _initVideoPlayer() {
    _videoPlayerController = VideoPlayerController.file(File(widget.filePath))
      ..initialize().then((_) {
        setState(() {
          _videoPlayerController.setLooping(true);
          _videoPlayerController.play();
        });
      });
  }

  Widget _buildVideoPlayer() {
    if (_videoPlayerController.value.isInitialized) {
      return Center(
          child: AspectRatio(
        aspectRatio: _videoPlayerController.value.aspectRatio,
        child: VideoPlayer(_videoPlayerController),
      ));
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Future uploadFile() async {
    UploadTask? uploadTask;

    _videoPlayerController = VideoPlayerController.file(File(widget.filePath));

    // Upload video to firebase
    final videoFile = File(widget.filePath);
    final path =
        'user/${FirebaseAuth.instance.currentUser?.uid}/files/videos/${widget.folder}/${DateTime.now()}.mp4';
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(videoFile);
    final snapshot = await uploadTask.whenComplete(() {});

    // Get the download URL of the uploaded video
    final downloadURL = await snapshot.ref.getDownloadURL();

    // Store metadata in firestore
    await FirebaseFirestore.instance.collection('${widget.folder}_videos').add({
      'uid': FirebaseAuth.instance.currentUser?.uid,
      'url': downloadURL,
      'title': '${DateTime.now()}.mp4',
    });
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    super.initState();
    _setLandscapeOrientation();
    _initVideoPlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Video Player Widget
          _buildVideoPlayer(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Save the polygon coordinates and perform necessary actions
          _videoPlayerController.pause();
          uploadFile();
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const TrainingPage(),
            ),
            (route) => false,
          );
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
