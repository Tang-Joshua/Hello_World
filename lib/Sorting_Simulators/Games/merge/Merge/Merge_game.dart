import 'package:flutter/material.dart';
import 'dart:async';

class MergeSortGamePage extends StatefulWidget {
  final String level;

  const MergeSortGamePage({Key? key, required this.level}) : super(key: key);

  @override
  State<MergeSortGamePage> createState() => _MergeSortGamePageState();
}

class _MergeSortGamePageState extends State<MergeSortGamePage> {
  late Map<String, dynamic> currentLevelData;
  late List<int> givenValues;
  late List<Map<String, dynamic>> stages;
  late List<List<List<int>>> visualizedStages; // Tracks user progress
  int currentStage = 0;
  late int timeRemaining;
  late int hearts;
  bool isGameComplete = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    initializeGame();
    if (timeRemaining > 0) startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void initializeGame() {
    // Load level-specific data
    currentLevelData = getLevelData()[widget.level]!;

    // Configure level data
    givenValues = currentLevelData["given"];
    stages = currentLevelData["stages"];
    timeRemaining = currentLevelData["time"] ?? 0;
    hearts = currentLevelData["hearts"] ?? 0;

    // Initialize visualization with the given values as the first stage
    visualizedStages = [
      givenValues.map((value) => [value]).toList()
    ];

    // Reset state
    currentStage = 0;
    isGameComplete = false;
  }

  Map<String, Map<String, dynamic>> getLevelData() {
    return {
      // Level 1
      "1": {
        "given": [4, 8, 3, 1],
        "stages": [
          {
            "correct": [
              [4, 8],
              [1, 3]
            ],
            "choices": [
              [
                [1, 4],
                [3, 8]
              ], // Incorrect
              [
                [4],
                [8, 3],
                [1]
              ], // Incorrect
              [
                [4, 8],
                [1, 3]
              ], // Correct
            ],
          },
          {
            "correct": [
              [1, 3, 4, 8]
            ],
            "choices": [
              [
                [1, 3, 4, 8]
              ], // Correct
              [
                [4, 8, 1, 3]
              ], // Incorrect
              [
                [1, 4, 3, 8]
              ], // Incorrect
            ],
          },
        ],
        "time": 0,
        "hearts": 0,
      },

      // Level 2
      "2": {
        "given": [35, 10, 40, 5, 25],
        "stages": [
          {
            "correct": [
              [10, 35],
              [40],
              [5, 25]
            ],
            "choices": [
              [
                [5, 10],
                [25, 35],
                [40]
              ], // Incorrect
              [
                [10, 35],
                [40],
                [5, 25]
              ], // Correct
              [
                [5, 25],
                [10, 35],
                [40]
              ], // Incorrect
            ],
          },
          {
            "correct": [
              [10, 35, 40],
              [5, 25]
            ],
            "choices": [
              [
                [5, 10, 25],
                [35, 40]
              ], // Incorrect
              [
                [5, 25, 10],
                [35, 40]
              ], // Incorrect
              [
                [10, 35, 40],
                [5, 25]
              ], // Correct
            ],
          },
          {
            "correct": [
              [5, 10, 25, 35, 40]
            ],
            "choices": [
              [
                [5, 10, 25, 35, 40]
              ], // Correct
              [
                [5, 25, 10, 35, 40]
              ], // Incorrect
              [
                [10, 5, 25, 40, 35]
              ], // Incorrect
            ],
          },
        ],
        "time": 0,
        "hearts": 0,
      },

      // Level 3
      "3": {
        "given": [12, 15, 7, 9, 3, 11],
        "stages": [
          {
            "correct": [
              [12, 15],
              [7],
              [9, 3],
              [11]
            ],
            "choices": [
              [
                [12, 15],
                [7],
                [9, 3],
                [11]
              ], // Correct
              [
                [12, 15],
                [7, 9],
                [3, 11]
              ], // Incorrect
              [
                [12, 15, 7],
                [9, 3, 11]
              ], // Incorrect
            ],
          },
          {
            "correct": [
              [12, 15, 7],
              [9, 3, 11]
            ],
            "choices": [
              [
                [7, 9, 12, 15],
                [3, 11]
              ], // Incorrect
              [
                [12, 15, 7],
                [9, 3, 11]
              ], // Correct
              [
                [7, 15, 9, 12],
                [11, 3]
              ], // Incorrect
            ],
          },
          {
            "correct": [
              [3, 7, 9, 11, 12, 15]
            ],
            "choices": [
              [
                [3, 7, 9, 11, 12, 15]
              ], // Correct
              [
                [7, 9, 3, 12, 15, 11]
              ], // Incorrect
              [
                [15, 12, 11, 9, 7, 3]
              ], // Incorrect
            ],
          },
        ],
        "time": 20,
        "hearts": 0,
      },

      // Level 4
      "4": {
        "given": [14, 28, 7, 21, 10, 3, 17],
        "stages": [
          {
            "correct": [
              [14, 28],
              [7, 21],
              [10, 3],
              [17]
            ],
            "choices": [
              [
                [14, 7],
                [28, 21],
                [10, 3],
                [17]
              ], // Incorrect
              [
                [28, 14],
                [7, 21],
                [3, 10],
                [17]
              ], // Incorrect
              [
                [14, 28],
                [7, 21],
                [10, 3],
                [17]
              ], // Correct (Repositioned to last)
            ],
          },
          {
            "correct": [
              [7, 14, 21, 28],
              [3, 10, 17]
            ],
            "choices": [
              [
                [7, 14, 21, 28],
                [3, 10, 17]
              ], // Correct (Now first)
              [
                [14, 7, 28, 21],
                [3, 10, 17]
              ], // Incorrect
              [
                [3, 7, 10, 14],
                [21, 28, 17]
              ], // Incorrect
            ],
          },
          {
            "correct": [
              [3, 7, 10, 14, 17, 21, 28]
            ],
            "choices": [
              [
                [7, 14, 3, 10, 28, 21, 17]
              ], // Incorrect
              [
                [28, 21, 17, 14, 10, 7, 3]
              ], // Incorrect
              [
                [3, 7, 10, 14, 17, 21, 28]
              ], // Correct (Repositioned to last)
            ],
          },
        ],
        "time": 20,
        "hearts": 0,
      },

// Level 5
      "5": {
        "given": [20, 8, 15, 5, 12, 10],
        "stages": [
          {
            "correct": [
              [20, 8],
              [15, 5],
              [12, 10]
            ],
            "choices": [
              [
                [8, 20],
                [5, 15],
                [10, 12]
              ], // Incorrect
              [
                [20, 15],
                [8, 5],
                [12, 10]
              ], // Incorrect
              [
                [20, 8],
                [15, 5],
                [12, 10]
              ], // Correct
            ],
          },
          {
            "correct": [
              [5, 8, 15, 20],
              [10, 12]
            ],
            "choices": [
              [
                [5, 8, 15, 20],
                [10, 12]
              ], // Correct
              [
                [5, 10],
                [8, 15],
                [12, 20]
              ], // Incorrect
              [
                [15, 8],
                [5, 20],
                [10, 12]
              ], // Incorrect
            ],
          },
          {
            "correct": [
              [5, 8, 10, 12, 15, 20]
            ],
            "choices": [
              [
                [8, 10, 5, 12, 20, 15]
              ], // Incorrect
              [
                [5, 8, 10, 12, 15, 20]
              ], // Correct
              [
                [20, 15, 12, 10, 8, 5]
              ], // Incorrect
            ],
          },
        ],
        "time": 20,
        "hearts": 3,
      },

// Level 6
      "6": {
        "given": [42, 35, 10, 18, 25, 50, 8],
        "stages": [
          {
            "correct": [
              [8, 10],
              [18, 25],
              [35, 42],
              [50]
            ],
            "choices": [
              [
                [8, 18],
                [10, 25],
                [42, 35],
                [50]
              ], // Incorrect
              [
                [10, 8],
                [25, 18],
                [35, 42],
                [50]
              ], // Incorrect
              [
                [8, 10],
                [18, 25],
                [35, 42],
                [50]
              ], // Correct
            ],
          },
          {
            "correct": [
              [8, 10, 18, 25],
              [35, 42, 50]
            ],
            "choices": [
              [
                [10, 8, 18, 25],
                [42, 35, 50]
              ], // Incorrect
              [
                [8, 10, 18, 25],
                [35, 42, 50]
              ], // Correct
              [
                [8, 18, 10, 25],
                [35, 50, 42]
              ], // Incorrect
            ],
          },
          {
            "correct": [
              [8, 10, 18, 25, 35, 42, 50]
            ],
            "choices": [
              [
                [50, 42, 35, 25, 18, 10, 8]
              ], // Incorrect
              [
                [8, 10, 18, 25, 35, 42, 50]
              ], // Correct
              [
                [18, 10, 8, 25, 42, 35, 50]
              ], // Incorrect
            ],
          },
        ],
        "time": 20,
        "hearts": 3,
      },

// Level 7
      "7": {
        "given": [63, 25, 48, 12, 35, 9, 50, 18],
        "stages": [
          {
            "correct": [
              [9, 12],
              [18, 25],
              [35, 48],
              [50, 63]
            ],
            "choices": [
              [
                [12, 9],
                [25, 18],
                [35, 63],
                [48, 50]
              ], // Incorrect
              [
                [9, 18],
                [12, 25],
                [48, 35],
                [63, 50]
              ], // Incorrect
              [
                [9, 12],
                [18, 25],
                [35, 48],
                [50, 63]
              ], // Correct
            ],
          },
          {
            "correct": [
              [9, 12, 18, 25],
              [35, 48, 50, 63]
            ],
            "choices": [
              [
                [9, 12, 18, 25],
                [35, 48, 50, 63]
              ], // Correct
              [
                [12, 9, 18, 25],
                [50, 35, 48, 63]
              ], // Incorrect
              [
                [9, 18, 12, 25],
                [63, 50, 48, 35]
              ], // Incorrect
            ],
          },
          {
            "correct": [
              [9, 12, 18, 25, 35, 48, 50, 63]
            ],
            "choices": [
              [
                [18, 12, 9, 25, 48, 35, 50, 63]
              ], // Incorrect
              [
                [63, 50, 48, 35, 25, 18, 12, 9]
              ], // Incorrect
              [
                [9, 12, 18, 25, 35, 48, 50, 63]
              ], // Correct
            ],
          },
        ],
        "time": 15,
        "hearts": 1,
      },

// Level 8
      "8": {
        "given": [55, 12, 48, 3, 19, 8, 33, 25, 41],
        "stages": [
          {
            "correct": [
              [3, 8],
              [12, 19],
              [25, 33],
              [41, 48],
              [55]
            ],
            "choices": [
              [
                [8, 3],
                [19, 12],
                [33, 25],
                [48, 41],
                [55]
              ], // Incorrect
              [
                [3, 19],
                [8, 12],
                [25, 41],
                [33, 48],
                [55]
              ], // Incorrect
              [
                [3, 8],
                [12, 19],
                [25, 33],
                [41, 48],
                [55]
              ], // Correct
            ],
          },
          {
            "correct": [
              [3, 8, 12, 19],
              [25, 33, 41, 48],
              [55]
            ],
            "choices": [
              [
                [8, 3, 19, 12],
                [33, 25, 48, 41],
                [55]
              ], // Incorrect
              [
                [3, 19, 12, 8],
                [25, 41, 33, 48],
                [55]
              ], // Incorrect
              [
                [3, 8, 12, 19],
                [25, 33, 41, 48],
                [55]
              ], // Correct
            ],
          },
          {
            "correct": [
              [3, 8, 12, 19, 25, 33, 41, 48, 55]
            ],
            "choices": [
              [
                [19, 8, 3, 12, 33, 25, 48, 41, 55]
              ], // Incorrect
              [
                [55, 48, 41, 33, 25, 19, 12, 8, 3]
              ], // Incorrect
              [
                [3, 8, 12, 19, 25, 33, 41, 48, 55]
              ], // Correct
            ],
          },
        ],
        "time": 15,
        "hearts": 1,
      },
    };
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

  void handleChoice(List<List<int>> selectedChoice) {
    final correctChoice = stages[currentStage]["correct"];

    if (selectedChoice.toString() == correctChoice.toString()) {
      setState(() {
        // Add the correct stage to the visualized stages
        visualizedStages.add(correctChoice);

        currentStage++;
        if (currentStage >= stages.length) {
          isGameComplete = true;
        }
      });
    } else if (hearts > 0) {
      setState(() {
        hearts--;
        if (hearts == 0) {
          showGameOverDialog("You ran out of hearts!");
        }
      });
    }
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
              initializeGame();
            },
            child: const Text("Retry Level"),
          ),
        ],
      ),
    );
  }

  String getStageTitle() {
    if (isGameComplete) {
      return "🎉 Congratulations!";
    } else if (currentStage == stages.length - 1) {
      return "Final Merge";
    } else {
      return "${ordinal(currentStage + 1)} Merge";
    }
  }

  String ordinal(int number) {
    if (number == 1) return "First";
    if (number == 2) return "Second";
    if (number == 3) return "Third";
    return "${number}th";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Merge Sort - Level ${widget.level}"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Time and Hearts Display
            buildTopStatus(),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        getStageTitle(),
                        style: TextStyle(
                          fontSize: isGameComplete ? 30 : 22,
                          fontWeight: FontWeight.bold,
                          color: isGameComplete ? Colors.green : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      buildVisualization(),
                      const SizedBox(height: 40),
                      if (!isGameComplete) buildChoices(),
                      if (isGameComplete)
                        ElevatedButton(
                          onPressed: goToNextLevel,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text(
                            "Next Level",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTopStatus() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (timeRemaining > 0)
            Text(
              "⏳ Time: $timeRemaining",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          if (hearts > 0)
            Row(
              children: List.generate(
                hearts,
                (_) => const Icon(Icons.favorite, color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildVisualization() {
    return Column(
      children: visualizedStages.map((stage) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: stage.map<Widget>((group) {
            return Container(
              margin: const EdgeInsets.all(4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "{${group.join(", ")}}",
                style: const TextStyle(fontSize: 16),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  Widget buildChoices() {
    final currentChoices = stages[currentStage]["choices"];

    return Column(
      children: List.generate(currentChoices.length, (index) {
        return GestureDetector(
          onTap: () => handleChoice(currentChoices[index]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: currentChoices[index].map<Widget>((group) {
              return Container(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "{${group.join(", ")}}",
                  style: const TextStyle(fontSize: 16),
                ),
              );
            }).toList(),
          ),
        );
      }),
    );
  }

  void goToNextLevel() {
    final nextLevel = int.parse(widget.level) + 1;
    if (nextLevel > 8) {
      // Show completion dialog for Level 8
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Congratulations!"),
          content: const Text("You have completed the final level! 🎉"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MergeSortGamePage(level: nextLevel.toString()),
        ),
      );
    }
  }
}
