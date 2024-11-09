import 'package:flutter/material.dart';
import 'package:collection/collection.dart'; // Import for ListEquality
import 'dart:math'; // Import for random number generation

// import 'package:audioplayers/audioplayers.dart'; // Import audioplayers for audio playback

void main() {
  runApp(SliderGameApp());
}

class SliderGameApp extends StatelessWidget {
  const SliderGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slider Puzzle Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SliderGameScreen(),
    );
  }
}

// Import statements and main function as usual...

class SliderGameScreen extends StatefulWidget {
  const SliderGameScreen({super.key});

  @override
  _SliderGameScreenState createState() => _SliderGameScreenState();
}

class _SliderGameScreenState extends State<SliderGameScreen> {
  late List<int> _numbers; // The list that holds the numbers
  late List<int> _sortedNumbers; // List representing the sorted state
  final int _gridSize = 4; // Grid size is now 4x4
  final double _tileSize = 80; // Size of each tile for the animation
  final double _tileMargin = 4.0; // Margin between tiles
  final Duration _slideDuration =
      const Duration(milliseconds: 700); // Slide animation duration

  // final AudioPlayer _audioPlayer = AudioPlayer(); // Create an instance of AudioPlayer

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  // Initialize the game with custom numbers for a 4x4 grid
  void _initGame() {
    // First configuration of custom numbers for a 4x4 grid
    List<int> customNumbers1 = [
      34, 56, 23, 6, // First row
      34, 56, 23, 6, // Second row
      34, 56, 23, 6, // Third row
      34, 6, 23, 0, // Fourth row (0 represents the empty space)
    ];

    List<int> sortedNumbers1 = [
      34, 56, 23, 6,
      34, 23, 56, 6,
      6, 23, 34, 56,
      6, 23, 34, 0, // Fourth row sorted (with empty space in place of 0)
    ];

    // Second configuration of custom numbers for a 4x4 grid
    List<int> customNumbers2 = [
      89, 1, 44, 66, // First row sorted
      89, 1, 44, 66, // Second row sorted
      89, 1, 44, 66, // Third row sorted
      66, 1, 44, 0, // Fourth row (0 represents the empty space)
    ];

    List<int> sortedNumbers2 = [
      89, 1, 44, 66,
      1, 89, 44, 66,
      1, 44, 89, 66,
      1, 44, 66, 0 // Fourth row sorted (with empty space in place of 0)
    ];

    // Third configuration of custom numbers for a 4x4 grid
    List<int> customNumbers3 = [
      55, 32, 43, 22,
      55, 32, 43, 22,
      55, 32, 43, 22,
      22, 32, 43, 0 // Fourth row (0 represents the empty space)
    ];

    List<int> sortedNumbers3 = [
      55, 32, 43, 22,
      32, 55, 43, 22,
      32, 43, 55, 22,
      22, 32, 43, 0 // Fourth row (0 represents the empty space)
    ];

    // Third configuration of custom numbers for a 4x4 grid
    List<int> customNumbers4 = [
      11, 674, 32, 45, // First row
      11, 674, 32, 45, // Second row
      11, 674, 32, 45, // Third row
      11, 45, 32, 0 // Fourth row (0 represents the empty space)
    ];

    List<int> sortedNumbers4 = [
      11, 674, 32, 45,
      11, 32, 674, 45,
      11, 32, 45, 674,
      11, 32, 45, 0, // Fourth row (0 represents the empty space)
    ];

    // Randomly select one of the configurations
    int config = Random().nextInt(4); // Generate 0 or 1
    if (config == 0) {
      _numbers = List<int>.from(customNumbers1);
      _sortedNumbers = List<int>.from(sortedNumbers1);
    } else if (config == 1) {
      _numbers = List<int>.from(customNumbers2);
      _sortedNumbers = List<int>.from(sortedNumbers2);
    } else if (config == 2) {
      _numbers = List<int>.from(customNumbers3);
      _sortedNumbers = List<int>.from(sortedNumbers3);
    } else if (config == 3) {
      _numbers = List<int>.from(customNumbers4);
      _sortedNumbers = List<int>.from(sortedNumbers4);
    }

    _printRows(); // Print rows in the terminal
    setState(() {}); // Refresh the UI with new numbers
  }

  // Handle tile tap
  void _onTileTap(int index) async {
    final emptyIndex = _numbers.indexOf(0); // Find the empty tile (0)
    if (_canSwap(index, emptyIndex)) {
      setState(() {
        // Swap the tapped tile with the empty tile
        _numbers[emptyIndex] = _numbers[index];
        _numbers[index] = 0;
      });

      _printRows(); // Print rows in the terminal after the tile move
      _checkWinCondition(); // Check if the player has won
    }
  }

  // Initialize the ListEquality instance
  final ListEquality _listEquality = const ListEquality();

  void _checkWinCondition() {
    // Use ListEquality to compare _numbers with _sortedNumbers
    if (_listEquality.equals(_numbers, _sortedNumbers)) {
      _showWinDialog(); // Show win message if arrays are equal
    }
  }

  // Check if the current numbers match the sorted numbers

  // Display a dialog when the player wins
  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Congratulations!"),
          content: const Text("You solved the puzzle correctly."),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                _initGame(); // Restart the game
              },
            ),
          ],
        );
      },
    );
  }

  // Determine if the tile can be swapped with the empty tile
  bool _canSwap(int currentIndex, int emptyIndex) {
    int row1 = currentIndex ~/ _gridSize;
    int col1 = currentIndex % _gridSize;
    int row2 = emptyIndex ~/ _gridSize;
    int col2 = emptyIndex % _gridSize;

    return (row1 == row2 && (col1 - col2).abs() == 1) ||
        (col1 == col2 && (row1 - row2).abs() == 1);
  }

  // Print all rows of the grid in the terminal
  void _printRows() {
    int rows = 4; // Number of rows (4x4 grid)
    for (int i = 0; i < rows; i++) {
      // Get the numbers for each row (4 rows now)
      List<int> row = _numbers.sublist(i * _gridSize, (i + 1) * _gridSize);
      print('Row $i: $row'); // Print each row
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Slider Puzzle Game'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initGame,
          ),
        ],
      ),
      backgroundColor:
          const Color.fromARGB(255, 151, 119, 93), // Background color
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start, // Align content to the top
        crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
        children: [
          const SizedBox(height: 20), // Adds space from the top
          // Replace the text "Solve the Puzzle!" with the first row's numbers
          Text(
            _numbers
                .sublist(0, _gridSize)
                .join(', '), // Display first row as text
            style: const TextStyle(
              fontSize: 30, // Adjust font size
              fontWeight: FontWeight.bold, // Make it bold
              color: Colors.white, // White text color for contrast
            ),
          ),
          const SizedBox(height: 20), // Adds space between text and puzzle
          Align(
            alignment: Alignment.topCenter, // Align horizontally to the center
            child: Container(
              width: _tileSize * _gridSize +
                  _tileMargin * (_gridSize - 1) +
                  11, // Added extra 16px to width
              height: _tileSize * _gridSize +
                  _tileMargin * (_gridSize - 1) +
                  11, // Added extra 16px to height
              decoration: BoxDecoration(
                border: Border.all(
                  color:
                      const Color.fromARGB(255, 223, 178, 111), // Border color
                  width: 5, // Border width
                ),
                borderRadius:
                    BorderRadius.circular(8), // Optional: Rounded corners
              ),
              child: Stack(
                children: List.generate(
                  _gridSize * _gridSize, // 4x4 grid (16 tiles)
                  (index) =>
                      _buildTile(index), // Correctly handle tile positions
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build the tile widget for each number
  Widget _buildTile(int index) {
    int number = _numbers[index]; // Get the number for the current tile
    if (number == 0)
      return const SizedBox(); // Don't display the empty tile (0)

    // Calculate the row and column based on the tile's current position (index in _numbers)
    final int targetRow = index ~/ _gridSize;
    final int targetCol = index % _gridSize;

    return AnimatedPositioned(
      duration: _slideDuration,
      curve: Curves.easeInOut, // Animation curve for smooth motion
      top: targetRow *
          (_tileSize + _tileMargin), // Adjust position considering margin
      left: targetCol *
          (_tileSize + _tileMargin), // Adjust position considering margin
      child: GestureDetector(
        onTap: () => _onTileTap(index), // Handle tile tap
        child: Container(
          width: _tileSize - 6,
          height: _tileSize - 6,
          margin: EdgeInsets.all(_tileMargin), // Add margin between tiles
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 75, 41, 27),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: Text(
              '$number', // Display the number
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
