import 'package:flutter/material.dart';
import 'Radix_Race.dart';
import 'Sliding_radix.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameIntroScreen2(),
    );
  }
}

class GameIntroScreen2 extends StatelessWidget {
  const GameIntroScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Radix"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 100, 72, 34),
      ),
      body: Column(
        children: [
          // Image container with dark overlay (40% of the screen)
          Stack(
            children: [
              // Image container with dark overlay
              Container(
                height: MediaQuery.of(context).size.height *
                    0.4, // 40% of screen height
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/Slide.png'), // Replace with your image path
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20), // Top left corner radius
                    topRight: Radius.circular(20), // Top right corner radius
                  ),
                ),
                child: Container(
                  color: Colors.black
                      .withOpacity(0.5), // Darken the image with 50% opacity
                ),
              ),

              // Title and description placed directly on the image
              Positioned(
                top: MediaQuery.of(context).size.height *
                    0.1, // Adjust top position as needed
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Game title "Radix Race"
                    Text(
                      'Sliding Puzzle',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black.withOpacity(0.6),
                            offset: const Offset(3, 3),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Game description
                    Text(
                      'This is a classic Sliding Puzzle game. Move the boxes into the correct sort.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black.withOpacity(0.6),
                            offset: const Offset(3, 3),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Panel with Play and ? button (60% of the screen)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Play Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to the next screen or start the game
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SliderGameScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        backgroundColor:
                            const Color.fromARGB(255, 199, 103, 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'PLAY',
                        style: TextStyle(fontSize: 29, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20), // Space between the buttons
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
