import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CenterButtonScreen(),
    );
  }
}

class CenterButtonScreen extends StatelessWidget {
  final AudioPlayer audioPlayer = AudioPlayer();

  void _playSound() async {
    try {
      await audioPlayer.play(AssetSource('Sounds/radix.mp3'));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Centered Button Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _playSound(); // Play sound when button is pressed
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Button Pressed!")),
            );
          },
          child: Text('Press Me'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
