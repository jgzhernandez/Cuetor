import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'exercises/polygonpainter.dart';

class VideoPreview extends StatefulWidget {
  const VideoPreview({
    Key? key,
    required this.filePath,
    required this.folder,
    required this.polygonVertices,
  }) : super(key: key);

  final String filePath;
  final String folder;
  final List<Offset> polygonVertices;

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  late VideoPlayerController _videoPlayerController;

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future _initVideoPlayer() async {
    final videoFile = File(widget.filePath);
    _videoPlayerController = VideoPlayerController.file(videoFile);
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.play();
  }

  Future uploadFile() async {
    UploadTask? uploadTask;

    // Upload video to firebase
    final videoFile = File(widget.filePath);
    final path = 'files/videos/${widget.folder}/${DateTime.now()}.mp4';
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(videoFile);
    final snapshot = await uploadTask.whenComplete(() {});

    // Get the download URL of the uploaded video
    final downloadURL = await snapshot.ref.getDownloadURL();

    // Store metadata in firestore
    await FirebaseFirestore.instance.collection('${widget.folder}_videos').add({
      'url': downloadURL,
      'title': '${DateTime.now()}.mp4',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
          elevation: 0,
          color: Colors.black26,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  if (kDebugMode) {
                    print('delete file');
                  }
                  Navigator.of(context).pop();
                },
              ),
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {
                  if (kDebugMode) {
                    print('do something with the file');
                  }
                  uploadFile();
                  Navigator.of(context).pop();
                },
              )
            ],
          )),
      extendBodyBehindAppBar: true,
      body: FutureBuilder(
        future: _initVideoPlayer(),
        builder: (context, state) {
          if (state.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Stack(
              children: [
                VideoPlayer(_videoPlayerController),
                CustomPaint(
                  painter: PolygonPainter(vertices: widget.polygonVertices),
                  size: Size.infinite,
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
