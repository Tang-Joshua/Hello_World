import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

class MergeSortGamePage extends StatefulWidget {
  final String level;

  const MergeSortGamePage({Key? key, required this.level}) : super(key: key);

  @override
  State<MergeSortGamePage> createState() => _MergeSortGamePageState();
}

class _MergeSortGamePageState extends State<MergeSortGamePage> {
  late Map<String, dynamic> currentLevelData;
  late Map<String, dynamic> selectedQuestion; // Add this line
  late List<int> givenValues;
  late List<Map<String, dynamic>> stages;
  late List<List<List<int>>> visualizedStages; // Tracks user progress
  int currentStage = 0;
  late int timeRemaining;
  late int hearts;
  bool isGameComplete = false;
  Timer? timer;
  late AudioPlayer backgroundMusicPlayer;
  late AudioPlayer effectPlayer;

  @override
  void initState() {
    super.initState();
    backgroundMusicPlayer = AudioPlayer();
    effectPlayer = AudioPlayer();
    initializeGame();
    _playBackgroundMusic(); // Start background music
    if (timeRemaining > 0) startTimer();
  }

  @override
  void dispose() {
    backgroundMusicPlayer.dispose();
    effectPlayer.dispose();
    timer?.cancel();
    super.dispose();
  }

  void _playBackgroundMusic() async {
    try {
      await backgroundMusicPlayer.setReleaseMode(ReleaseMode.loop);
      await backgroundMusicPlayer.setVolume(0.2); // Set a lower volume
      await backgroundMusicPlayer.play(AssetSource('Sounds/radix.mp3'));
    } catch (e) {
      print('Error playing background music: $e');
    }
  }

  void _playWinSound() async {
    try {
      await effectPlayer.play(AssetSource('Sounds/win.mp3'));
    } catch (e) {
      print('Error playing win sound: $e');
    }
  }

  void _playGameOverSound() async {
    try {
      await effectPlayer.play(AssetSource('Sounds/gameover.mp3'));
    } catch (e) {
      print('Error playing game-over sound: $e');
    }
  }

  void initializeGame() {
    // Load level-specific data
    currentLevelData = getLevelData()[widget.level]!;

    // Get the questions for the current level
    final questions = currentLevelData["questions"];

    // Check if questions exist and are not empty
    if (questions == null || questions.isEmpty) {
      throw Exception("No questions available for level ${widget.level}");
    }

    // Randomly select one question
    selectedQuestion = questions[Random().nextInt(questions.length)];

    // Ensure required keys exist in the selected question
    if (selectedQuestion["given"] == null ||
        selectedQuestion["stages"] == null) {
      throw Exception("Incomplete question data in level ${widget.level}");
    }

    // Extract the `given` and `stages` for the selected question
    givenValues = selectedQuestion["given"];
    stages = selectedQuestion["stages"];

    // Initialize visualization with the given values as the first stage
    visualizedStages = [
      givenValues.map((value) => [value]).toList()
    ];

    // Reset state
    currentStage = 0;
    timeRemaining = currentLevelData["time"] ?? 0;
    hearts = currentLevelData["hearts"] ?? 0;
    isGameComplete = false;
  }

  Map<String, Map<String, dynamic>> getLevelData() {
    return {
      "1": {
        "questions": [
          {
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
          },
          {
            "given": [6, 2, 9, 5],
            "stages": [
              {
                "correct": [
                  [2, 6],
                  [5, 9]
                ],
                "choices": [
                  [
                    [5, 6],
                    [2, 9]
                  ], // Incorrect
                  [
                    [6],
                    [9, 5],
                    [2]
                  ], // Incorrect
                  [
                    [2, 6],
                    [5, 9]
                  ], // Correct
                ],
              },
              {
                "correct": [
                  [2, 5, 6, 9]
                ],
                "choices": [
                  [
                    [2, 5, 6, 9]
                  ], // Correct
                  [
                    [6, 2, 9, 5]
                  ], // Incorrect
                  [
                    [5, 9, 2, 6]
                  ], // Incorrect
                ],
              },
            ],
          },
          {
            "given": [7, 3, 10, 4],
            "stages": [
              {
                "correct": [
                  [3, 7],
                  [4, 10]
                ],
                "choices": [
                  [
                    [4, 10],
                    [3, 7]
                  ], // Incorrect
                  [
                    [7],
                    [4, 3],
                    [10]
                  ], // Incorrect
                  [
                    [3, 7],
                    [4, 10]
                  ], // Correct
                ],
              },
              {
                "correct": [
                  [3, 4, 7, 10]
                ],
                "choices": [
                  [
                    [3, 4, 7, 10]
                  ], // Correct
                  [
                    [7, 10, 3, 4]
                  ], // Incorrect
                  [
                    [10, 3, 4, 7]
                  ], // Incorrect
                ],
              },
            ],
          },
          {
            "given": [11, 6, 3, 8],
            "stages": [
              {
                "correct": [
                  [6, 11],
                  [3, 8]
                ],
                "choices": [
                  [
                    [3, 8],
                    [11, 6]
                  ], // Incorrect
                  [
                    [6],
                    [8, 3],
                    [11]
                  ], // Incorrect
                  [
                    [6, 11],
                    [3, 8]
                  ], // Correct
                ],
              },
              {
                "correct": [
                  [3, 6, 8, 11]
                ],
                "choices": [
                  [
                    [3, 6, 8, 11]
                  ], // Correct
                  [
                    [8, 11, 3, 6]
                  ], // Incorrect
                  [
                    [6, 3, 11, 8]
                  ], // Incorrect
                ],
              },
            ],
          },
          {
            "given": [12, 9, 4, 7],
            "stages": [
              {
                "correct": [
                  [9, 12],
                  [4, 7]
                ],
                "choices": [
                  [
                    [4, 9],
                    [7, 12]
                  ], // Incorrect
                  [
                    [9],
                    [12, 7],
                    [4]
                  ], // Incorrect
                  [
                    [9, 12],
                    [4, 7]
                  ], // Correct
                ],
              },
              {
                "correct": [
                  [4, 7, 9, 12]
                ],
                "choices": [
                  [
                    [4, 7, 9, 12]
                  ], // Correct
                  [
                    [7, 12, 4, 9]
                  ], // Incorrect
                  [
                    [9, 4, 7, 12]
                  ], // Incorrect
                ],
              },
            ],
          },
        ],
        "time": 0,
        "hearts": 0,
      },

      // Level 2
      "2": {
        "questions": [
          {
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
          },
          {
            "given": [20, 15, 50, 5, 30],
            "stages": [
              {
                "correct": [
                  [15, 20],
                  [50],
                  [5, 30]
                ],
                "choices": [
                  [
                    [20, 15],
                    [30, 5],
                    [50]
                  ], // Incorrect
                  [
                    [15, 20],
                    [50],
                    [5, 30]
                  ], // Correct
                  [
                    [5, 15],
                    [30, 20],
                    [50]
                  ], // Incorrect
                ],
              },
              {
                "correct": [
                  [15, 20, 50],
                  [5, 30]
                ],
                "choices": [
                  [
                    [15, 20, 30],
                    [5, 50]
                  ], // Incorrect
                  [
                    [15, 20, 50],
                    [5, 30]
                  ], // Correct
                  [
                    [5, 30, 15],
                    [20, 50]
                  ], // Incorrect
                ],
              },
              {
                "correct": [
                  [5, 15, 20, 30, 50]
                ],
                "choices": [
                  [
                    [15, 20, 5, 30, 50]
                  ], // Incorrect
                  [
                    [5, 15, 20, 30, 50]
                  ], // Correct
                  [
                    [30, 5, 20, 50, 15]
                  ], // Incorrect
                ],
              },
            ],
          },
          {
            "given": [45, 10, 5, 20, 35],
            "stages": [
              {
                "correct": [
                  [10, 45],
                  [5],
                  [20, 35]
                ],
                "choices": [
                  [
                    [45, 10],
                    [20, 5],
                    [35]
                  ], // Incorrect
                  [
                    [10, 45],
                    [5],
                    [20, 35]
                  ], // Correct
                  [
                    [5, 10],
                    [45, 35],
                    [20]
                  ], // Incorrect
                ],
              },
              {
                "correct": [
                  [5, 10, 45],
                  [20, 35]
                ],
                "choices": [
                  [
                    [10, 20, 35],
                    [5, 45]
                  ], // Incorrect
                  [
                    [5, 10, 45],
                    [20, 35]
                  ], // Correct
                  [
                    [35, 45, 10],
                    [5, 20]
                  ], // Incorrect
                ],
              },
              {
                "correct": [
                  [5, 10, 20, 35, 45]
                ],
                "choices": [
                  [
                    [10, 20, 35, 45, 5]
                  ], // Incorrect
                  [
                    [5, 10, 20, 35, 45]
                  ], // Correct
                  [
                    [35, 10, 45, 5, 20]
                  ], // Incorrect
                ],
              },
            ],
          },
          {
            "given": [25, 15, 10, 5, 50],
            "stages": [
              {
                "correct": [
                  [15, 25],
                  [10],
                  [5, 50]
                ],
                "choices": [
                  [
                    [25, 15],
                    [5, 10],
                    [50]
                  ], // Incorrect
                  [
                    [15, 25],
                    [10],
                    [5, 50]
                  ], // Correct
                  [
                    [10, 5],
                    [50, 15],
                    [25]
                  ], // Incorrect
                ],
              },
              {
                "correct": [
                  [10, 15, 25],
                  [5, 50]
                ],
                "choices": [
                  [
                    [15, 10, 25],
                    [5, 50]
                  ], // Incorrect
                  [
                    [10, 15, 25],
                    [5, 50]
                  ], // Correct
                  [
                    [10, 25, 5],
                    [15, 50]
                  ], // Incorrect
                ],
              },
              {
                "correct": [
                  [5, 10, 15, 25, 50]
                ],
                "choices": [
                  [
                    [25, 15, 10, 5, 50]
                  ], // Incorrect
                  [
                    [5, 10, 15, 25, 50]
                  ], // Correct
                  [
                    [50, 25, 10, 15, 5]
                  ], // Incorrect
                ],
              },
            ],
          },
          {
            "given": [60, 5, 10, 35, 20],
            "stages": [
              {
                "correct": [
                  [5, 60],
                  [10],
                  [20, 35]
                ],
                "choices": [
                  [
                    [5, 10],
                    [20, 35],
                    [60]
                  ], // Incorrect
                  [
                    [5, 60],
                    [10],
                    [20, 35]
                  ], // Correct
                  [
                    [35, 20],
                    [60, 10],
                    [5]
                  ], // Incorrect
                ],
              },
              {
                "correct": [
                  [5, 10, 60],
                  [20, 60]
                ],
                "choices": [
                  [
                    [10, 35, 5],
                    [20, 60]
                  ], // Incorrect
                  [
                    [5, 10, 60],
                    [20, 60]
                  ], // Correct
                  [
                    [20, 35, 5],
                    [10, 60]
                  ], // Incorrect
                ],
              },
              {
                "correct": [
                  [5, 10, 20, 35, 60]
                ],
                "choices": [
                  [
                    [10, 5, 20, 35, 60]
                  ], // Incorrect
                  [
                    [5, 10, 20, 35, 60]
                  ], // Correct
                  [
                    [35, 20, 60, 5, 10]
                  ], // Incorrect
                ],
              },
            ],
          },
        ],
        "time": 0,
        "hearts": 0,
      },

      "3": {
        "questions": [
          {
            "given": [12, 15, 7, 9, 3, 11],
            "stages": [
              {
                "correct": [
                  [12, 15],
                  [7],
                  [3, 9],
                  [11]
                ],
                "choices": [
                  [
                    [12, 15],
                    [7],
                    [3, 9],
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
                  [7, 12, 15],
                  [3, 9, 11]
                ],
                "choices": [
                  [
                    [7, 9, 12, 15],
                    [3, 11]
                  ], // Incorrect
                  [
                    [7, 12, 15],
                    [3, 9, 11]
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
          },
          {
            "given": [10, 20, 5, 25, 15, 8],
            "stages": [
              {
                "correct": [
                  [10, 20],
                  [5],
                  [15, 25],
                  [8]
                ],
                "choices": [
                  [
                    [10, 20],
                    [5],
                    [15, 25],
                    [8]
                  ], // Correct
                  [
                    [10, 20],
                    [15],
                    [5, 8],
                    [25]
                  ], // Incorrect
                  [
                    [5, 10],
                    [8, 15],
                    [20, 25]
                  ], // Incorrect
                ],
              },
              {
                "correct": [
                  [5, 10, 20],
                  [8, 15, 25]
                ],
                "choices": [
                  [
                    [5, 10, 20],
                    [8, 15, 25]
                  ], // Correct
                  [
                    [5, 10, 15],
                    [8, 20, 25]
                  ], // Incorrect
                  [
                    [5, 20, 10],
                    [8, 15, 25]
                  ], // Incorrect
                ],
              },
              {
                "correct": [
                  [5, 8, 10, 15, 20, 25]
                ],
                "choices": [
                  [
                    [5, 8, 10, 15, 20, 25]
                  ], // Correct
                  [
                    [10, 5, 15, 20, 25, 8]
                  ], // Incorrect
                  [
                    [20, 25, 10, 15, 8, 5]
                  ], // Incorrect
                ],
              },
            ],
          },
          {
            "given": [18, 22, 3, 7, 12, 9],
            "stages": [
              {
                "correct": [
                  [18, 22],
                  [3],
                  [7, 12],
                  [9]
                ],
                "choices": [
                  [
                    [18, 22],
                    [3],
                    [7, 12],
                    [9]
                  ], // Correct
                  [
                    [18, 3],
                    [22],
                    [7, 9],
                    [12]
                  ], // Incorrect
                  [
                    [3],
                    [18, 9],
                    [12, 7],
                    [22]
                  ], // Incorrect
                ],
              },
              {
                "correct": [
                  [3, 18, 22],
                  [7, 9, 12]
                ],
                "choices": [
                  [
                    [3, 18, 22],
                    [7, 9, 12]
                  ], // Correct
                  [
                    [3, 7, 9],
                    [12, 18, 22]
                  ], // Incorrect
                  [
                    [18, 12, 22],
                    [7, 3, 9]
                  ], // Incorrect
                ],
              },
              {
                "correct": [
                  [3, 7, 9, 12, 18, 22]
                ],
                "choices": [
                  [
                    [3, 7, 9, 12, 18, 22]
                  ], // Correct
                  [
                    [18, 12, 9, 22, 7, 3]
                  ], // Incorrect
                  [
                    [7, 3, 22, 9, 12, 18]
                  ], // Incorrect
                ],
              },
            ],
          },
          {
            "given": [5, 15, 20, 8, 25, 10],
            "stages": [
              {
                "correct": [
                  [5, 15],
                  [20],
                  [8, 25],
                  [10]
                ],
                "choices": [
                  [
                    [5, 15],
                    [20],
                    [8, 25],
                    [10]
                  ], // Correct
                  [
                    [15, 20],
                    [8],
                    [5, 10],
                    [25]
                  ], // Incorrect
                  [
                    [8, 10],
                    [5],
                    [15, 20],
                    [25]
                  ], // Incorrect
                ],
              },
              {
                "correct": [
                  [5, 15, 20],
                  [8, 10, 25]
                ],
                "choices": [
                  [
                    [5, 15, 20],
                    [8, 10, 25]
                  ], // Correct
                  [
                    [8, 10, 15],
                    [5, 20, 25]
                  ], // Incorrect
                  [
                    [10, 15, 25],
                    [8, 5, 20]
                  ], // Incorrect
                ],
              },
              {
                "correct": [
                  [5, 8, 10, 15, 20, 25]
                ],
                "choices": [
                  [
                    [5, 8, 10, 15, 20, 25]
                  ], // Correct
                  [
                    [15, 20, 25, 10, 8, 5]
                  ], // Incorrect
                  [
                    [10, 5, 8, 20, 25, 15]
                  ], // Incorrect
                ],
              },
            ],
          },
          {
            "given": [30, 25, 5, 10, 15, 20],
            "stages": [
              {
                "correct": [
                  [25, 30],
                  [5],
                  [10, 15],
                  [20]
                ],
                "choices": [
                  [
                    [25, 30],
                    [5],
                    [10, 15],
                    [20]
                  ], // Correct
                  [
                    [25],
                    [30],
                    [10, 15],
                    [5, 20]
                  ], // Incorrect
                  [
                    [5],
                    [25, 30],
                    [20],
                    [10, 15]
                  ], // Incorrect
                ],
              },
              {
                "correct": [
                  [5, 25, 30],
                  [10, 15, 20]
                ],
                "choices": [
                  [
                    [5, 25, 30],
                    [10, 15, 20]
                  ], // Correct
                  [
                    [25, 5, 10],
                    [15, 20, 30]
                  ], // Incorrect
                  [
                    [5, 30, 15],
                    [25, 10, 20]
                  ], // Incorrect
                ],
              },
              {
                "correct": [
                  [5, 10, 15, 20, 25, 30]
                ],
                "choices": [
                  [
                    [5, 10, 15, 20, 25, 30]
                  ], // Correct
                  [
                    [30, 25, 20, 15, 10, 5]
                  ], // Incorrect
                  [
                    [10, 15, 20, 25, 30, 5]
                  ], // Incorrect
                ],
              },
            ],
          },
        ],
        "time": 30,
        "hearts": 3,
      },

      "4": {
        "questions": [
          {
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
                  ], // Correct
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
                  ], // Correct
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
                  ], // Correct
                ],
              },
            ],
          },
          {
            "given": [30, 15, 25, 5, 35, 10, 20],
            "stages": [
              {
                "correct": [
                  [15, 30],
                  [5, 25],
                  [10, 35],
                  [20]
                ],
                "choices": [
                  [
                    [30, 15],
                    [25, 5],
                    [10, 20],
                    [35]
                  ], // Incorrect
                  [
                    [15, 30],
                    [5, 25],
                    [10, 35],
                    [20]
                  ], // Correct
                  [
                    [5, 30],
                    [10, 15],
                    [25, 20],
                    [35]
                  ], // Incorrect
                ],
              },
              {
                "correct": [
                  [5, 15, 25, 30],
                  [10, 20, 35]
                ],
                "choices": [
                  [
                    [10, 5, 15, 25],
                    [30, 20, 35]
                  ], // Incorrect
                  [
                    [5, 15, 25, 30],
                    [10, 20, 35]
                  ], // Correct
                  [
                    [15, 25, 30, 35],
                    [5, 10, 20]
                  ], // Incorrect
                ],
              },
              {
                "correct": [
                  [5, 10, 15, 20, 25, 30, 35]
                ],
                "choices": [
                  [
                    [5, 15, 10, 20, 25, 30, 35]
                  ], // Incorrect
                  [
                    [5, 10, 15, 20, 25, 30, 35]
                  ], // Correct
                  [
                    [10, 15, 25, 20, 5, 35, 30]
                  ], // Incorrect
                ],
              },
            ],
          },
          {
            "given": [18, 22, 7, 12, 30, 5, 25],
            "stages": [
              {
                "correct": [
                  [18, 22],
                  [7, 12],
                  [5, 30],
                  [25]
                ],
                "choices": [
                  [
                    [22, 18],
                    [12, 7],
                    [5, 30],
                    [25]
                  ], // Incorrect
                  [
                    [18, 22],
                    [7, 12],
                    [5, 30],
                    [25]
                  ], // Correct
                  [
                    [12, 7],
                    [18, 22],
                    [30, 25],
                    [5]
                  ], // Incorrect
                ],
              },
              {
                "correct": [
                  [7, 12, 18, 22],
                  [5, 25, 30]
                ],
                "choices": [
                  [
                    [12, 7, 5, 18],
                    [22, 25, 30]
                  ], // Incorrect
                  [
                    [7, 12, 18, 22],
                    [5, 25, 30]
                  ], // Correct
                  [
                    [5, 18, 22, 12],
                    [30, 7, 25]
                  ], // Incorrect
                ],
              },
              {
                "correct": [
                  [5, 7, 12, 18, 22, 25, 30]
                ],
                "choices": [
                  [
                    [12, 7, 18, 25, 22, 30, 5]
                  ], // Incorrect
                  [
                    [5, 7, 12, 18, 22, 25, 30]
                  ], // Correct
                  [
                    [18, 25, 30, 22, 12, 5, 7]
                  ], // Incorrect
                ],
              },
            ],
          },
          {
            "given": [40, 20, 5, 10, 35, 15, 25],
            "stages": [
              {
                "correct": [
                  [20, 40],
                  [5, 10],
                  [15, 25],
                  [35]
                ],
                "choices": [
                  [
                    [40, 20],
                    [10, 5],
                    [15, 35],
                    [25]
                  ], // Incorrect
                  [
                    [20, 40],
                    [5, 10],
                    [15, 25],
                    [35]
                  ], // Correct
                  [
                    [10, 5],
                    [20, 40],
                    [25, 35],
                    [15]
                  ], // Incorrect
                ],
              },
              {
                "correct": [
                  [5, 10, 20, 40],
                  [15, 25, 35]
                ],
                "choices": [
                  [
                    [10, 5, 20, 15],
                    [25, 35, 40]
                  ], // Incorrect
                  [
                    [5, 10, 20, 40],
                    [15, 25, 35]
                  ], // Correct
                  [
                    [15, 20, 25, 10],
                    [5, 40, 35]
                  ], // Incorrect
                ],
              },
              {
                "correct": [
                  [5, 10, 15, 20, 25, 35, 40]
                ],
                "choices": [
                  [
                    [5, 10, 20, 25, 15, 40, 35]
                  ], // Incorrect
                  [
                    [5, 10, 15, 20, 25, 35, 40]
                  ], // Correct
                  [
                    [25, 20, 15, 5, 35, 40, 10]
                  ], // Incorrect
                ],
              },
            ],
          },
        ],
        "time": 30,
        "hearts": 3,
      },

      "5": {
        "questions": [
          {
            "given": [20, 8, 15, 5, 12, 10],
            "stages": [
              {
                "correct": [
                  [8, 20],
                  [5],
                  [10, 12],
                  [15]
                ],
                "choices": [
                  [
                    [8, 20],
                    [5],
                    [10, 12],
                    [15]
                  ], // Correct
                  [
                    [20, 8],
                    [5],
                    [10],
                    [12, 15]
                  ], // Incorrect
                  [
                    [5],
                    [8, 15],
                    [20],
                    [10, 12]
                  ] // Incorrect
                ],
              },
              {
                "correct": [
                  [5, 8, 20],
                  [10, 12, 15]
                ],
                "choices": [
                  [
                    [5, 8, 20],
                    [10, 12, 15]
                  ], // Correct
                  [
                    [5, 10, 12],
                    [8, 15, 20]
                  ], // Incorrect
                  [
                    [10, 12, 15],
                    [8, 5, 20]
                  ] // Incorrect
                ],
              },
              {
                "correct": [
                  [5, 8, 10, 12, 15, 20]
                ],
                "choices": [
                  [
                    [5, 8, 10, 12, 15, 20]
                  ], // Correct
                  [
                    [8, 5, 10, 15, 12, 20]
                  ], // Incorrect
                  [
                    [20, 15, 12, 10, 8, 5]
                  ] // Incorrect
                ],
              }
            ],
          },
          {
            "given": [25, 10, 15, 5, 20, 30],
            "stages": [
              {
                "correct": [
                  [10, 25],
                  [15],
                  [5, 20],
                  [30]
                ],
                "choices": [
                  [
                    [10, 25],
                    [15],
                    [5, 20],
                    [30]
                  ], // Correct
                  [
                    [25, 10],
                    [5],
                    [20],
                    [15, 30]
                  ], // Incorrect
                  [
                    [5],
                    [10, 15],
                    [25],
                    [20, 30]
                  ] // Incorrect
                ],
              },
              {
                "correct": [
                  [10, 15, 25],
                  [5, 20, 30]
                ],
                "choices": [
                  [
                    [10, 15, 25],
                    [5, 20, 30]
                  ], // Correct
                  [
                    [5, 15, 20],
                    [10, 25, 30]
                  ], // Incorrect
                  [
                    [15, 25, 30],
                    [5, 10, 20]
                  ] // Incorrect
                ],
              },
              {
                "correct": [
                  [5, 10, 15, 20, 25, 30]
                ],
                "choices": [
                  [
                    [5, 10, 15, 20, 25, 30]
                  ], // Correct
                  [
                    [30, 25, 20, 15, 10, 5]
                  ], // Incorrect
                  [
                    [10, 15, 20, 25, 5, 30]
                  ] // Incorrect
                ],
              }
            ],
          },
          {
            "given": [35, 15, 25, 5, 20, 10],
            "stages": [
              {
                "correct": [
                  [15, 35],
                  [25],
                  [5, 20],
                  [10]
                ],
                "choices": [
                  [
                    [15, 35],
                    [25],
                    [5, 20],
                    [10]
                  ], // Correct
                  [
                    [5],
                    [15, 25],
                    [35],
                    [10, 20]
                  ], // Incorrect
                  [
                    [35, 15],
                    [25],
                    [10, 5],
                    [20]
                  ] // Incorrect
                ],
              },
              {
                "correct": [
                  [15, 25, 35],
                  [5, 10, 20]
                ],
                "choices": [
                  [
                    [5, 15, 35],
                    [10, 20, 25]
                  ], // Correct
                  [
                    [15, 25, 35],
                    [5, 10, 20]
                  ], // Incorrect
                  [
                    [5, 35, 15],
                    [10, 20, 25]
                  ] // Incorrect
                ],
              },
              {
                "correct": [
                  [5, 10, 15, 20, 25, 35]
                ],
                "choices": [
                  [
                    [5, 10, 15, 20, 25, 35]
                  ], // Correct
                  [
                    [15, 10, 20, 25, 5, 35]
                  ], // Incorrect
                  [
                    [35, 25, 20, 15, 10, 5]
                  ] // Incorrect
                ],
              }
            ],
          },
          {
            "given": [40, 30, 20, 10, 25, 5],
            "stages": [
              {
                "correct": [
                  [30, 40],
                  [20],
                  [10, 25],
                  [5]
                ],
                "choices": [
                  [
                    [30, 40],
                    [20],
                    [10, 25],
                    [5]
                  ], // Correct
                  [
                    [40, 30],
                    [5],
                    [10, 25],
                    [20]
                  ], // Incorrect
                  [
                    [20, 10],
                    [25, 30],
                    [5],
                    [40]
                  ] // Incorrect
                ],
              },
              {
                "correct": [
                  [20, 30, 40],
                  [5, 10, 25]
                ],
                "choices": [
                  [
                    [20, 30, 40],
                    [5, 10, 25]
                  ], // Correct
                  [
                    [10, 20, 30],
                    [5, 25, 40]
                  ], // Incorrect
                  [
                    [5, 25, 30],
                    [10, 20, 40]
                  ] // Incorrect
                ],
              },
              {
                "correct": [
                  [5, 10, 20, 25, 30, 40]
                ],
                "choices": [
                  [
                    [5, 10, 20, 25, 30, 40]
                  ], // Correct
                  [
                    [10, 5, 25, 20, 40, 30]
                  ], // Incorrect
                  [
                    [40, 30, 25, 20, 10, 5]
                  ] // Incorrect
                ],
              }
            ],
          }
        ],
        "time": 30,
        "hearts": 3
      },

      "6": {
        "questions": [
          {
            "given": [42, 35, 10, 18, 25, 50, 8],
            "stages": [
              {
                "correct": [
                  [35, 42],
                  [10, 18],
                  [25, 50],
                  [8]
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
                    [35, 42],
                    [10, 18],
                    [25, 50],
                    [8]
                  ], // Correct
                ],
              },
              {
                "correct": [
                  [10, 18, 35, 42],
                  [8, 25, 50]
                ],
                "choices": [
                  [
                    [10, 8, 18, 25],
                    [42, 35, 50]
                  ], // Incorrect
                  [
                    [10, 18, 35, 42],
                    [8, 25, 50]
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
          },
          {
            "given": [48, 20, 15, 25, 35, 10, 5],
            "stages": [
              {
                "correct": [
                  [10, 15],
                  [20, 25],
                  [35],
                  [5, 48]
                ],
                "choices": [
                  [
                    [15, 10],
                    [20, 25],
                    [5],
                    [35, 48]
                  ], // Incorrect
                  [
                    [10, 15],
                    [20, 25],
                    [35],
                    [5, 48]
                  ], // Correct
                  [
                    [25, 20],
                    [10, 15],
                    [35],
                    [48, 5]
                  ], // Incorrect
                ],
              },
              {
                "correct": [
                  [10, 15, 20, 25],
                  [5, 35, 48]
                ],
                "choices": [
                  [
                    [10, 15, 20, 25],
                    [5, 35, 48]
                  ], // Correct
                  [
                    [15, 10, 25, 20],
                    [48, 35, 5]
                  ], // Incorrect
                  [
                    [10, 20, 25, 15],
                    [35, 48, 5]
                  ], // Incorrect
                ],
              },
              {
                "correct": [
                  [5, 10, 15, 20, 25, 35, 48]
                ],
                "choices": [
                  [
                    [5, 10, 15, 20, 25, 35, 48]
                  ], // Correct
                  [
                    [10, 15, 25, 20, 35, 48, 5]
                  ], // Incorrect
                  [
                    [48, 35, 25, 15, 10, 20, 5]
                  ], // Incorrect
                ],
              },
            ],
          },
          {
            "given": [48, 36, 12, 20, 28, 54, 6],
            "stages": [
              {
                "correct": [
                  [36, 48],
                  [12, 20],
                  [28, 54],
                  [6]
                ],
                "choices": [
                  [
                    [6, 20],
                    [12, 28],
                    [48, 36],
                    [54]
                  ], // Incorrect
                  [
                    [12, 6],
                    [28, 20],
                    [36, 48],
                    [54]
                  ], // Incorrect
                  [
                    [36, 48],
                    [12, 20],
                    [28, 54],
                    [6]
                  ] // Correct
                ]
              },
              {
                "correct": [
                  [12, 20, 36, 48],
                  [6, 28, 54]
                ],
                "choices": [
                  [
                    [12, 6, 20, 28],
                    [48, 36, 54]
                  ], // Incorrect
                  [
                    [12, 20, 36, 48],
                    [6, 28, 54]
                  ], // Correct
                  [
                    [6, 20, 12, 28],
                    [36, 54, 48]
                  ] // Incorrect
                ]
              },
              {
                "correct": [
                  [6, 12, 20, 28, 36, 48, 54]
                ],
                "choices": [
                  [
                    [12, 6, 20, 28, 36, 48, 54]
                  ], // Incorrect
                  [
                    [6, 12, 20, 28, 36, 48, 54]
                  ], // Correct
                  [
                    [54, 48, 36, 28, 20, 12, 6]
                  ] // Incorrect
                ]
              }
            ]
          },
          {
            "given": [60, 45, 20, 25, 35, 70, 5],
            "stages": [
              {
                "correct": [
                  [45, 60],
                  [20, 25],
                  [35, 70],
                  [5]
                ],
                "choices": [
                  [
                    [5, 25],
                    [20, 35],
                    [60, 45],
                    [70]
                  ], // Incorrect
                  [
                    [20, 5],
                    [35, 25],
                    [45, 60],
                    [70]
                  ], // Incorrect
                  [
                    [45, 60],
                    [20, 25],
                    [35, 70],
                    [5]
                  ] // Correct
                ]
              },
              {
                "correct": [
                  [20, 25, 45, 60],
                  [5, 35, 70]
                ],
                "choices": [
                  [
                    [20, 5, 25, 35],
                    [60, 45, 70]
                  ], // Incorrect
                  [
                    [20, 25, 45, 60],
                    [5, 35, 70]
                  ], // Correct
                  [
                    [5, 25, 20, 35],
                    [45, 70, 60]
                  ] // Incorrect
                ]
              },
              {
                "correct": [
                  [5, 20, 25, 35, 45, 60, 70]
                ],
                "choices": [
                  [
                    [20, 5, 25, 35, 45, 60, 70]
                  ], // Incorrect
                  [
                    [5, 20, 25, 35, 45, 60, 70]
                  ], // Correct
                  [
                    [70, 60, 45, 35, 25, 20, 5]
                  ] // Incorrect
                ]
              }
            ]
          },
        ],
        "time": 30,
        "hearts": 3,
      },

      "7": {
        "questions": [
          {
            "given": [63, 25, 48, 12, 35, 9, 50, 18],
            "stages": [
              {
                "correct": [
                  [25, 63],
                  [12, 48],
                  [9, 35],
                  [18, 50]
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
                    [25, 63],
                    [12, 48],
                    [9, 35],
                    [18, 50]
                  ], // Correct
                ],
              },
              {
                "correct": [
                  [12, 25, 48, 63],
                  [9, 18, 35, 50]
                ],
                "choices": [
                  [
                    [12, 25, 48, 63],
                    [9, 18, 35, 50]
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
          },
          {
            "given": [72, 30, 60, 15, 40, 10, 50, 20],
            "stages": [
              {
                "correct": [
                  [30, 72],
                  [15, 60],
                  [10, 40],
                  [20, 50]
                ],
                "choices": [
                  [
                    [15, 10],
                    [30, 20],
                    [40, 72],
                    [50, 60]
                  ], // Incorrect
                  [
                    [30, 72],
                    [15, 60],
                    [10, 40],
                    [20, 50]
                  ], // Correct
                  [
                    [20, 50],
                    [15, 10],
                    [30, 40],
                    [60, 72]
                  ] // Incorrect
                ]
              },
              {
                "correct": [
                  [15, 30, 60, 72],
                  [10, 20, 40, 50]
                ],
                "choices": [
                  [
                    [15, 30, 60, 72],
                    [10, 20, 40, 50]
                  ], // Correct
                  [
                    [10, 15, 20, 30],
                    [40, 50, 60, 72]
                  ], // Incorrect
                  [
                    [10, 40, 50, 60],
                    [15, 20, 30, 72]
                  ] // Incorrect
                ]
              },
              {
                "correct": [
                  [10, 15, 20, 30, 40, 50, 60, 72]
                ],
                "choices": [
                  [
                    [10, 15, 20, 30, 40, 50, 60, 72]
                  ], // Correct
                  [
                    [72, 60, 50, 40, 30, 20, 15, 10]
                  ], // Incorrect
                  [
                    [20, 30, 40, 50, 60, 15, 10, 72]
                  ] // Incorrect
                ]
              }
            ]
          },
          {
            "given": [84, 45, 70, 25, 50, 15, 60, 30],
            "stages": [
              {
                "correct": [
                  [45, 84],
                  [25, 70],
                  [15, 50],
                  [30, 60]
                ],
                "choices": [
                  [
                    [45, 84],
                    [25, 70],
                    [15, 50],
                    [30, 60]
                  ], // Correct
                  [
                    [15, 25],
                    [30, 45],
                    [50, 70],
                    [60, 84]
                  ], // Incorrect
                  [
                    [25, 45],
                    [15, 30],
                    [50, 70],
                    [60, 84]
                  ] // Incorrect
                ]
              },
              {
                "correct": [
                  [25, 45, 70, 84],
                  [15, 30, 50, 60]
                ],
                "choices": [
                  [
                    [15, 25, 30, 45],
                    [50, 60, 70, 84]
                  ], // Incorrect
                  [
                    [25, 45, 70, 84],
                    [15, 30, 50, 60]
                  ], // Correct
                  [
                    [15, 50, 25, 45],
                    [30, 60, 70, 84]
                  ] // Incorrect
                ]
              },
              {
                "correct": [
                  [15, 25, 30, 45, 50, 60, 70, 84]
                ],
                "choices": [
                  [
                    [15, 25, 30, 45, 50, 60, 70, 84]
                  ], // Correct
                  [
                    [84, 70, 60, 50, 45, 30, 25, 15]
                  ], // Incorrect
                  [
                    [25, 15, 30, 70, 50, 60, 45, 84]
                  ] // Incorrect
                ]
              }
            ]
          },
          {
            "given": [96, 35, 80, 20, 55, 10, 65, 25],
            "stages": [
              {
                "correct": [
                  [35, 96],
                  [20, 80],
                  [10, 55],
                  [25, 65]
                ],
                "choices": [
                  [
                    [20, 10],
                    [35, 25],
                    [55, 80],
                    [65, 96]
                  ], // Incorrect
                  [
                    [35, 96],
                    [20, 80],
                    [10, 55],
                    [25, 65]
                  ], // Correct
                  [
                    [10, 20],
                    [25, 35],
                    [55, 65],
                    [80, 96]
                  ] // Incorrect
                ]
              },
              {
                "correct": [
                  [20, 35, 80, 96],
                  [10, 25, 55, 65]
                ],
                "choices": [
                  [
                    [20, 35, 80, 96],
                    [10, 25, 55, 65]
                  ], // Correct
                  [
                    [10, 20, 25, 35],
                    [55, 65, 80, 96]
                  ], // Incorrect
                  [
                    [10, 55, 25, 35],
                    [20, 65, 80, 96]
                  ] // Incorrect
                ]
              },
              {
                "correct": [
                  [10, 20, 25, 35, 55, 65, 80, 96]
                ],
                "choices": [
                  [
                    [10, 20, 25, 35, 55, 65, 80, 96]
                  ], // Correct
                  [
                    [96, 80, 65, 55, 35, 25, 20, 10]
                  ], // Incorrect
                  [
                    [25, 10, 20, 55, 35, 65, 80, 96]
                  ] // Incorrect
                ]
              }
            ]
          },
          {
            "given": [78, 40, 68, 22, 50, 12, 60, 25],
            "stages": [
              {
                "correct": [
                  [40, 78],
                  [22, 68],
                  [12, 50],
                  [25, 60]
                ],
                "choices": [
                  [
                    [22, 12],
                    [40, 25],
                    [50, 78],
                    [60, 68]
                  ], // Incorrect
                  [
                    [40, 78],
                    [22, 68],
                    [12, 50],
                    [25, 60]
                  ], // Correct
                  [
                    [12, 22],
                    [25, 40],
                    [50, 60],
                    [68, 78]
                  ] // Incorrect
                ]
              },
              {
                "correct": [
                  [22, 40, 68, 78],
                  [12, 25, 50, 60]
                ],
                "choices": [
                  [
                    [22, 40, 68, 78],
                    [12, 25, 50, 60]
                  ], // Correct
                  [
                    [12, 22, 25, 40],
                    [50, 60, 68, 78]
                  ], // Incorrect
                  [
                    [12, 50, 25, 40],
                    [22, 60, 68, 78]
                  ] // Incorrect
                ]
              },
              {
                "correct": [
                  [12, 22, 25, 40, 50, 60, 68, 78]
                ],
                "choices": [
                  [
                    [12, 22, 25, 40, 50, 60, 68, 78]
                  ], // Correct
                  [
                    [78, 68, 60, 50, 40, 25, 22, 12]
                  ], // Incorrect
                  [
                    [25, 40, 50, 68, 60, 22, 12, 78]
                  ] // Incorrect
                ]
              }
            ]
          }
        ],
        "time": 30,
        "hearts": 1,
      },

      "8": {
        "questions": [
          {
            "given": [55, 12, 48, 3, 19, 8, 33, 25, 41],
            "stages": [
              {
                "correct": [
                  [12, 55],
                  [3, 48],
                  [8, 19],
                  [25, 33],
                  [41]
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
                    [12, 55],
                    [3, 48],
                    [8, 19],
                    [25, 33],
                    [41]
                  ], // Correct
                ],
              },
              {
                "correct": [
                  [3, 12, 48, 55],
                  [8, 19, 25, 33],
                  [41]
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
                    [3, 12, 48, 55],
                    [8, 19, 25, 33],
                    [41]
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
          },
          {
            "given": [60, 15, 50, 5, 20, 10, 30, 25, 40],
            "stages": [
              {
                "correct": [
                  [15, 60],
                  [5, 50],
                  [10, 20],
                  [25, 30],
                  [40]
                ],
                "choices": [
                  [
                    [5, 10],
                    [20, 15],
                    [50, 25],
                    [30, 40],
                    [60]
                  ], // Incorrect
                  [
                    [15, 60],
                    [5, 50],
                    [10, 20],
                    [25, 30],
                    [40]
                  ], // Correct
                  [
                    [10, 20],
                    [5, 15],
                    [30, 25],
                    [50, 40],
                    [60]
                  ] // Incorrect
                ]
              },
              {
                "correct": [
                  [5, 15, 50, 60],
                  [10, 20, 25, 30],
                  [40]
                ],
                "choices": [
                  [
                    [10, 5, 20, 15],
                    [30, 25, 50, 40],
                    [60]
                  ], // Incorrect
                  [
                    [5, 15, 50, 60],
                    [10, 20, 25, 30],
                    [40]
                  ], // Correct
                  [
                    [5, 10, 25, 20],
                    [15, 30, 40, 50],
                    [60]
                  ] // Incorrect
                ]
              },
              {
                "correct": [
                  [5, 10, 15, 20, 25, 30, 40, 50, 60]
                ],
                "choices": [
                  [
                    [10, 5, 20, 15, 50, 40, 30, 60, 25]
                  ], // Incorrect
                  [
                    [5, 10, 15, 20, 25, 30, 40, 50, 60]
                  ], // Correct
                  [
                    [60, 50, 40, 30, 25, 20, 15, 10, 5]
                  ] // Incorrect
                ]
              }
            ]
          },
          {
            "given": [70, 20, 60, 10, 30, 15, 50, 25, 40],
            "stages": [
              {
                "correct": [
                  [20, 70],
                  [10, 60],
                  [15, 30],
                  [25, 50],
                  [40]
                ],
                "choices": [
                  [
                    [10, 20],
                    [15, 25],
                    [30, 60],
                    [50, 40],
                    [70]
                  ], // Incorrect
                  [
                    [20, 70],
                    [10, 60],
                    [15, 30],
                    [25, 50],
                    [40]
                  ], // Correct
                  [
                    [15, 10],
                    [20, 60],
                    [25, 30],
                    [50, 40],
                    [70]
                  ] // Incorrect
                ]
              },
              {
                "correct": [
                  [10, 20, 60, 70],
                  [15, 25, 30, 50],
                  [40]
                ],
                "choices": [
                  [
                    [15, 10, 25, 20],
                    [30, 50, 60, 40],
                    [70]
                  ], // Incorrect
                  [
                    [10, 20, 60, 70],
                    [15, 25, 30, 50],
                    [40]
                  ], // Correct
                  [
                    [10, 15, 25, 20],
                    [30, 40, 50, 60],
                    [70]
                  ] // Incorrect
                ]
              },
              {
                "correct": [
                  [10, 15, 20, 25, 30, 40, 50, 60, 70]
                ],
                "choices": [
                  [
                    [20, 10, 15, 25, 60, 50, 40, 30, 70]
                  ], // Incorrect
                  [
                    [10, 15, 20, 25, 30, 40, 50, 60, 70]
                  ], // Correct
                  [
                    [70, 60, 50, 40, 30, 25, 20, 15, 10]
                  ] // Incorrect
                ]
              }
            ]
          },
          {
            "given": [80, 30, 70, 15, 50, 20, 60, 25, 40],
            "stages": [
              {
                "correct": [
                  [30, 80],
                  [15, 70],
                  [20, 50],
                  [25, 60],
                  [40]
                ],
                "choices": [
                  [
                    [20, 15],
                    [30, 50],
                    [60, 70],
                    [25, 40],
                    [80]
                  ], // Incorrect
                  [
                    [30, 80],
                    [15, 70],
                    [20, 50],
                    [25, 60],
                    [40]
                  ], // Correct
                  [
                    [15, 30],
                    [20, 70],
                    [40, 25],
                    [50, 60],
                    [80]
                  ] // Incorrect
                ]
              },
              {
                "correct": [
                  [15, 30, 70, 80],
                  [20, 25, 50, 60],
                  [40]
                ],
                "choices": [
                  [
                    [15, 20, 30, 50],
                    [25, 40, 70, 60],
                    [80]
                  ], // Incorrect
                  [
                    [15, 30, 70, 80],
                    [20, 25, 50, 60],
                    [40]
                  ], // Correct
                  [
                    [20, 25, 15, 50],
                    [30, 60, 40, 70],
                    [80]
                  ] // Incorrect
                ]
              },
              {
                "correct": [
                  [15, 20, 25, 30, 40, 50, 60, 70, 80]
                ],
                "choices": [
                  [
                    [20, 15, 25, 30, 50, 60, 40, 70, 80]
                  ], // Incorrect
                  [
                    [15, 20, 25, 30, 40, 50, 60, 70, 80]
                  ], // Correct
                  [
                    [80, 70, 60, 50, 40, 30, 25, 20, 15]
                  ] // Incorrect
                ]
              }
            ]
          },
        ],
        "time": 30,
        "hearts": 1,
      }
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
        visualizedStages.add(correctChoice);
        currentStage++;
        if (currentStage >= stages.length) {
          isGameComplete = true;
          _playWinSound(); // Play win sound when the game is complete
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
    _playGameOverSound(); // Play game-over sound
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Game Over"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              setState(() {
                initializeGame(); // Reinitialize the game for the current level
              });
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
