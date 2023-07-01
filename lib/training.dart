import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'exercises/stopshot.dart';
import 'exercises/ballpocketing.dart';
import 'exercises/wagonwheel.dart';

class TrainingPage extends StatelessWidget {
  const TrainingPage({super.key});

  void _setLandscapeOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Training Exercises'),
      ),
      body: ListView(
        children: [
          // Stop Shot
          ExerciseCard(
            title: 'Stop Shot Exercise',
            description:
                'The Stop Shot Drill tests a player’s ability to execute a stun shot, wherein the cue ball stops near the object ball upon contact.',
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text('Stop Shot Exercise'),
                        content: Wrap(
                          children: [
                            Image.asset('images/F2_1.png'),
                            const Text(
                                '\n1. Place the object ball near the 1st diamond and the cue ball near the 3rd diamond to start the drill.\n'
                                '2. Pocket the object ball to the nearest corner pocket and make the cue ball stop within one ball radius of the object ball.\n'
                                '3. There will be two shots per position. Move back 1 diamond after both shots.\n'
                                '4. Repeat the process for all 10 shots. Your score will be the number of successful stop shots executed.'),
                          ],
                        ),
                        actions: [
                          TextButton(
                              child: const Text('Back'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                          TextButton(
                              child: const Text('Continue'),
                              onPressed: () {
                                _setLandscapeOrientation();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const StopShot()),
                                );
                              })
                        ],
                      ));
            },
          ),
          // Ball Pocketing
          ExerciseCard(
            title: 'Ball Pocketing Exercise',
            description:
                'The Ball Pocketing Drill tests a player’s ability to make a variety of shots with varying angles and distances.',
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text('Ball Pocketing Exercise'),
                        content: Wrap(
                          children: [
                            Image.asset('images/F6.png'),
                            const Text(
                                '\n1. Follow the setup from the image below.\n'
                                '2. Try to pocket the object ball for all 10 shots.\n'
                                '3. Your score will be the number of successful makes'),
                          ],
                        ),
                        actions: [
                          TextButton(
                              child: const Text('Back'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                          TextButton(
                              child: const Text('Continue'),
                              onPressed: () {
                                _setLandscapeOrientation();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const BallPocketing()),
                                );
                              })
                        ],
                      ));
            },
          ),
          // Wagon Wheel
          ExerciseCard(
            title: 'Wagon Wheel Exercise',
            description:
                'The Wagon Wheel Drill tests a player’s ability to control the cue ball around the table using basic knowledge of topspin and backspin. ',
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text('Wagon Wheel Exercise'),
                        content: Wrap(
                          children: [
                            Image.asset('images/F7_1.png'),
                            const Text(
                                '\n1. Place the object ball 1 diamond away from the center pocket.\n'
                                '2. You have cue ball in hand for all 10 shots of the drill.\n'
                                '3. You have 1 attempt to hit each of the 10 target locations with the cue ball, after pocketing the object ball in the center pocket.\n '
                                '4. Go through the target locations in sequence.\n'
                                '5. Each successful hit after pocketing the object ball correctly will be 1 point. You can get a total of 10 points for this drill. '),
                          ],
                        ),
                        actions: [
                          TextButton(
                              child: const Text('Back'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                          TextButton(
                              child: const Text('Continue'),
                              onPressed: () {
                                _setLandscapeOrientation();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const WagonWheel()),
                                );
                              })
                        ],
                      ));
            },
          ),
        ],
      ),
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;

  const ExerciseCard({
    super.key,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.blueGrey[900],
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              Text(
                description,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
