import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(BookshelfGame());
}

class BookshelfGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
        title: Text('Number Organizer Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameScreen()),
                );
              },
              child: Text('Start Game'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HowToPlayScreen()),
                );
              },
              child: Text('How to Play'),
            ),
          ],
        ),
      ),
    );
  }
}

// How to Play Screen with Instructions
class HowToPlayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('How to Play'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'How to Play',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              '1. You are given a set of numbers that represent books.\n\n'
              '2. Your objective is to drag and drop each number onto the shelf in the correct order.\n\n'
              '3. The correct order can be ascending or descending, and it will be specified for each round.\n\n'
              '4. You must complete the arrangement before the timer runs out.\n\n'
              '5. Each round, the game becomes more challenging by increasing the number of books and reducing the time available.\n\n'
              '6. If you arrange the books correctly, you proceed to the next round. If not, or if time runs out, the game is over.\n\n'
              'Good luck and have fun!',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to Main Menu
              },
              child: Text('Back to Main Menu'),
            ),
          ],
        ),
      ),
    );
  }
}

// Game Screen with Pause Menu
class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int currentRound = 1;
  int timerSeconds = 30;
  Timer? timer;
  List<int> numbers = [];
  List<int> targetOrder = [];
  List<int?> shelfOrder = [];
  bool ascendingOrder = true;

  @override
  void initState() {
    super.initState();
    startNewRound();
  }

  void startNewRound() {
    final itemCount = 3 + currentRound;
    numbers = List.generate(itemCount, (_) => Random().nextInt(50));
    ascendingOrder = Random().nextBool();
    targetOrder = List.from(numbers)..sort();
    if (!ascendingOrder) {
      targetOrder = targetOrder.reversed.toList();
    }
    shelfOrder = List<int?>.filled(itemCount, null);
    resetTimer();

    setState(() {});
  }

  void resetTimer() {
    timer?.cancel();
    timerSeconds = 30;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timerSeconds > 0) {
          timerSeconds--;
        } else {
          timer.cancel();
          showGameOverDialog();
        }
      });
    });
  }

  void showGameOverDialog() {
    timer?.cancel();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Game Over'),
        content: Text('You sorted the books incorrectly or time ran out!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              resetGame();
            },
            child: Text('Try Again'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Text('Back to Main Menu'),
          ),
        ],
      ),
    );
  }

  void checkIfSorted() {
    if (shelfOrder.contains(null)) return;

    if (!_listsAreEqual(shelfOrder, targetOrder)) {
      showGameOverDialog();
    } else if (currentRound < 10) {
      currentRound++;
      startNewRound();
    } else {
      timer?.cancel();
      showEndGameDialog();
    }
  }

  void showEndGameDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Congratulations!'),
        content: Text('You completed all rounds successfully!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              resetGame();
            },
            child: Text('Play Again'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Text('Back to Main Menu'),
          ),
        ],
      ),
    );
  }

  void resetGame() {
    setState(() {
      currentRound = 1;
      startNewRound();
    });
  }

  void pauseGame() {
    timer?.cancel();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Paused'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              resetTimer(); // Resume timer
            },
            child: Text('Resume'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HowToPlayScreen()),
              );
            },
            child: Text('How to Play'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Text('Back to Main Menu'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookshelf Organizer - Round $currentRound'),
        actions: [
          IconButton(
            icon: Icon(Icons.pause),
            onPressed: pauseGame,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Arrange the books in ${ascendingOrder ? "ascending" : "descending"} order on the shelf.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ),
          Text(
            'Time Remaining: $timerSeconds seconds',
            style: TextStyle(fontSize: 20, color: Colors.red),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < shelfOrder.length; i++)
                DragTarget<int>(
                  onWillAcceptWithDetails: (details) => true,
                  onAccept: (data) {
                    setState(() {
                      if (shelfOrder[i] != null) {
                        numbers.add(shelfOrder[i]!);
                      }
                      shelfOrder[i] = data;
                      numbers.remove(data);
                    });
                    checkIfSorted();
                  },
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      width: 60,
                      height: 80,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: shelfOrder[i] != null
                            ? Colors.orange
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.brown, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          shelfOrder[i]?.toString() ?? '',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
          SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.center,
            children: numbers
                .map((number) => Draggable<int>(
                      data: number,
                      feedback: BookWidget(number: number, isDragging: true),
                      childWhenDragging: Opacity(
                        opacity: 0.3,
                        child: BookWidget(number: number),
                      ),
                      child: BookWidget(number: number),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  bool _listsAreEqual(List<int?> list1, List<int> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }
}

// Book Widget
class BookWidget extends StatelessWidget {
  final int number;
  final bool isDragging;

  const BookWidget({required this.number, this.isDragging = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 80,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDragging ? Colors.orangeAccent : Colors.orange,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          if (!isDragging)
            BoxShadow(
              color: Colors.black26,
              offset: Offset(2, 2),
              blurRadius: 4,
            ),
        ],
      ),
      child: Center(
        child: Text(
          number.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
