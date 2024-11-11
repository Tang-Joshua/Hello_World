import 'package:flutter/material.dart';
import 'Insertion_Race.dart';
import 'Board_insertion.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameIntroInsertionScreen(),
    );
  }
}

class GameIntroInsertionScreen extends StatelessWidget {
  const GameIntroInsertionScreen({super.key});

  void _showHowToPlayDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          true, // Allow dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return HowToPlayDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Radix"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 19, 83, 134),
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
                        'assets/card_image.png'), // Replace with your image path
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
                      'Insertion Race',
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
                    // Text(
                    //   'Welcome to the Insertion Sort Game! In this game, you will need to find the number by revealing them one by one.',
                    //   style: TextStyle(
                    //     fontSize: 18,
                    //     color: Colors.white,
                    //     shadows: [
                    //       Shadow(
                    //         blurRadius: 10.0,
                    //         color: Colors.black.withOpacity(0.6),
                    //         offset: const Offset(3, 3),
                    //       ),
                    //     ],
                    //   ),
                    //   textAlign: TextAlign.center,
                    // ),
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
                              builder: (context) => InsertionSortScreen()),
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
                  // ? Button
                  ElevatedButton(
                    onPressed: () {
                      // Show the "How to Play" dialog when clicked
                      _showHowToPlayDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 30),
                      backgroundColor: const Color.fromARGB(255, 103, 103, 103),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '?',
                      style: TextStyle(fontSize: 29, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HowToPlayDialog extends StatefulWidget {
  const HowToPlayDialog({super.key});

  @override
  _HowToPlayDialogState createState() => _HowToPlayDialogState();
}

class _HowToPlayDialogState extends State<HowToPlayDialog> {
  int currentStep = 1;

  void _goToNextStep() {
    setState(() {
      if (currentStep < 2) {
        currentStep++;
      }
    });
  }

  void _goToPreviousStep() {
    setState(() {
      if (currentStep > 1) {
        currentStep--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
        // Center the title
        child: Text(
          'How to Play',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image for each step with border radius
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              currentStep == 1 ? 'assets/Card_1st.png' : 'assets/Card_2nd.png',
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),
          // Text instructions
          Text(
            currentStep == 1
                ? 'Reveal the numbers one by one'
                : 'Find the number correctly to win',
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          // Dots to indicate current step
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.circle,
                size: 20,
                color: currentStep == 1 ? Colors.blue : Colors.grey,
              ),
              const SizedBox(width: 20),
              Icon(
                Icons.circle,
                size: 20,
                color: currentStep == 2 ? Colors.blue : Colors.grey,
              ),
            ],
          ),
          const SizedBox(
              height: 30), // Increased space between dots and buttons
          // Row with larger arrows and "OK" button in the middle
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_left, size: 40),
                onPressed: _goToPreviousStep,
              ),
              const SizedBox(
                  width:
                      40), // Added space between the left arrow and "OK" button
              // "OK" Button in the middle with more padding
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              const SizedBox(
                  width:
                      40), // Added space between the "OK" button and right arrow
              IconButton(
                icon: const Icon(Icons.arrow_right, size: 40),
                onPressed: _goToNextStep,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
