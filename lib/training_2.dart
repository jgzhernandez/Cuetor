import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:video_player/video_player.dart';

class TrainingPage extends StatefulWidget {
  final CameraDescription camera;
  final Function analyzeVideo;

  const TrainingPage(
      {super.key, required this.camera, required this.analyzeVideo});

  @override
  _TrainingPageState createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late VideoPlayerController _videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
    _videoPlayerController =
        VideoPlayerController.asset('assets/sample_video.mp4');
    _initializeVideoPlayerFuture = _videoPlayerController.initialize();
    _videoPlayerController.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_controller);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: double.infinity,
              color: Colors.black,
              child: FutureBuilder<void>(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return AspectRatio(
                      aspectRatio: _videoPlayerController.value.aspectRatio,
                      child: VideoPlayer(_videoPlayerController),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: FloatingActionButton(
                child: const Icon(Icons.videocam),
                onPressed: () async {
                  try {
                    await _initializeControllerFuture;
                    final filePath = await widget.analyzeVideo(_controller);
                    _videoPlayerController =
                        VideoPlayerController.file(File(filePath));
                    _initializeVideoPlayerFuture =
                        _videoPlayerController.initialize();
                    _videoPlayerController.setLooping(true);
                    setState(() {});
                  } catch (e) {
                    // print(e);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}