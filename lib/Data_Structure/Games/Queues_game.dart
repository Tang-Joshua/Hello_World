import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import '../Data_Choices.dart';

void main() => runApp(FifoGameApp());

class FifoGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FifoGame(),
    );
  }
}

class FifoGame extends StatefulWidget {
  @override
  _FifoGameState createState() => _FifoGameState();
}

class _FifoGameState extends State<FifoGame> {
  List<Map<String, dynamic>> queue = [];
  int score = 0;
  int lives = 3;
  bool isGameOver = false;
  bool gameStarted = false; // Tracks if the game has started
  late Timer itemAdder;
  late Timer countdownTimer;
  int timeLeft = 60;
  String currentInstruction = "";
  final Random random = Random();

  // List of card suits
  final List<String> cardSuits = ['♥', '♠', '♣', '♦'];

  @override
  void initState() {
    super.initState();
    generateNewInstruction();
  }

  void startGame() {
    setState(() {
      gameStarted = true;
    });

    // Start adding cards periodically
    itemAdder = Timer.periodic(Duration(seconds: 2), (timer) {
      if (!isGameOver && queue.length < 5) {
        setState(() {
          String suit = cardSuits[random.nextInt(cardSuits.length)];
          queue.add({
            'suit': suit,
            'color': (suit == '♥' || suit == '♦') ? Colors.red : Colors.black,
          });
        });

        if (queue.length == 5) {
          endGameWithMessage('Queue overflowed! The limit is 4 cards.');
        }
      }
    });

    // Start the countdown timer
    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!isGameOver) {
        setState(() {
          timeLeft--;
          if (timeLeft <= 0) {
            endGame();
          }
        });
      }
    });
  }

  void showInstructions() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            '🎮 How to Play',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.blue,
            ),
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📜 Instructions:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  decoration: TextDecoration.underline,
                ),
              ),
              SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                  children: [
                    TextSpan(text: '1️⃣ '),
                    TextSpan(
                      text:
                          'Follow the instructions shown at the top of the screen ',
                      style: TextStyle(color: Colors.green[800]),
                    ),
                    TextSpan(
                      text: '(e.g., Remove Card: ♥).\n\n',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(text: '2️⃣ '),
                    TextSpan(
                      text: 'Tap the ',
                      style: TextStyle(color: Colors.blue[800]),
                    ),
                    TextSpan(
                      text: '"Remove Latest Card" ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    TextSpan(
                      text: 'button to remove the latest card.\n\n',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(text: '3️⃣ '),
                    TextSpan(
                      text: 'Manage the queue carefully ',
                      style: TextStyle(color: Colors.orange[800]),
                    ),
                    TextSpan(
                      text:
                          '(max 4 cards allowed). If it reaches 5, you lose immediately!\n\n',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(text: '4️⃣ '),
                    TextSpan(
                      text: 'If you make a mistake, you lose a heart ',
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                      text: 'and the latest card is still removed.\n\n',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(text: '🎯 '),
                    TextSpan(
                      text: 'Goal: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent),
                    ),
                    TextSpan(
                      text:
                          'Get the highest score by removing the correct cards!',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Got It!',
              style: TextStyle(color: Colors.green, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  void generateNewInstruction() {
    setState(() {
      List<String> instructions = ['♥', '♠', '♣', '♦', 'Any'];
      currentInstruction = instructions[random.nextInt(instructions.length)];
    });
  }

  void processItem() {
    if (queue.isEmpty) return;

    setState(() {
      Map<String, dynamic> latestItem = queue.last;

      if (_doesItemMatchInstruction(latestItem)) {
        // Correct match: Remove the latest card and update score
        queue.removeLast();
        score++;
        generateNewInstruction();
      } else {
        // Mistake: Remove the latest card and lose a heart
        queue.removeLast();
        lives--;

        if (lives == 0) {
          endGame();
        }
      }
    });
  }

  bool _doesItemMatchInstruction(Map<String, dynamic> item) {
    if (currentInstruction == 'Any') return true;
    return item['suit'] == currentInstruction;
  }

  void endGame() {
    setState(() {
      isGameOver = true;
    });
    itemAdder.cancel();
    countdownTimer.cancel();
  }

  void endGameWithMessage(String message) {
    setState(() {
      isGameOver = true;
    });
    itemAdder.cancel();
    countdownTimer.cancel();
  }

  @override
  void dispose() {
    if (gameStarted) {
      itemAdder.cancel();
      countdownTimer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[700],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DataChoices())); // Go back to the previous screen
          },
        ),
        title:
            Text('FIFO Delivery Line', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: Colors.white),
            onPressed: showInstructions,
          ),
        ],
      ),
      body: isGameOver
          ? buildGameOverScreen()
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.timer, color: Colors.white, size: 20),
                          SizedBox(width: 4),
                          Text('$timeLeft',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                        ],
                      ),
                      Row(
                        children: List.generate(
                          3,
                          (index) => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Icon(
                              Icons.favorite,
                              color: index < lives ? Colors.red : Colors.grey,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.score, color: Colors.white, size: 20),
                          SizedBox(width: 4),
                          Text('$score',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 110), // Added space above "Remove Card"
                if (gameStarted) // Show "Remove Card" only after the game starts
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Remove Card:',
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 10),
                        Container(
                          width: 40,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            currentInstruction,
                            style: TextStyle(
                              fontSize: currentInstruction == 'Any'
                                  ? 16
                                  : 28, // Smaller size for "Any"
                              fontWeight: FontWeight.bold,
                              color: (currentInstruction == '♥' ||
                                      currentInstruction == '♦')
                                  ? Colors.red
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (!gameStarted) // Show Start Button initially
                  Center(
                    child: ElevatedButton(
                      onPressed: startGame,
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Start Game',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ),
                if (gameStarted) // Show Cards and Remove Button only after starting
                  ...[
                  SizedBox(height: 70),
                  Container(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: queue.length,
                      itemBuilder: (context, index) {
                        bool isLatest = index == queue.length - 1;
                        return Container(
                          width: 100,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: isLatest
                                ? Border.all(color: Colors.blueAccent, width: 3)
                                : null,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black38,
                                blurRadius: 8,
                                offset: Offset(3, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              queue[index]['suit'],
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: queue[index][
                                    'color'], // Red for hearts/diamonds, Black for clubs/spades
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 100),
                  ElevatedButton(
                    onPressed: processItem,
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Remove Latest Card',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ],
              ],
            ),
    );
  }

  Widget buildGameOverScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '💔 Game Over! 💔',
            style: TextStyle(
                fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 10),
          Text('Final Score: $score',
              style: TextStyle(fontSize: 24, color: Colors.white)),
          SizedBox(height: 20),
          Text(
            'Better luck next time! 🎲',
            style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                fontStyle: FontStyle.italic),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    resetGame();
                  });
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text('Retry',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
              ElevatedButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DataChoices())),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent),
                child: Text('Bakc to Menu',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void resetGame() {
    queue.clear();
    score = 0;
    lives = 3;
    timeLeft = 60;
    isGameOver = false;
    gameStarted = false; // Reset the game state
    generateNewInstruction();
  }
}
