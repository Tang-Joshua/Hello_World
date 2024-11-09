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
      title: 'Merge Sort Game',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MergeSortMergeScreen(),
    );
  }
}

class MergeSortMergeScreen extends StatefulWidget {
  const MergeSortMergeScreen({super.key});

  @override
  _MergeSortMergeScreenState createState() => _MergeSortMergeScreenState();
}

class _MergeSortMergeScreenState extends State<MergeSortMergeScreen> {
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
  int currentLevel = 1;
  int maxTimeInSeconds = 60;

  @override
  void initState() {
    super.initState();
    _generateRandomNumbers();
  }

  void _generateRandomNumbers() {
    Random random = Random();
    int numberOfDigits = currentLevel + 2;
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
    timer?.cancel();
    super.dispose();
  }

  Future<void> _startSorting() async {
    stopwatch.reset();
    stopwatch.start();

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateElapsedTime();
    });

    List<int> numbers = List.from(randomNumbers);
    List<List<int>> steps = await _mergeSort(numbers);

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
      timer?.cancel();
      stopwatch.stop();

      setState(() {
        elapsedTime = "00:00";
        gameOver = true;
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Times Up!",
              style: TextStyle(fontSize: 24, color: Colors.red),
            ),
            content: const Text("You ran out of time!"),
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
    } else {
      final minutes = (remainingTime ~/ 60).toString().padLeft(2, '0');
      final seconds = (remainingTime % 60).toString().padLeft(2, '0');
      setState(() {
        elapsedTime = "$minutes:$seconds";
      });
    }
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
      elapsedTime = "05:00";
      stopwatch.reset();
      timer?.cancel();
    });
    _generateRandomNumbers();
  }

  Future<List<List<int>>> _mergeSort(List<int> numbers) async {
    List<List<int>> steps = [];
    await _mergeSortRecursive(numbers, 0, numbers.length - 1, steps);
    return steps;
  }

  Future<void> _mergeSortRecursive(
      List<int> numbers, int left, int right, List<List<int>> steps) async {
    if (left < right) {
      int mid = (left + right) ~/ 2;
      await _mergeSortRecursive(numbers, left, mid, steps);
      await _mergeSortRecursive(numbers, mid + 1, right, steps);
      _merge(numbers, left, mid, right);
      steps.add(List.from(numbers));
    }
  }

  void _merge(List<int> numbers, int left, int mid, int right) {
    int n1 = mid - left + 1;
    int n2 = right - mid;

    List<int> leftArray = List.filled(n1, 0);
    List<int> rightArray = List.filled(n2, 0);

    for (int i = 0; i < n1; i++) {
      leftArray[i] = numbers[left + i];
    }
    for (int j = 0; j < n2; j++) {
      rightArray[j] = numbers[mid + 1 + j];
    }

    int i = 0, j = 0;
    int k = left;

    while (i < n1 && j < n2) {
      if (leftArray[i] <= rightArray[j]) {
        numbers[k] = leftArray[i];
        i++;
      } else {
        numbers[k] = rightArray[j];
        j++;
      }
      k++;
    }

    while (i < n1) {
      numbers[k] = leftArray[i];
      i++;
      k++;
    }

    while (j < n2) {
      numbers[k] = rightArray[j];
      j++;
      k++;
    }
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
        gameOver = true;
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Game Over",
              style: TextStyle(fontSize: 24, color: Colors.red),
            ),
            content: const Text("You Lose!"),
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

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Congratulations! You completed Level $currentLevel",
              style: const TextStyle(fontSize: 24, color: Colors.green),
            ),
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
                      elapsedTime = "00:00";
                    });
                    _generateRandomNumbers();
                  },
                ),
              TextButton(
                child: const Text("Play Again"),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    currentLevel = 1;
                    randomNumbers = [];
                    stepControllers = [];
                    sortedNumbers = [];
                    numberVisibility = [];
                    gameOver = false;
                    gameWon = false;
                    elapsedTime = "00:00";
                  });
                  _generateRandomNumbers();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Merge Sort Game'),
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
                      width: 3.0,
                    ),
                  ),
                  child: AutoSizeText(
                    ' ${randomNumbers.join(", ")}',
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
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
                      width: 3.0,
                    ),
                  ),
                  child: Text(
                    'Level $currentLevel',
                    style: const TextStyle(
                      fontSize: 23,
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                    ),
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
                color: Color.fromARGB(255, 51, 167, 109),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.lightBlue[100],
                  border: Border.all(
                    color: const Color.fromARGB(255, 16, 161, 64),
                    width: 8.0,
                  ),
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
            if (gameWon)
              const Text(
                'You Win!',
                style: TextStyle(fontSize: 24, color: Colors.green),
              ),
            const SizedBox(height: 16.0),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Spacer(),
              const Spacer(),
              Text(
                'Time: $elapsedTime',
                style: const TextStyle(
                    fontSize: 30, color: Color.fromARGB(255, 255, 255, 255)),
              ),
              const Spacer(),
            ])
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
          color: const Color.fromARGB(255, 29, 96, 128),
          width: 5.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        isVisible ? controller.text : '?',
        style: const TextStyle(
          fontSize: 33.0,
          color: Color.fromARGB(255, 0, 0, 0),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
