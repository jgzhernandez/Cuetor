import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../videoPage.dart';

// late List<CameraDescription> _cameras;

//Stop Shot
class Exercise1 extends StatefulWidget {
  const Exercise1({super.key});

  @override
  State<Exercise1> createState() => _Exercise1State();
}

class _Exercise1State extends State<Exercise1> {
  late CameraController _cameraController;
  bool _isLoading = true;
  bool _isRecording = false;

  _initCamera() async {
    final cameras = await availableCameras();
    final back = cameras.firstWhere((camera) =>
    camera.lensDirection == CameraLensDirection.back);
    _cameraController = CameraController(back, ResolutionPreset.max);
    await _cameraController.initialize();
    await _cameraController.lockCaptureOrientation();
    setState(() => _isLoading = false);
  }

  _recordVideo() async {
    if (_isRecording) {
      final file = await _cameraController.stopVideoRecording();
      setState(() => _isRecording = false);
      final route = MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => VideoPage(filePath: file.path),
      );
      Navigator.push(context, route);
    } else {
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      setState(() => _isRecording = true);
    }
  }

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CameraPreview(_cameraController),
            Padding(
              padding: const EdgeInsets.all(25),
              child: FloatingActionButton(
                backgroundColor: Colors.red,
                child: Icon(_isRecording ? Icons.stop : Icons.circle),
                onPressed: () => _recordVideo(),
              ),
            ),
          ],
        ),
      );
    }
    // return MaterialApp(
    //   home: CameraPreview(_cameraController),
    // );
  }
}