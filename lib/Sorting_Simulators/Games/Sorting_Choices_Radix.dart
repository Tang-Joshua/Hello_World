import 'package:flutter/material.dart';
import 'radix/Sliding_radix.dart';
import 'radix/PlayButton_Sliding.dart';
import 'radix/PlayButton_RadixRace.dart';
import 'hangman.dart';

void main() {
  runApp(GameSelectionApp());
}

class GameSelectionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Selection',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: GameSelectionScreen(),
    );
  }
}

class GameSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Your Game'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/clouds_violet.png', // Replace with your image path
              fit: BoxFit.cover, // Cover the entire background
            ),
          ),
          // Main content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // First row with Game 1 and Game 2
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // First Game Card (Game 1)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GameIntroScreen()),
                        );
                        // Add your action for the first game here
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(
                            color: const Color.fromARGB(
                                255, 255, 255, 255), // Border color
                            width: 6.0, // Border thickness
                          ),
                        ),
                        elevation: 5, // Adds shadow to make the card pop out
                        child: Container(
                          height: 300, // Height for all cards
                          width: 200, // Width for all cards
                          child: Stack(
                            children: [
                              // Background Image
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Image.asset(
                                    'assets/card_image.png', // Replace with your image
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              // Overlay Text at the top left with margin
                              Positioned(
                                top: 20, // Margin from the top
                                left: 20, // Margin from the left
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Radix Race',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        color: Color.fromARGB(
                                            255, 44, 82, 107), // Text color
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            4), // Adds space between the text and the underline
                                    Container(
                                      width:
                                          100, // Adjust width of the underline if needed
                                      height: 5, // Thickness of the underline
                                      color: Color.fromARGB(
                                          255, 44, 82, 107), // Underline color
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Second Game Card (Game 2)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GameIntroScreen2()),
                        );
                        // Add your action for the first game here
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(
                            color: const Color.fromARGB(
                                255, 255, 255, 255), // Border color
                            width: 6.0, // Border thickness
                          ),
                        ),
                        elevation: 5, // Adds shadow to make the card pop out
                        child: Container(
                          height: 300, // Height for all cards
                          width: 200, // Width for all cards
                          child: Stack(
                            children: [
                              // Background Image
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Image.asset(
                                    'assets/Slide.png', // Replace with your image
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              // Overlay Text at the top left with margin
                              Positioned(
                                top: 20, // Margin from the top
                                left: 20, // Margin from the left
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Sliding Puzzle',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        color: Color.fromARGB(
                                            255, 255, 255, 255), // Text color
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            4), // Adds space between the text and the underline
                                    Container(
                                      width:
                                          100, // Adjust width of the underline if needed
                                      height: 5, // Thickness of the underline
                                      color: Color.fromARGB(255, 255, 255,
                                          255), // Underline color
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20), // Space between the rows
                // Second row with Game 3 below Game 1
                Row(
                  children: [
                    SizedBox(width: 20), // Adds space to the left of Game 3
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HangmanGame()),
                        );
                        // Add your action for the first game here
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(
                            color: const Color.fromARGB(
                                255, 255, 255, 255), // Border color
                            width: 6.0, // Border thickness
                          ),
                        ),
                        elevation: 5, // Adds shadow to make the card pop out
                        child: Container(
                          height: 300, // Height for all cards
                          width: 200, // Width for all cards
                          child: Stack(
                            children: [
                              // Background Image
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Image.asset(
                                    'assets/card_image.png', // Replace with your image
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              // Overlay Text at the top left with margin
                              Positioned(
                                top: 20, // Margin from the top
                                left: 20, // Margin from the left
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hangman',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        color: Color.fromARGB(
                                            255, 44, 82, 107), // Text color
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            4), // Adds space between the text and the underline
                                    Container(
                                      width:
                                          100, // Adjust width of the underline if needed
                                      height: 5, // Thickness of the underline
                                      color: Color.fromARGB(
                                          255, 44, 82, 107), // Underline color
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
