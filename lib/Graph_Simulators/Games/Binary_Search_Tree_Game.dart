import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutterapp/Graph_Simulators/Graph_Choices.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(BinarySearchTreeGameApp());
}

class BinarySearchTreeGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Binary Search Tree Game',
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'CrimsonPro',
      ),
      home: MainMenuScreen(),
    );
  }
}

// Main Menu Screen
class MainMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Binary Search Tree Game',
            style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic)),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => GraphChoices()),
            );
          },
        ),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Binary Search Tree Game',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontStyle: FontStyle.italic,
              ),
            ),
            Text(
              'Algo',
              style: TextStyle(
                fontSize: 22,
                color: Colors.grey[400],
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 50),
            CustomButton(
              label: 'Play Game',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DifficultySelectionScreen()),
                );
              },
            ),
            SizedBox(height: 20),
            CustomButton(
              label: 'How to Play',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HowToPlayScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Difficulty Selection Screen
class DifficultySelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Difficulty',
            style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic)),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              label: 'Easy (50 sec)',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          BinaryTreeGameScreen(difficulty: 'Easy')),
                );
              },
            ),
            SizedBox(height: 20),
            CustomButton(
              label: 'Medium (30 sec)',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          BinaryTreeGameScreen(difficulty: 'Medium')),
                );
              },
            ),
            SizedBox(height: 20),
            CustomButton(
              label: 'Hard (25 sec)',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          BinaryTreeGameScreen(difficulty: 'Hard')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// How to Play Screen
class HowToPlayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'How to Play',
          style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How to Play',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.play_circle_outline,
                      color: Colors.green, size: 28),
                  SizedBox(width: 10),
                  Text(
                    'Game Objective',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Build a Binary Search Tree (BST) by selecting numbers from the deck. Your goal is to follow BST rules and complete the tree with at least 7 nodes per round.',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.grey[300],
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.rule, color: Colors.blue, size: 28),
                  SizedBox(width: 10),
                  Text(
                    'Rules',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                '1. Choose "Left" or "Right" before selecting a number.\n'
                '2. Numbers on the "Left" must be smaller than the parent node.\n'
                '3. Numbers on the "Right" must be larger than the parent node.\n'
                '4. Incorrect selections or running out of time ends the game.\n'
                '5. Complete 7 nodes to win the round.',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.grey[300],
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.timer, color: Colors.red, size: 28),
                  SizedBox(width: 10),
                  Text(
                    'Time Limit',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'You have a limited time based on the difficulty level:\n'
                '- Easy: 50 seconds\n'
                '- Medium: 30 seconds\n'
                '- Hard: 25 seconds',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.grey[300],
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: Colors.yellow, size: 28),
                  SizedBox(width: 10),
                  Text(
                    'Tips',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                '1. Think carefully before selecting a number.\n'
                '2. Use the rules of BST to guide your decisions.\n'
                '3. Complete as many rounds as possible!',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.grey[300],
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: Text(
                  'Good luck!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Game Screen
class BinaryTreeGameScreen extends StatefulWidget {
  final String difficulty;
  BinaryTreeGameScreen({required this.difficulty});

  @override
  _BinaryTreeGameScreenState createState() => _BinaryTreeGameScreenState();
}

class _BinaryTreeGameScreenState extends State<BinaryTreeGameScreen> {
  List<int> bstValues = [];
  int? lastInsertedValue;
  String feedback = 'Choose "Left" or "Right" and then select a number!';
  bool hasWon = false;
  bool isGameOver = false;
  String? selectedDirection;
  List<int> deck = List.generate(15, (index) => Random().nextInt(50) + 1);
  late AudioPlayer backgroundMusicPlayer; // For background music
  late AudioPlayer clickSoundPlayer; // For click sounds

  int round = 1;
  int timerValue = 50;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    setDifficulty(widget.difficulty);
    resetGame();
    _playBackgroundMusic(); // Play background music
  }

  void _playBackgroundMusic() async {
    backgroundMusicPlayer = AudioPlayer();
    try {
      await backgroundMusicPlayer
          .setReleaseMode(ReleaseMode.loop); // Loop music
      await backgroundMusicPlayer.setVolume(0.3); // Set volume
      await backgroundMusicPlayer.play(AssetSource('Sounds/binarysearch.mp3'));
    } catch (e) {
      print('Error playing background music: $e');
    }
  }

  void _playClickSound() async {
    clickSoundPlayer = AudioPlayer();
    try {
      await clickSoundPlayer.play(AssetSource('Sounds/binarysearchclick.mp3'));
    } catch (e) {
      print('Error playing click sound: $e');
    }
  }

  void _playWinSound() async {
    try {
      await clickSoundPlayer.play(AssetSource('Sounds/win.mp3'));
    } catch (e) {
      print('Error playing win sound: $e');
    }
  }

  void _playGameOverSound() async {
    try {
      final gameOverPlayer = AudioPlayer(); // Use a separate instance
      await gameOverPlayer.play(AssetSource('Sounds/gameover.mp3'));
    } catch (e) {
      print('Error playing game over sound: $e');
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    backgroundMusicPlayer.stop(); // Stop the background music
    backgroundMusicPlayer.dispose(); // Dispose of the player
    clickSoundPlayer.dispose(); // Dispose of the click sound player
    super.dispose();
  }

  void setDifficulty(String difficulty) {
    if (difficulty == 'Easy') {
      timerValue = 50;
    } else if (difficulty == 'Medium') {
      timerValue = 30;
    } else if (difficulty == 'Hard') {
      timerValue = 25;
    }
  }

  void startTimer() {
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        timerValue--;
        if (timerValue <= 0) {
          isGameOver = true;
          feedback = 'Time\'s up! Game Over.';
          timer.cancel();
          _playGameOverSound(); // Add this here if missing
        }
      });
    });
  }

  void resetGame() {
    setState(() {
      deck.shuffle();
      bstValues.clear();
      lastInsertedValue = null;
      feedback = 'Choose "Left" or "Right" and then select a number!';
      hasWon = false;
      isGameOver = false;
      selectedDirection = null;
      startTimer();
    });
  }

  void nextRound() {
    if (round < 5) {
      setState(() {
        round++;
        lastInsertedValue = null;
        bstValues.clear();
        feedback =
            'Round $round! Choose "Left" or "Right" and select a number.';
        selectedDirection = null;
        timerValue = widget.difficulty == 'Easy'
            ? 50
            : widget.difficulty == 'Medium'
                ? 30
                : 25;
        startTimer();
      });
    } else {
      setState(() {
        feedback = 'Congratulations! You completed all rounds!';
        hasWon = true;
        isGameOver = true;
        timer?.cancel();
        _playWinSound(); // Play win sound
      });
    }
  }

  void chooseDirection(String direction) {
    setState(() {
      selectedDirection = direction;
      feedback = 'You selected "$direction". Now pick a number from the deck.';
      _playClickSound(); // Play click sound
    });
  }

  void addNode(int value) {
    if (isGameOver || hasWon || selectedDirection == null) return;

    if (lastInsertedValue == null) {
      setState(() {
        lastInsertedValue = value;
        bstValues.add(value);
        feedback =
            'Root node set to $value. Choose "Left" or "Right" and pick the next number.';
        selectedDirection = null;
      });
      return;
    }

    bool isCorrect =
        (selectedDirection == "Left" && value < lastInsertedValue!) ||
            (selectedDirection == "Right" && value > lastInsertedValue!);

    if (!isCorrect) {
      setState(() {
        feedback = 'Incorrect choice! Game Over.';
        isGameOver = true;
        timer?.cancel();
        _playGameOverSound(); // Ensure this is called here
      });
      return;
    }

    setState(() {
      lastInsertedValue = value;
      bstValues.add(value);
      feedback = 'Correct! Choose "Left" or "Right" and pick the next number.';
      selectedDirection = null;

      if (bstValues.length >= 7) {
        feedback = 'Round Complete! Starting next round...';
        Future.delayed(Duration(seconds: 2), nextRound);
      }
    });
    _playClickSound();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Play Game - ${widget.difficulty}',
            style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic)),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            backgroundMusicPlayer.stop(); // Stop the background music
            Navigator.pop(context);
            timer?.cancel();
          },
        ),
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 300,
            child: Center(
              child: CustomPaint(
                painter: BinaryTreePainter(bstValues),
                child: Container(),
              ),
            ),
          ),
          Text(
            'Timer: $timerValue sec | Round: $round / 5',
            style: TextStyle(
                fontSize: 18, color: Colors.white, fontStyle: FontStyle.italic),
          ),
          SizedBox(height: 20),
          Text(
            feedback,
            style: TextStyle(
                fontSize: 18,
                color: isGameOver ? Colors.red : Colors.white,
                fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          if (isGameOver) ...[
            CustomButton(
              label: 'Try Again',
              onTap: resetGame,
            ),
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  label: 'Left',
                  selected: selectedDirection == "Left",
                  onTap: () => chooseDirection("Left"),
                  disabled: isGameOver || hasWon,
                ),
                SizedBox(width: 20),
                CustomButton(
                  label: 'Right',
                  selected: selectedDirection == "Right",
                  onTap: () => chooseDirection("Right"),
                  disabled: isGameOver || hasWon,
                ),
              ],
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: deck.map((value) {
                return ElevatedButton(
                  onPressed: bstValues.contains(value) ||
                          isGameOver ||
                          hasWon ||
                          selectedDirection == null
                      ? null
                      : () => addNode(value),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bstValues.contains(value)
                        ? Colors.grey[800]
                        : Colors.black,
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white),
                    padding: EdgeInsets.all(16),
                    textStyle: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  child: Text(value.toString()),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

// Painter class for visualizing the binary tree structure
class BinaryTreePainter extends CustomPainter {
  final List<int> bstValues;

  BinaryTreePainter(this.bstValues);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final nodePaint = Paint()
      ..color = Colors.grey[900]!
      ..style = PaintingStyle.fill;

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    final positions = [
      Offset(size.width / 2, 50), // root
      Offset(size.width / 4, 150), // level 1 left
      Offset(3 * size.width / 4, 150), // level 1 right
      Offset(size.width / 8, 250), // level 2 left-left
      Offset(size.width * 3 / 8, 250), // level 2 left-right
      Offset(size.width * 5 / 8, 250), // level 2 right-left
      Offset(size.width * 7 / 8, 250), // level 2 right-right
    ];

    for (int i = 0; i < bstValues.length; i++) {
      int value = bstValues[i];
      Offset pos = positions[i];

      canvas.drawCircle(pos, 20, nodePaint);
      canvas.drawCircle(pos, 20, paint);

      textPainter.text = TextSpan(
        text: value.toString(),
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontStyle: FontStyle.italic),
      );
      textPainter.layout();
      textPainter.paint(
          canvas, pos - Offset(textPainter.width / 2, textPainter.height / 2));

      if (i > 0) {
        Offset parentPos = positions[(i - 1) ~/ 2];
        canvas.drawLine(parentPos, pos, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// Custom button widget to handle styling for all buttons
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool disabled;
  final bool selected;

  CustomButton({
    required this.label,
    required this.onTap,
    this.disabled = false,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        decoration: BoxDecoration(
          color: disabled
              ? Colors.grey[800]
              : (selected ? Colors.white : Colors.black),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white, width: 1.5),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.black : Colors.white,
            fontSize: 18,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
