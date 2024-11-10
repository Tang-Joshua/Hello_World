import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';

void main() {
  runApp(RadixSortApp());
}

class RadixSortApp extends StatelessWidget {
  const RadixSortApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Radix Sort Game',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: RadixSortScreen(),
    );
  }
}

class RadixSortScreen extends StatefulWidget {
  const RadixSortScreen({super.key});

  @override
  _RadixSortScreenState createState() => _RadixSortScreenState();
}

class _RadixSortScreenState extends State<RadixSortScreen> {
  List<int> randomNumbers = [];
  List<List<TextEditingController>> stepControllers = [];
  List<int> sortedNumbers = [];
  List<List<bool>> numberVisibility = [];
  Stopwatch stopwatch = Stopwatch();
  String elapsedTime = "01:00";
  Timer? timer;
  int? targetNumber;
  bool gameOver = false;
  bool gameWon = false;
  int currentLevel = 1; // Track the current level (1-5)
  int maxTimeInSeconds = 60; // 1 minute timer for each level
  int lives = 3; // Initialize with 3 lives for levels 1-5

  @override
  void initState() {
    super.initState();
    _generateRandomNumbers();
  }

  void _generateRandomNumbers() {
    Random random = Random();
    int numberOfDigits =
        currentLevel + 2; // Increase difficulty with more digits
    randomNumbers = List.generate(
        5,
        (_) =>
            pow(10, numberOfDigits - 1).toInt() +
            random.nextInt(pow(10, numberOfDigits).toInt() -
                pow(10, numberOfDigits - 1).toInt()));
    _startSorting();
    _pickTargetNumber();
  }

  void _pickTargetNumber() {
    Random random = Random();
    targetNumber = randomNumbers[random.nextInt(randomNumbers.length)];
  }

  @override
  void dispose() {
    for (var step in stepControllers) {
      for (var controller in step) {
        controller.dispose();
      }
    }
    _cancelTimer();
    super.dispose();
  }

  void _cancelTimer() {
    timer?.cancel();
    timer = null;
    stopwatch.stop();
  }

  Future<void> _startSorting() async {
    _cancelTimer(); // Cancel any existing timer
    stopwatch.reset();
    stopwatch.start();

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateElapsedTime();
    });

    List<int> numbers = List.from(randomNumbers);
    int maxDigits = _getMaxDigits(numbers);
    List<List<int>> steps = [];

    for (int digitPlace = 1; digitPlace <= maxDigits; digitPlace++) {
      steps.add(List.from(numbers));
      numbers = await _radixSortStep(numbers, digitPlace);
    }

    sortedNumbers = List.from(numbers);
    steps.add(List.from(sortedNumbers));

    setState(() {
      stepControllers = steps.map((step) {
        return step
            .map((number) => TextEditingController(text: number.toString()))
            .toList();
      }).toList();

      numberVisibility = List.generate(stepControllers.length,
          (_) => List.generate(stepControllers[0].length, (_) => false));
    });
  }

  void _updateElapsedTime() {
    final elapsedSeconds = stopwatch.elapsed.inSeconds;
    final remainingTime = maxTimeInSeconds - elapsedSeconds;

    if (remainingTime <= 0) {
      _cancelTimer();
      setState(() {
        elapsedTime = "00:00";
        gameOver = true;
      });
      _showGameOverDialog("Time's up! You ran out of time.");
    } else {
      final minutes = (remainingTime ~/ 60).toString().padLeft(2, '0');
      final seconds = (remainingTime % 60).toString().padLeft(2, '0');
      setState(() {
        elapsedTime = "$minutes:$seconds";
      });
    }
  }

  void _showGameOverDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Game Over",
              style: TextStyle(fontSize: 24, color: Colors.red)),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("Try Again"),
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
            ),
          ],
        );
      },
    );
  }

  void _resetGame() {
    setState(() {
      currentLevel = 1;
      randomNumbers = [];
      stepControllers = [];
      sortedNumbers = [];
      numberVisibility = [];
      gameOver = false;
      gameWon = false;
      elapsedTime = "01:00";
      lives = 3; // Reset lives for a full restart
      _cancelTimer(); // Ensure the timer is canceled and reset
    });
    _generateRandomNumbers();
  }

  Future<List<int>> _radixSortStep(List<int> numbers, int digitPlace) async {
    int radix = 10;
    List<List<int>> buckets = List.generate(radix, (_) => []);

    for (int num in numbers) {
      int digit = (num ~/ pow(radix, digitPlace - 1)) % radix;
      buckets[digit].add(num);
    }

    return buckets.expand((bucket) => bucket).toList();
  }

  int _getMaxDigits(List<int> numbers) {
    return numbers
        .map((num) => num.toString().length)
        .reduce((a, b) => a > b ? a : b);
  }

  void _handleSelection(int number, int index, int idx) {
    if (gameOver || gameWon) return;

    if (number == targetNumber) {
      setState(() {
        numberVisibility[index][idx] = true;
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        checkGameWin();
      });
    } else {
      setState(() {
        lives -= 1;
        if (lives <= 0) {
          gameOver = true;
          _showGameOverDialog("No lives left! You Lose!");
        } else {
          _showWrongSelectionDialog();
        }
      });
    }
  }

  // Show "Wrong!" popup dialog for incorrect selection
  void _showWrongSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Wrong!", style: TextStyle(color: Colors.red)),
          content: const Text("That's the wrong card."),
        );
      },
    );

    // Dismiss the dialog automatically after 1 second
    Timer(const Duration(seconds: 1), () {
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    });
  }

  void checkGameWin() {
    bool allTargetNumbersRevealed = true;

    for (int i = 0; i < stepControllers.length; i++) {
      for (int j = 0; j < stepControllers[i].length; j++) {
        if (int.parse(stepControllers[i][j].text) == targetNumber &&
            !numberVisibility[i][j]) {
          allTargetNumbersRevealed = false;
          break;
        }
      }
    }

    if (allTargetNumbersRevealed) {
      setState(() {
        gameWon = true;
      });
      _showWinDialog();
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Congratulations! Level $currentLevel Complete",
              style: const TextStyle(fontSize: 24, color: Colors.green)),
          content: Text(currentLevel < 5
              ? "Proceed to the next level?"
              : "You have completed all levels!"),
          actions: [
            if (currentLevel < 5)
              TextButton(
                child: const Text("Next Level"),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    currentLevel++;
                    randomNumbers = [];
                    stepControllers = [];
                    sortedNumbers = [];
                    numberVisibility = [];
                    gameOver = false;
                    gameWon = false;
                    elapsedTime = "01:00"; // Reset time for the next level
                  });
                  _generateRandomNumbers();
                },
              ),
            TextButton(
              child: const Text("Play Again"),
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame(); // Reset lives and levels when starting over
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Radix Sort Game'),
        backgroundColor: const Color.fromARGB(255, 26, 77, 100),
      ),
      backgroundColor: const Color.fromARGB(255, 44, 82, 107),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  constraints: const BoxConstraints(maxWidth: 330.0),
                  padding: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 82, 82, 82),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                        color: const Color.fromARGB(255, 82, 82, 82),
                        width: 3.0),
                  ),
                  child: AutoSizeText(
                    ' ${randomNumbers.join(", ")}',
                    style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255)),
                    maxLines: 1,
                    minFontSize: 10,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 82, 82, 82),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                        color: const Color.fromARGB(255, 82, 82, 82),
                        width: 3.0),
                  ),
                  child: Text(
                    'Level $currentLevel',
                    style: const TextStyle(
                        fontSize: 23,
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14.0),
            Text(
              'Find the number: $targetNumber',
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 51, 167, 109)),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.lightBlue[100],
                  border: Border.all(
                      color: const Color.fromARGB(255, 16, 161, 64),
                      width: 8.0),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ListView.builder(
                  itemCount: stepControllers.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: stepControllers[index]
                                .asMap()
                                .entries
                                .map((entry) {
                              int idx = entry.key;
                              TextEditingController controller = entry.value;
                              return GestureDetector(
                                onTap: () {
                                  if (!numberVisibility[index][idx]) {
                                    _handleSelection(
                                        int.parse(controller.text), index, idx);
                                  }
                                },
                                child: _buildNumberBox(
                                    controller, numberVisibility[index][idx]),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Text(
                  'Lives: $lives',
                  style: const TextStyle(
                      fontSize: 28,
                      color: Colors.red,
                      fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  'Time: $elapsedTime',
                  style: const TextStyle(fontSize: 28, color: Colors.white),
                ),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberBox(TextEditingController controller, bool isVisible) {
    return Container(
      margin: const EdgeInsets.all(9.0),
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            color: const Color.fromARGB(255, 29, 96, 128), width: 5.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        isVisible ? controller.text : '?',
        style: const TextStyle(
            fontSize: 33.0,
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
