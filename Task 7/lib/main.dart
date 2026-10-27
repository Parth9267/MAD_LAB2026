import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'second_screen.dart';

void main() {
  runApp(const NavigationGestureApp());
}

class NavigationGestureApp extends StatelessWidget {
  const NavigationGestureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation and Gestures',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3157D5)),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/second': (context) =>
            const SecondScreen(openedWith: 'Navigator.pushNamed()'),
      },
    );
  }
}
