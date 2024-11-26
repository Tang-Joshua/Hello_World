import 'package:flutter/material.dart';

class MergeSortGamePage extends StatefulWidget {
  final String level;

  const MergeSortGamePage({Key? key, required this.level}) : super(key: key);

  @override
  State<MergeSortGamePage> createState() => _MergeSortGamePageState();
}

class _MergeSortGamePageState extends State<MergeSortGamePage> {
  late List<List<Map<String, dynamic>>> levelData;
  late List<Map<String, dynamic>> currentLevelStages;
  int currentStage = 0;
  bool isGameComplete = false;

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  void initializeGame() {
    // Load level-specific data
    levelData = getLevelData();
    currentLevelStages = levelData[int.parse(widget.level) - 1];

    // Reset game state
    currentStage = 0;
    isGameComplete = false;
  }

  List<List<Map<String, dynamic>>> getLevelData() {
    return [
      // Level 1
      [
        {
          "correct": [
            [1, 2],
            [3],
            [4, 5]
          ],
          "choices": [
            [
              [1, 2],
              [3],
              [4, 5]
            ], // Correct answer
            [
              [3],
              [1, 2],
              [4, 5]
            ], // Incorrect choice 1
            [
              [1, 2],
              [4, 5],
              [3]
            ], // Incorrect choice 2
          ],
        },
        {
          "correct": [
            [1, 2, 3],
            [4, 5]
          ],
          "choices": [
            [
              [1, 2, 3],
              [4, 5]
            ], // Correct answer
            [
              [4, 5],
              [1, 2, 3]
            ], // Incorrect choice 1
            [
              [1, 2],
              [3, 4, 5]
            ], // Incorrect choice 2
          ],
        },
        {
          "correct": [
            [1, 2, 3, 4, 5]
          ],
          "choices": [
            [
              [1, 2, 3, 4, 5]
            ], // Correct answer
            [
              [4, 5, 1, 2, 3]
            ], // Incorrect choice 1
            [
              [1, 3, 2, 4, 5]
            ], // Incorrect choice 2
          ],
        },
      ],

      // Level 2
      [
        {
          "correct": [
            [1, 2],
            [3],
            [4, 5],
            [6]
          ],
          "choices": [
            [
              [1, 2],
              [3],
              [4, 5],
              [6]
            ], // Correct answer
            [
              [3],
              [1, 2],
              [6],
              [4, 5]
            ], // Incorrect choice 1
            [
              [1, 2],
              [4, 5],
              [3],
              [6]
            ], // Incorrect choice 2
          ],
        },
        {
          "correct": [
            [1, 2, 3],
            [4, 5, 6]
          ],
          "choices": [
            [
              [1, 2, 3],
              [4, 5, 6]
            ], // Correct answer
            [
              [4, 5, 6],
              [1, 2, 3]
            ], // Incorrect choice 1
            [
              [1, 2],
              [3, 4, 5, 6]
            ], // Incorrect choice 2
          ],
        },
        {
          "correct": [
            [1, 2, 3, 4, 5, 6]
          ],
          "choices": [
            [
              [1, 2, 3, 4, 5, 6]
            ], // Correct answer
            [
              [6, 1, 2, 3, 4, 5]
            ], // Incorrect choice 1
            [
              [1, 3, 2, 4, 6, 5]
            ], // Incorrect choice 2
          ],
        },
      ],

      // Add more levels as required
    ];
  }

  void handleChoice(List<List<int>> selectedChoice) {
    if (selectedChoice == currentLevelStages[currentStage]["correct"]) {
      setState(() {
        currentStage++;
        if (currentStage >= currentLevelStages.length) {
          isGameComplete = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Merge Sort - Level ${widget.level}"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isGameComplete)
              Column(
                children: [
                  Text(
                      "Stage ${currentStage + 1} / ${currentLevelStages.length}"),
                  const SizedBox(height: 20),
                  buildChoices(),
                ],
              ),
            if (isGameComplete)
              const Center(
                child: Text(
                  "🎉 Level Complete! 🎉",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildChoices() {
    List<List<int>> correct = currentLevelStages[currentStage]["correct"];
    List<List<List<int>>> choices = currentLevelStages[currentStage]["choices"];

    return Column(
      children: List.generate(choices.length, (index) {
        return GestureDetector(
          onTap: () => handleChoice(choices[index]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: choices[index].map((group) {
              return Container(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  border: Border.all(color: Colors.blue),
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
}
