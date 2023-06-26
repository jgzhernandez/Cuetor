import 'package:flutter/material.dart';
import 'exercises/stopshot.dart';
import 'exercises/ballpocketing.dart';
import 'exercises/wagonwheel.dart';

class TrainingPage extends StatelessWidget {
  const TrainingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Training Exercises'),
      ),
      body: ListView(
        children: [
          ExerciseCard(
            title: 'Stop Shot Exercise',
            description: 'Description of Exercise 1',
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text('Stop Shot Exercise'),
                        content: const Text('Instructions and images'),
                        actions: [
                          TextButton(
                              child: const Text('Back'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                          TextButton(
                              child: const Text('Continue'),
                              onPressed: () {
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
          ExerciseCard(
            title: 'Ball Pocketing Exercise',
            description: 'Description of Exercise 2',
            onTap: ()  {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Ball Pocketing Exercise'),
                    content: const Text('Instructions and images'),
                    actions: [
                      TextButton(
                          child: const Text('Back'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                      TextButton(
                          child: const Text('Continue'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const BallPocketing()),
                            );
                          })
                    ],
                  ));
            },
          ),
          ExerciseCard(
            title: 'Wagon Wheel Exercise',
            description: 'Description of Exercise 3',
            onTap: ()  {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Wagon Wheel Exercise'),
                    content: const Text('Instructions and images'),
                    actions: [
                      TextButton(
                          child: const Text('Back'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                      TextButton(
                          child: const Text('Continue'),
                          onPressed: () {
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

// class ExercisePage extends StatelessWidget {
//   final int exerciseId;
//
//   const ExercisePage({super.key, required this.exerciseId});
//
//   @override
//   Widget build(BuildContext context) {
//     // Customize this page based on the exerciseId
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Exercise $exerciseId'),
//       ),
//       body: Center(
//         child: Text('Exercise $exerciseId'),
//       ),
//     );
//   }
// }
