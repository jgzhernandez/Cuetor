import 'package:flutter/material.dart';
import 'exercises/exercise1.dart';
import 'exercises/exercise2.dart';
import 'exercises/exercise3.dart';

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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Exercise1(),
                ),
              );
            },
          ),
          ExerciseCard(
            title: 'Ball Pocketing Exercise',
            description: 'Description of Exercise 2',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Exercise2(),
                ),
              );
            },
          ),
          ExerciseCard(
            title: 'Wagon Wheel Exercise',
            description: 'Description of Exercise 3',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Exercise3(),
                ),
              );
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

class ExercisePage extends StatelessWidget {
  final int exerciseId;

  const ExercisePage({super.key, required this.exerciseId});

  @override
  Widget build(BuildContext context) {
    // Customize this page based on the exerciseId
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise $exerciseId'),
      ),
      body: Center(
        child: Text('Exercise $exerciseId'),
      ),
    );
  }
}
