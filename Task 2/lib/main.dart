import 'package:flutter/material.dart';

void main() => runApp(
  const MaterialApp(
    debugShowCheckedModeBanner: false,

    home: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(Icons.flutter_dash, size: 80),

            SizedBox(height: 20),
            Text(
              'Hello World!',

              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Welcome to Flutter', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    ),
  ),
);
