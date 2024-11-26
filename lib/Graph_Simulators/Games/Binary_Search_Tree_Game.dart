import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(BinarySearchTreeGameApp());
}

class BinarySearchTreeGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Binary Search Tree Game',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
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
            Navigator.pop(
                context); // Goes back to the previous screen or exits if no previous screen exists
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
      appBar: AppBar(
        title: Text('How to Play',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'The goal is to build a binary search tree by selecting numbers from the deck.\n\n'
          '1. Choose a direction ("Left" or "Right") before picking a number.\n'
          '2. "Left" means pick a number smaller than the previous one.\n'
          '3. "Right" means pick a number larger than the previous one.\n'
          '4. Incorrect selections will end the game.\n'
          '5. Completing 7 nodes following the rules will win the game.\n\n'
          'Good luck!',
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontStyle: FontStyle.italic),
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

  int round = 1;
  int timerValue = 50;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    setDifficulty(widget.difficulty);
    resetGame();
  }

  @override
  void dispose() {
    timer?.cancel();
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
      });
    }
  }

  void chooseDirection(String direction) {
    setState(() {
      selectedDirection = direction;
      feedback = 'You selected "$direction". Now pick a number from the deck.';
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