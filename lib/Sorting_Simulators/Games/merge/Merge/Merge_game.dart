import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:collection/collection.dart';

class MergeSortGamePage extends StatefulWidget {
  final String level;

  const MergeSortGamePage({Key? key, required this.level}) : super(key: key);

  @override
  State<MergeSortGamePage> createState() => _MergeSortGamePageState();
}

class _MergeSortGamePageState extends State<MergeSortGamePage> {
  late int timeRemaining;
  late int hearts;
  Timer? timer;
  int currentStage = 0;
  late List<int> givenValues;
  late List<List<List<int>>> mergeStages;
  late List<List<List<int>>> insertedStages;
  List<List<List<int>>> choices = [];
  bool isGameComplete = false;

  @override
  void initState() {
    super.initState();
    initializeGame();
    if (timeRemaining > 0) startTimer();
  }

  @override
  void dispose() {
    timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void initializeGame() {
    int numValues;
    Random random = Random();

    int parsedLevel = int.parse(widget.level);

    // Configure level-specific settings
    switch (parsedLevel) {
      case 1:
        numValues = 4;
        timeRemaining = 0;
        hearts = 0;
        break;
      case 2:
        numValues = 5;
        timeRemaining = 0;
        hearts = 0;
        break;
      case 3:
        numValues = 6;
        timeRemaining = 30;
        hearts = 0;
        break;
      case 4:
        numValues = 7;
        timeRemaining = 30;
        hearts = 0;
        break;
      case 5:
        numValues = 8;
        timeRemaining = 30;
        hearts = 3;
        break;
      case 6:
        numValues = 7;
        timeRemaining = 30;
        hearts = 3;
        break;
      case 7:
        numValues = random.nextBool() ? 4 : (random.nextBool() ? 6 : 8);
        timeRemaining = 15;
        hearts = 1;
        break;
      case 8:
        numValues = random.nextBool() ? 5 : 7;
        timeRemaining = 15;
        hearts = 1;
        break;
      default:
        numValues = 4;
        timeRemaining = 0;
        hearts = 0;
        break;
    }

    // Generate random given values and stages
    givenValues = List.generate(numValues, (_) => random.nextInt(50) + 1);
    mergeStages = generateMergeStages(givenValues, parsedLevel);

    // Reset inserted stages and choices
    insertedStages = [];
    generateChoices();

    // Reset game state
    currentStage = 0;
    isGameComplete = false;
  }

  List<List<List<int>>> generateMergeStages(List<int> values, int level) {
    List<List<List<int>>> stages = [];
    List<List<int>> current = values.map((value) => [value]).toList();

    while (current.length > 1) {
      List<List<int>> next = [];
      for (int i = 0; i < current.length; i += 2) {
        if (i + 1 < current.length) {
          next.add([...current[i], ...current[i + 1]]..sort());
        } else {
          next.add(current[i]);
        }
      }
      stages.add(next);
      current = next;
    }

    if (level == 2) {
      stages = [
        [
          [values[0], values[1]],
          [values[2]],
          [values[3], values[4]]
        ],
        [
          [values[0], values[1], values[2]],
          [values[3], values[4]]
        ],
        [
          [values[0], values[1], values[2], values[3], values[4]]
        ]
      ];
    } else if (level == 3) {
      stages = [
        [
          [values[0], values[1]],
          [values[2]],
          [values[3], values[4]],
          [values[5]]
        ],
        [
          [values[0], values[1], values[2]],
          [values[3], values[4], values[5]]
        ],
        [
          [values[0], values[1], values[2], values[3], values[4], values[5]]
        ]
      ];
    }

    return stages;
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeRemaining > 0) {
        setState(() {
          timeRemaining--;
        });
      } else {
        timer.cancel();
        showGameOverDialog("Time's up! Try again.");
      }
    });
  }

  void generateChoices() {
    List<List<int>> correctChoice = mergeStages[currentStage];

    List<List<int>> incorrectChoice1 = generateRandomChoice(correctChoice);
    List<List<int>> incorrectChoice2 = generateRandomChoice(correctChoice);

    choices = [correctChoice, incorrectChoice1, incorrectChoice2]..shuffle();
  }

  List<List<int>> generateRandomChoice(List<List<int>> correctChoice) {
    Random random = Random();
    List<List<int>> incorrectChoice = [];
    for (List<int> group in correctChoice) {
      incorrectChoice.add(List.from(group)..shuffle());
    }
    if (random.nextBool()) incorrectChoice.shuffle();
    return incorrectChoice;
  }

  void handleChoice(List<List<int>> selectedOption) {
    if (isCorrectChoice(selectedOption)) {
      setState(() {
        insertedStages.add(selectedOption);

        currentStage++;
        if (currentStage == mergeStages.length) {
          isGameComplete = true;
          timer?.cancel();
          showCompletionDialog();
        } else {
          generateChoices();
        }
      });
    } else {
      if (hearts > 0) {
        setState(() {
          hearts--;
        });
        if (hearts == 0) {
          showGameOverDialog("You ran out of hearts!");
        }
      } else {
        showIncorrectChoiceDialog();
      }
    }
  }

  bool isCorrectChoice(List<List<int>> selectedOption) {
    return ListEquality().equals(selectedOption, mergeStages[currentStage]);
  }

  void showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(
          child: Text(
            "🎉 Level Complete!",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "You have completed Level ${widget.level}!",
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Icon(Icons.check_circle, color: Colors.green, size: 48),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              resetGame();
            },
            child: const Text("Retry Level"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MergeSortGamePage(
                      level: (int.parse(widget.level) + 1).toString()),
                ),
              );
            },
            child: const Text("Next Level"),
          ),
        ],
      ),
    );
  }

  void showGameOverDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Game Over"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              resetGame();
            },
            child: const Text("Retry Level"),
          ),
        ],
      ),
    );
  }

  void showIncorrectChoiceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Incorrect Choice"),
        content: const Text("That was not the correct merge step. Try again!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void resetGame() {
    timer?.cancel();
    setState(() {
      initializeGame();
      if (timeRemaining > 0) startTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text("Merge Sort - Level ${widget.level}"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (timeRemaining > 0 || hearts > 0)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (timeRemaining > 0)
                      Text(
                        "⏳ Time: $timeRemaining",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    if (hearts > 0)
                      Row(
                        children: List.generate(
                          hearts,
                          (_) => const Icon(Icons.favorite, color: Colors.red),
                        ),
                      ),
                    Text(
                      "Stage: ${currentStage + 1} / ${mergeStages.length}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 170),
            buildGivenValues(),
            // Add spacing between givenValues and buildStage
            if (!isGameComplete) buildGameArea(),
            if (isGameComplete)
              const Center(
                child: Text(
                  "Congratulations! 🎉",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildGivenValues() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 6,
              spreadRadius: 2,
            ),
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: givenValues.map((value) {
            return Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEEEEEE),
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                value.toString(),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget buildGameArea() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...insertedStages.map((stage) => buildStage(stage)),
          const SizedBox(height: 80),
          if (!isGameComplete) buildChoices(),
          const SizedBox(height: 240),
        ],
      ),
    );
  }

  Widget buildStage(List<List<int>> stage) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: stage.map((group) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "{${group.join(', ')}}",
              style: const TextStyle(fontSize: 16),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buildChoices() {
    return Column(
      children: List.generate(choices.length, (index) {
        return GestureDetector(
          onTap: () => handleChoice(choices[index]),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: choices[index].map((group) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F1F1),
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "{${group.join(', ')}}",
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      }),
    );
  }
}
