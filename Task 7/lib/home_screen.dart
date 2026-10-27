import 'package:flutter/material.dart';

import 'second_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Color _gestureColor = const Color(0xFFE9EDFF);
  bool _isAlternateColor = false;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _changeColor() {
    setState(() {
      _isAlternateColor = !_isAlternateColor;
      _gestureColor = _isAlternateColor
          ? const Color(0xFFD8F5E7)
          : const Color(0xFFE9EDFF);
    });
    _showMessage('Single tap detected: color changed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Experiment 7'), centerTitle: true),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Navigation and Gestures',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Try basic navigation, named routes, and three common gestures.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    GestureDetector(
                      key: const Key('namedRouteLogo'),
                      onTap: () => Navigator.pushNamed(context, '/second'),

                      child: Semantics(
                        button: true,
                        label: 'Open second screen using named route',
                        child: FlutterLogo(size: 112),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Tap the Flutter logo to open the second screen using a named route.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              key: const Key('gestureArea'),
              onTap: _changeColor,
              onDoubleTap: () => _showMessage('Double tap detected'),
              onLongPress: () => _showMessage('Long press detected'),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 28,
                ),
                decoration: BoxDecoration(
                  color: _gestureColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFB9C4F8)),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.touch_app_rounded, size: 42),
                    SizedBox(height: 10),
                    Text(
                      'Gesture Playground',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Tap to change color • Double tap for a message • Long press for a message',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              key: const Key('basicNavigationButton'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const SecondScreen(openedWith: 'Navigator.push()'),
                  ),
                );
              },
              icon: const Icon(Icons.arrow_forward_rounded),
              label: const Text('Open with Navigator.push'),
            ),
          ],
        ),
      ),
    );
  }
}
