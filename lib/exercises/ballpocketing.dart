import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../videopreview.dart';

// Ball Pocketing
class BallPocketing extends StatefulWidget {
  const BallPocketing({super.key});

  @override
  State<BallPocketing> createState() => _BallPocketingState();
}

class _BallPocketingState extends State<BallPocketing> {
  late CameraController _cameraController;
  bool _isLoading = true;
  bool _isRecording = false;
  List<Offset> _polygonVertices = [];
  bool _isDrawingMode = false;

  _initCamera() async {
    final cameras = await availableCameras();
    final back = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);
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
        builder: (_) => VideoPreview(
          filePath: file.path,
          folder: 'ball_pocketing',
        ),
      );
      Navigator.push(context, route);
    } else {
      if (_polygonVertices.length == 6) {
        await _cameraController.prepareForVideoRecording();
        await _cameraController.startVideoRecording();
        setState(() => _isRecording = true);
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Invalid Polygon'),
            content: const Text(
                'Please draw a polygon with exactly 6 vertices before recording.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  void _startDrawingMode() {
    setState(() {
      _isDrawingMode = true;
      _polygonVertices = [];
    });
  }

  void _stopDrawingMode() {
    setState(() {
      _isDrawingMode = false;
    });
    if (_polygonVertices.length == 6) {
      // Send the coordinates to the Python code for further processing
      // Replace the print statement with your code to send the coordinates
      print(_polygonVertices);
    } else {
      // Handle the case where the user didn't draw exactly 6 vertices
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Invalid Polygon'),
          content: const Text('Please draw a polygon with exactly 6 vertices.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (_isDrawingMode) {
      setState(() {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final Offset localOffset = box.globalToLocal(details.globalPosition);
        _polygonVertices.add(localOffset);
      });
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
      return GestureDetector(
        onTapDown: _handleTapDown,
        child: Stack(
          children: [
            CameraPreview(_cameraController),
            CustomPaint(
              painter: PolygonPainter(vertices: _polygonVertices),
              size: Size.infinite,
            ),
            if (_isDrawingMode)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.black54,
                  padding: const EdgeInsets.symmetric(vertical: 25.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Tap to add vertices (${_polygonVertices.length}/6)',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FloatingActionButton(
                            backgroundColor: Colors.red,
                            onPressed: () {
                              setState(() {
                                _polygonVertices.removeLast();
                              });
                            },
                            child: const Icon(
                              Icons.delete,
                              size: 32.0,
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          FloatingActionButton(
                            backgroundColor: Colors.blue,
                            onPressed: () {
                              setState(() {
                                _polygonVertices.clear();
                              });
                            },
                            child: const Icon(
                              Icons.restart_alt,
                              size: 32.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            Positioned(
              bottom: 25,
              left: 25,
              child: FloatingActionButton(
                backgroundColor: _isDrawingMode ? Colors.green : Colors.green,
                onPressed: () {
                  if (_isDrawingMode) {
                    _stopDrawingMode();
                  } else {
                    _startDrawingMode();
                  }
                },
                child: Icon(
                  _isDrawingMode ? Icons.done : Icons.edit,
                  size: 32.0,
                ),
              ),
            ),
            Positioned(
              bottom: 25,
              right: 25,
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
  }
}

class PolygonPainter extends CustomPainter {
  final List<Offset> vertices;

  PolygonPainter({required this.vertices});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    if (vertices.length > 0) {
      final path = Path();
      path.moveTo(vertices[0].dx, vertices[0].dy);
      for (int i = 1; i < vertices.length; i++) {
        path.lineTo(vertices[i].dx, vertices[i].dy);
      }
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
