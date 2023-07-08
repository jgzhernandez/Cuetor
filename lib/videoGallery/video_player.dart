import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerPage({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    _initializeVideoPlayerFuture =
        _videoPlayerController.initialize().then((_) {
      setState(() {}); // Trigger a rebuild once the video is initialized
    });
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
      ),
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                Center(
                  child: AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(_videoPlayerController),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child:
                      VideoPlayerControls(controller: _videoPlayerController),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class VideoPlayerControls extends StatelessWidget {
  final VideoPlayerController controller;

  const VideoPlayerControls({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueListenableBuilder(
                valueListenable: controller,
                builder: (context, value, child) {
                  return IconButton(
                    icon: Icon(
                      value.isPlaying ? Icons.pause : Icons.play_arrow,
                    ),
                    onPressed: () {
                      if (value.isPlaying) {
                        controller.pause();
                      } else {
                        controller.play();
                      }
                    },
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.replay),
                onPressed: () {
                  controller.seekTo(Duration.zero);
                },
              ),
            ],
          ),
          VideoProgressBar(controller: controller),
        ],
      ),
    );
  }
}

class VideoProgressBar extends StatefulWidget {
  final VideoPlayerController controller;

  const VideoProgressBar({Key? key, required this.controller})
      : super(key: key);

  @override
  State<VideoProgressBar> createState() => _VideoProgressBarState();
}

class _VideoProgressBarState extends State<VideoProgressBar> {
  double _currentSliderValue = 0.0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_videoPlayerListener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_videoPlayerListener);
    super.dispose();
  }

  void _videoPlayerListener() {
    setState(() {
      _currentSliderValue =
          widget.controller.value.position.inSeconds.toDouble();
    });
  }

  void _onSliderChanged(double value) {
    setState(() {
      _currentSliderValue = value;
    });
    final Duration duration = Duration(seconds: value.toInt());
    widget.controller.seekTo(duration);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  @override
  Widget build(BuildContext context) {
    final duration = widget.controller.value.duration;
    final position = widget.controller.value.position;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Slider(
            value: _currentSliderValue,
            min: 0.0,
            max: duration.inSeconds.toDouble(),
            onChanged: _onSliderChanged,
            divisions: duration.inSeconds,
            label: _formatDuration(position),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(position),
                style: const TextStyle(fontSize: 12.0),
              ),
              Text(
                _formatDuration(duration),
                style: const TextStyle(fontSize: 12.0),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
