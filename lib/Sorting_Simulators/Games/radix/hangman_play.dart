import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // Import audioplayers
import 'dart:math';

import '../../Sorting_Choices.dart';

void main() {
  runApp(RadixSortHangmanGame());
}

class RadixSortHangmanGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Radix Sort Hangman',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: RadixSortScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RadixSortScreen extends StatefulWidget {
  @override
  _RadixSortScreenState createState() => _RadixSortScreenState();
}

class _RadixSortScreenState extends State<RadixSortScreen> {
  List<int> _numbers = [];
  List<int?> _sortedList = [];
  List<int> _remainingNumbers = [];
  int _mistakes = 0;
  final int _maxMistakes = 6;
  bool _gameWon = false;
  bool _gameLost = false;
  int _currentDigitPlace = 1;
  List<int> _targetOrder = [];

  final AudioPlayer _audioPlayer = AudioPlayer(); // Background music player
  bool _isMusicPlaying = true; // To track music playback state

  // final AudioPlayer _audioPlayer = AudioPlayer(); // Background music player
  late AudioCache _audioCache; // Cache for preloading music
  // bool _isMusicPlaying = true; // To track music playback state

  @override
  void initState() {
    super.initState();
    _startGame();

    // Automatically play background music when the game starts
    _playBackgroundMusic();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showInstructions(context); // Automatically show instructions
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Stop and dispose of the background music player
    super.dispose();
  }

  void _startGame() {
    setState(() {
      _mistakes = 0;
      _gameWon = false;
      _gameLost = false;
      _numbers = _generateRandomNumbers();
      _sortedList = List<int?>.filled(_numbers.length, null);
      _remainingNumbers = List.from(_numbers);
      _currentDigitPlace = 1;
      _updateTargetOrder();
    });
  }

  void _playBackgroundMusic() async {
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop); // Enable looping
      await _audioPlayer.setVolume(0.2); // Set desired volume (50%)
      await _audioPlayer.play(AssetSource('Sounds/radix.mp3'));
    } catch (e) {
      print('Error playing background music: $e');
    }
  }

  void _playSound(String soundPath) async {
    try {
      await _audioPlayer.play(AssetSource(soundPath));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  void _toggleMusic() async {
    if (_isMusicPlaying) {
      await _audioPlayer.pause(); // Pause music
    } else {
      await _audioPlayer.resume(); // Resume music
    }
    setState(() {
      _isMusicPlaying = !_isMusicPlaying; // Toggle the music state
    });
  }

  List<int> _generateRandomNumbers() {
    final random = Random();
    return List.generate(
        8, (_) => random.nextInt(899) + 100); // 3-digit numbers
  }

  void _updateTargetOrder() {
    // Create a list of tuples with (index, number) to preserve original order
    List<MapEntry<int, int>> indexedNumbers = _numbers.asMap().entries.toList();

    // Sort based on the current digit and then by original position for stability
    indexedNumbers.sort((a, b) {
      int compareResult = _compareByCurrentDigit(a.value, b.value);
      return compareResult != 0 ? compareResult : a.key.compareTo(b.key);
    });

    // Update _targetOrder with the sorted numbers
    _targetOrder = indexedNumbers.map((entry) => entry.value).toList();
  }

  int _compareByCurrentDigit(int a, int b) {
    // Compare numbers based on the current digit place
    int aDigit = (a ~/ pow(10, _currentDigitPlace - 1)) % 10;
    int bDigit = (b ~/ pow(10, _currentDigitPlace - 1)) % 10;

    // Primary sort by the current digit place
    if (aDigit != bDigit) {
      return aDigit.compareTo(bDigit);
    }

    // If the current digit is the same, use the initial order as secondary criterion
    return 0;
  }

  void _onDragCompleted(int number) {
    setState(() {
      _remainingNumbers.remove(number);
      _checkGameStatus();
    });
  }

  void _checkGameStatus() {
    if (!_sortedList.contains(null)) {
      if (_currentDigitPlace < 3) {
        _advanceToNextDigitPlace();
      } else {
        _gameWon = true;
        _showEndGameDialog("Congratulations!",
            "You've successfully sorted the list."); // Winner sound will play here
      }
    } else if (_mistakes >= _maxMistakes) {
      _gameLost = true;
      _showEndGameDialog("Game Over", "You made too many mistakes.");
    }
  }

  void _advanceToNextDigitPlace() {
    setState(() {
      _currentDigitPlace++;
      _sortedList = List<int?>.filled(_numbers.length, null);
      _remainingNumbers = List.from(_numbers);
      _mistakes = 0; // Reset mistakes for the next level
      _updateTargetOrder();
    });
  }

  void _showEndGameDialog(String title, String message) {
    if (title.contains("Congratulations!")) {
      _playSound('Sounds/win.mp3'); // Play winner sound
    } else if (title.contains("Game Over")) {
      _playSound('Sounds/gameover.mp3'); // Optional: Play a "game over" sound
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _startGame();
              },
              child: Text("Play Again"),
            ),
          ],
        );
      },
    );
  }

  void _showInstructions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Instructions',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section: Objective
              Row(
                children: [
                  Icon(Icons.flag, color: Colors.green, size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    'Objective:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Sort the numbers into ascending order using the Radix Sort method.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),

              // Section: How to Play
              Row(
                children: [
                  Icon(Icons.play_arrow, color: Colors.blue, size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    'How to Play:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildInstructionStep(
                icon: Icons.drag_handle,
                text:
                    'Drag the numbers into the correct position for the current digit place.',
                iconColor: Colors.orange,
              ),
              _buildInstructionStep(
                icon: Icons.loop,
                text: 'Repeat for each digit place (ones, tens, hundreds).',
                iconColor: Colors.green,
              ),
              const SizedBox(height: 16),

              // Section: Rules
              Row(
                children: [
                  Icon(Icons.rule, color: Colors.red, size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    'Rules:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildInstructionStep(
                icon: Icons.warning,
                text: 'You have ${_maxMistakes} chances to make mistakes.',
                iconColor: Colors.red,
              ),
              _buildInstructionStep(
                icon: Icons.timer,
                text: 'Complete the game within the allowed mistakes to win.',
                iconColor: Colors.blue,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionStep({
    required IconData icon,
    required String text,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmQuitGame() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Quit Game"),
          content: Text("Are you sure you want to quit the game?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SortingChoices()));
              },
              child: Text("Quit"),
            ),
          ],
        );
      },
    );
  }

  void _onNumberPlaced(int number, int targetIndex) {
    if (_targetOrder[targetIndex] == number) {
      setState(() {
        _sortedList[targetIndex] = number;
        _onDragCompleted(number);
      });
    } else {
      setState(() {
        _mistakes++;
        if (_mistakes >= _maxMistakes) _gameLost = true;
        _checkGameStatus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Radix Sort Hangman'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _startGame,
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _confirmQuitGame,
          ),
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {
              _showInstructions(context); // Show instructions when tapped
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Place numbers in order according to digit place: $_currentDigitPlace',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Mistakes: $_mistakes / $_maxMistakes',
              style: TextStyle(
                fontSize: 14,
                color: _mistakes < _maxMistakes ? Colors.black : Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Expanded(
              child: Row(
                children: [
                  // Hangman figure
                  Expanded(
                    child: Center(
                      child: CustomPaint(
                        size: Size(100, 100),
                        painter: HangmanPainter(_mistakes),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  // Sorted list view
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text(
                          'Sorted List:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 4,
                          children: List.generate(_sortedList.length, (index) {
                            return DragTarget<int>(
                              builder: (context, candidateData, rejectedData) {
                                return Container(
                                  width: screenWidth / 10,
                                  height: screenWidth / 10,
                                  margin: EdgeInsets.symmetric(horizontal: 2),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 2),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    _sortedList[index]?.toString() ?? '',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              },
                              onWillAccept: (data) => true,
                              onAccept: (data) => _onNumberPlaced(data, index),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text('Drag a number to place:', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              children: _remainingNumbers.map((number) {
                return Draggable<int>(
                  data: number,
                  feedback: _buildNumberBox(number, screenWidth),
                  childWhenDragging: Container(
                      width: screenWidth / 10, height: screenWidth / 10),
                  child: _buildNumberBox(number, screenWidth),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberBox(int number, double screenWidth) {
    return Container(
      width: screenWidth / 10,
      height: screenWidth / 10,
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(8.0)),
      alignment: Alignment.center,
      child: Text(
        number.toString(),
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class HangmanPainter extends CustomPainter {
  final int mistakes;

  HangmanPainter(this.mistakes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4.0;

    // Gallows
    canvas.drawLine(Offset(size.width * 0.2, size.height),
        Offset(size.width * 0.8, size.height), paint); // base
    canvas.drawLine(Offset(size.width * 0.5, 0),
        Offset(size.width * 0.5, size.height), paint); // vertical post
    canvas.drawLine(Offset(size.width * 0.5, 0), Offset(size.width * 0.75, 0),
        paint); // top beam
    canvas.drawLine(Offset(size.width * 0.75, 0),
        Offset(size.width * 0.75, size.height * 0.2), paint); // rope

    // Hangman parts
    if (mistakes > 0)
      canvas.drawCircle(
          Offset(size.width * 0.75, size.height * 0.3), 10, paint); // head
    if (mistakes > 1)
      canvas.drawLine(Offset(size.width * 0.75, size.height * 0.35),
          Offset(size.width * 0.75, size.height * 0.5), paint); // body
    if (mistakes > 2)
      canvas.drawLine(Offset(size.width * 0.75, size.height * 0.4),
          Offset(size.width * 0.7, size.height * 0.45), paint); // left arm
    if (mistakes > 3)
      canvas.drawLine(Offset(size.width * 0.75, size.height * 0.4),
          Offset(size.width * 0.8, size.height * 0.45), paint); // right arm
    if (mistakes > 4)
      canvas.drawLine(Offset(size.width * 0.75, size.height * 0.5),
          Offset(size.width * 0.7, size.height * 0.6), paint); // left leg
    if (mistakes > 5)
      canvas.drawLine(Offset(size.width * 0.75, size.height * 0.5),
          Offset(size.width * 0.8, size.height * 0.6), paint); // right leg
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
