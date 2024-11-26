import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import '../../Sorting_Choices.dart';

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

class MainMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "BookSorting",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            Text(
              "Main Menu",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 50),
            Text(
              "By A L - G O",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                letterSpacing: 2.5,
              ),
            ),
            SizedBox(height: 33),
            _buildMenuButton(context, "Single Player", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DifficultyScreen()),
              );
            }),
            _buildMenuButton(context, "How to Play", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HowToPlayScreen()),
              );
            }),
            _buildMenuButton(context, "Back", () {
              Navigator.push(
                context,

                // MaterialPageRoute(
                //     builder: (context) => GameSelectionInsertionScreen()),
                MaterialPageRoute(builder: (context) => SortingChoices()),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
      BuildContext context, String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 60, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}

class DifficultyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:
            Text("Select Difficulty", style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDifficultyButton(
                context, "Easy", 50, 5), // Easy mode: 50 seconds, 5 points
            _buildDifficultyButton(context, "Medium", 20,
                10), // Medium mode: 20 seconds, 10 points
            _buildDifficultyButton(
                context, "Hard", 15, 15), // Hard mode: 15 seconds, 15 points
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyButton(BuildContext context, String difficulty,
      int timerSeconds, int scoreGoal) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 60, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GameScreen(
                  singlePlayerTimeLimit: timerSeconds, scoreGoal: scoreGoal),
            ),
          );
        },
        child: Text(
          difficulty,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}

class HowToPlayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('How to Play', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
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
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.sort, color: Colors.blue, size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    'Objective:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Arrange the books in the correct order (Ascending or Descending) by dragging and dropping the numbers into the correct positions on the shelf.',
                style:
                    TextStyle(fontSize: 16, height: 1.5, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.timer, color: Colors.redAccent, size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    'Time Limit:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Each round has a set time limit. Finish arranging the books before the timer runs out!',
                style:
                    TextStyle(fontSize: 16, height: 1.5, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.score, color: Colors.green, size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    'Scoring:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Earn points for each correct arrangement. Reach the target score to win!',
                style:
                    TextStyle(fontSize: 16, height: 1.5, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange, size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    'Rules:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                '1. You can only drag books onto empty or valid slots.\n'
                '2. Clear the shelf to reset your arrangement if needed.\n'
                '3. If you run out of time, the game ends.',
                style:
                    TextStyle(fontSize: 16, height: 1.5, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              const Text(
                'Good luck and enjoy sorting!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  final int singlePlayerTimeLimit;
  final int scoreGoal;

  GameScreen({required this.singlePlayerTimeLimit, required this.scoreGoal});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int currentRound = 1;
  int timerSeconds = 30;
  int playerScore = 0;
  Timer? timer;
  List<int> numbers = [];
  List<int> targetOrder = [];
  List<int?> shelfOrder = [];
  bool ascendingOrder = true;

  static const int maxItemsPerRound = 10;

  @override
  void initState() {
    super.initState();
    timerSeconds = widget.singlePlayerTimeLimit;
    startNewRound();
  }

  void startNewRound() {
    setState(() {
      int itemCount = min(3 + currentRound, maxItemsPerRound);
      numbers = List.generate(itemCount, (_) => Random().nextInt(50));

      // Randomize ascending or descending order for each round
      ascendingOrder = Random().nextBool();

      // Sort targetOrder based on ascendingOrder
      targetOrder = List.from(numbers)..sort();
      if (!ascendingOrder) {
        targetOrder = targetOrder.reversed.toList();
      }

      shelfOrder = List<int?>.filled(itemCount, null);
      timerSeconds = widget.singlePlayerTimeLimit; // Set timer for new round
      resetTimer();
    });
  }

  void resetTimer() {
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timerSeconds > 0) {
          timerSeconds--;
        } else {
          timer.cancel();
          endTurn(false);
        }
      });
    });
  }

  void endTurn(bool successful) {
    timer?.cancel();

    if (successful) {
      playerScore++;
      currentRound++;
      if (playerScore >= widget.scoreGoal) {
        showWinnerDialog("You Win!");
      } else if (currentRound > 12) {
        showWinnerDialog("Game Over");
      } else {
        startNewRound();
      }
    } else {
      showGameOverDialog();
    }
  }

  void showWinnerDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Game Over'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              resetGame();
            },
            child: Text('Play Again', style: TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Game Over'),
        content: Text("Time's up! You didn't reach the required score."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              resetGame();
            },
            child: Text('Try Again', style: TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }

  void resetGame() {
    setState(() {
      currentRound = 1;
      playerScore = 0;
      timerSeconds = widget.singlePlayerTimeLimit;
      startNewRound();
    });
  }

  void checkIfSorted() {
    if (shelfOrder.contains(null)) return;

    if (_listsAreEqual(shelfOrder, targetOrder)) {
      endTurn(true);
    } else {
      endTurn(false);
    }
  }

  void clearShelf() {
    setState(() {
      shelfOrder = List<int?>.filled(shelfOrder.length, null);
      numbers = List.from(targetOrder);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final boxSize = isTablet ? 80.0 : 50.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:
            Text('Single Player Mode', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Arrange the books in ',
                    style: TextStyle(fontSize: 22, color: Colors.black54),
                  ),
                  TextSpan(
                    text: ascendingOrder ? 'Ascending' : 'Descending',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: ascendingOrder ? Colors.green : Colors.red,
                    ),
                  ),
                  TextSpan(
                    text: ' order.',
                    style: TextStyle(fontSize: 22, color: Colors.black54),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            'Time Remaining: $timerSeconds seconds',
            style: TextStyle(fontSize: 18, color: Colors.redAccent),
          ),
          SizedBox(height: 20),
          Text(
            'Score: $playerScore / ${widget.scoreGoal}',
            style: TextStyle(fontSize: 18, color: Colors.black87),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < shelfOrder.length; i++)
                DragTarget<int>(
                  onWillAcceptWithDetails: (details) => true,
                  onAcceptWithDetails: (details) {
                    setState(() {
                      int data = details.data;
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
                      width: boxSize,
                      height: boxSize,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: shelfOrder[i] != null
                            ? Colors.black87
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: candidateData.isNotEmpty
                              ? Colors.blue
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          shelfOrder[i]?.toString() ?? '',
                          style: TextStyle(
                            fontSize: isTablet ? 24 : 18,
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
                      feedback: BookWidget(
                          number: number, isDragging: true, boxSize: boxSize),
                      childWhenDragging: Opacity(
                        opacity: 0.3,
                        child: BookWidget(number: number, boxSize: boxSize),
                      ),
                      child: BookWidget(number: number, boxSize: boxSize),
                    ))
                .toList(),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: clearShelf,
            child: Text("Clear"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black87,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
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

class BookWidget extends StatelessWidget {
  final int number;
  final bool isDragging;
  final double boxSize;

  const BookWidget(
      {required this.number, this.isDragging = false, this.boxSize = 50.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: boxSize,
      height: boxSize,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDragging ? Colors.black87 : Colors.black54,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          number.toString(),
          style: TextStyle(
            fontSize: boxSize * 0.35,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
