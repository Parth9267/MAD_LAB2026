import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key, required this.openedWith});

  final String openedWith;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Screen')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_rounded,
                size: 88,
                color: Color(0xFF2A8F5B),
              ),
              const SizedBox(height: 16),
              Text(
                'Navigation Successful',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text('Opened with $openedWith', textAlign: TextAlign.center),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                key: const Key('backButton'),
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('Return with Navigator.pop'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
