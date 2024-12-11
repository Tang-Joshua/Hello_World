import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';

import 'package:flutterapp/Sorting_Simulators/Sorting_Choices.dart';
import 'package:flutterapp/Graph_Simulators/Graph_Choices.dart';
import 'package:flutterapp/Data_Structure/Data_Choices.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double buttonWidth = MediaQuery.of(context).size.width * 0.8;
    final double buttonHeight = MediaQuery.of(context).size.height * 0.07;

    return Scaffold(
      body: Stack(
        children: [
          // Moving wave background
          Positioned.fill(
            child: WaveWidget(
              config: CustomConfig(
                gradients: [
                  [Colors.green.shade400, Colors.green.shade300],
                  [Colors.green.shade600, Colors.green.shade400],
                  [Colors.green.shade800, Colors.green.shade600],
                  [Colors.lightGreen, Colors.green.shade400],
                ],
                durations: [32000, 21000, 18000, 5000],
                heightPercentages: [
                  0.50,
                  0.55,
                  0.58,
                  0.62
                ], // Lowered wave heights
                gradientBegin: Alignment.topLeft,
                gradientEnd: Alignment.bottomRight,
              ),
              size: const Size(double.infinity, double.infinity),
              waveAmplitude: 20, // Adds curvature to the waves
            ),
          ),

          // Content overlaying the waves
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                const Spacer(flex: 2), // Flexible space above the title
                // Cool "AL-GO!" text design
                CoolTextDesign(),
                const Spacer(
                    flex: 1), // Flexible space between title and buttons

                // Buttons with navigation functionality
                Column(
                  children: [
                    buildButton(
                      context,
                      "SORTING ALGORITHMS",
                      buttonWidth,
                      buttonHeight,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SortingChoices(), // Sorting page
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                    buildButton(
                      context,
                      "GRAPH ALGORITHMS",
                      buttonWidth,
                      buttonHeight,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GraphChoices(), // Graph page
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                    buildButton(
                      context,
                      "DATA STRUCTURES",
                      buttonWidth,
                      buttonHeight,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DataChoices(), // Data structures page
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const Spacer(flex: 2), // Flexible space at the bottom
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButton(BuildContext context, String text, double width,
      double height, VoidCallback onPressed) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Smooth edges
          ),
          backgroundColor:
              const Color(0xFF607D8B), // Solid gray color (Material Blue Gray)
          elevation: 2, // Subtle elevation
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.045,
            fontWeight: FontWeight.bold,
            color: Colors.white, // White font for contrast
            fontFamily: 'RobotoMono', // Clean, technical font
            letterSpacing: 1.1, // Slight letter spacing
          ),
        ),
      ),
    );
  }
}

class CoolTextDesign extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Glowing shadow effect
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'AL-',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.23,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Arial',
                  color: Colors.black,
                  shadows: [
                    Shadow(
                      offset: const Offset(0, 2),
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.5),
                    ),
                    Shadow(
                      offset: const Offset(0, 4),
                      blurRadius: 20,
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ],
                ),
              ),
              TextSpan(
                text: 'GO',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.23,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Arial',
                  foreground: Paint()
                    ..shader = LinearGradient(
                      colors: [
                        const Color.fromARGB(255, 41, 95, 43),
                        Colors.green.shade700,
                        Colors.green.shade400,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                  shadows: [
                    Shadow(
                      offset: const Offset(0, 2),
                      blurRadius: 10,
                      color: Colors.green.withOpacity(0.6),
                    ),
                    Shadow(
                      offset: const Offset(0, 4),
                      blurRadius: 20,
                      color: Colors.green.withOpacity(0.4),
                    ),
                  ],
                ),
              ),
              TextSpan(
                text: '!',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.23,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Arial',
                  color: Colors.black,
                  shadows: [
                    Shadow(
                      offset: const Offset(0, 2),
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.5),
                    ),
                    Shadow(
                      offset: const Offset(0, 4),
                      blurRadius: 20,
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Outline for extra pop
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'AL-',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.23,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Arial',
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 2
                    ..color = Colors.black,
                ),
              ),
              TextSpan(
                text: 'GO',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.23,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Arial',
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 2
                    ..color = Colors.black,
                ),
              ),
              TextSpan(
                text: '!',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.23,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Arial',
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 2
                    ..color = Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
