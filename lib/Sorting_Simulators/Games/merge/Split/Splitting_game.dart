import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

class SplittingGame extends StatefulWidget {
  final dynamic level;

  const SplittingGame({Key? key, required this.level}) : super(key: key);

  @override
  _SplittingGameState createState() => _SplittingGameState();
}

class _SplittingGameState extends State<SplittingGame> {
  late int level;
  late List<int> values;
  late List<String> gaps; // "," (wrong), "|" (correct), "-" (widened)
  late List<List<String>> stagesGaps;
  int currentStage = 0;
  bool isGameComplete = false;
  int hearts = 0;
  int timeRemaining = 0; // Timer in seconds
  Timer? timer;
  late AudioPlayer backgroundMusicPlayer;
  late AudioPlayer effectPlayer;

  @override
  void initState() {
    super.initState();
    level = (widget.level is String) ? int.parse(widget.level) : widget.level;
    backgroundMusicPlayer = AudioPlayer();
    effectPlayer = AudioPlayer();
    resetGame();
    _playBackgroundMusic(); // Start the background music
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
      await backgroundMusicPlayer
          .setVolume(0.2); // Lower volume for background music
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

  void resetGame() {
    setState(() {
      timer?.cancel(); // Cancel any existing timer

      // Level-specific setup
      switch (level) {
        case 1:
          setupLevel(4, [
            [",", "|", ","],
            ["|", "-", "|"]
          ]);
          hearts = 0; // No hearts or timer for levels 1–4
          timeRemaining = 0;
          break;
        case 2:
          setupLevel(5, [
            [",", ",", "|", ","],
            [",", "|", "-", "|"],
            ["|", "-", "-", "-"]
          ]);
          hearts = 0;
          timeRemaining = 0;
          break;
        case 3:
          setupLevel(6, [
            [",", ",", "|", ",", ","],
            [",", "|", "-", ",", "|", ","],
            ["|", "-", "-", "|", "-", "-"]
          ]);
          hearts = 0;
          timeRemaining = 0;
          break;
        case 4:
          setupLevel(7, [
            [",", ",", ",", "|", ",", ","],
            [",", "|", ",", "-", ",", "|", ","],
            ["|", "-", "|", "-", "|", "-", "-"]
          ]);
          hearts = 0;
          timeRemaining = 0;
          break;
        case 5:
          setupLevel(8, [
            [",", ",", ",", "|", ",", ",", ","],
            [",", "|", ",", "-", ",", "|", ","],
            ["|", "-", "|", "-", "|", "-", "|", "-"]
          ]);
          hearts = 3; // Add hearts and timer
          timeRemaining = 30;
          startTimer();
          break;
        case 6:
          setupLevel(7, [
            [",", ",", ",", "|", ",", ","],
            [",", "|", ",", "-", ",", "|", ","],
            ["|", "-", "|", "-", "|", "-", "-"]
          ]);
          hearts = 3;
          timeRemaining = 30;
          startTimer();
          break;
        case 7:
          setupRandomLevel([
            {
              "values": 4,
              "stages": [
                [",", "|", ","],
                ["|", "-", "|"]
              ]
            },
            {
              "values": 6,
              "stages": [
                [",", ",", "|", ",", ","],
                [",", "|", "-", "|", ","],
                ["|", "-", "-", "|", "-"]
              ]
            },
            {
              "values": 8,
              "stages": [
                [",", ",", ",", "|", ",", ",", ","],
                [",", "|", ",", "-", ",", "|", ","],
                ["|", "-", "|", "-", "|", "-", "|", "-"]
              ]
            },
          ]);
          hearts = 1;
          timeRemaining = 15;
          startTimer();
          break;
        case 8:
          setupRandomLevel([
            {
              "values": 5,
              "stages": [
                [",", ",", "|", ","],
                [",", "|", "-", "|"],
                ["|", "-", "-", "-"]
              ]
            },
            {
              "values": 7,
              "stages": [
                [",", ",", ",", "|", ",", ","],
                [",", "|", ",", "-", "|", ","],
                ["|", "-", "|", "-", "|", "-", "-"]
              ]
            },
          ]);
          hearts = 1;
          timeRemaining = 15;
          startTimer();
          break;
        default:
          setupInvalidLevel();
      }
    });
  }

  void setupLevel(int numValues, List<List<String>> stages) {
    values = generateRandomValues(numValues);
    stagesGaps = stages;
    gaps = List.from(stagesGaps[0]); // Start with the first stage's gaps
    currentStage = 0;
    isGameComplete = false;
  }

  void setupRandomLevel(List<Map<String, dynamic>> options) {
    Random random = Random();
    final selected = options[random.nextInt(options.length)];
    setupLevel(selected["values"], selected["stages"]);
  }

  List<int> generateRandomValues(int numValues) {
    Random random = Random();
    return List.generate(numValues, (_) => random.nextInt(50) + 1);
  }

  void setupInvalidLevel() {
    values = [];
    gaps = [];
    stagesGaps = [];
    currentStage = 0;
    isGameComplete = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Invalid Level"),
          content: Text("Level $level is not defined."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Back"),
            ),
          ],
        ),
      );
    });
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeRemaining > 0) {
        setState(() {
          timeRemaining--;
        });
      } else {
        timer.cancel();
        setState(() {
          isGameComplete = true;
        });
        showFailureDialog("Time's up! Try again.");
      }
    });
  }

  void onGapTap(int gapIndex) {
    if (isGameComplete || gapIndex >= gaps.length || gaps[gapIndex] != "|") {
      if (hearts > 0) {
        setState(() => hearts--);
        if (hearts == 0) {
          isGameComplete = true;
          showFailureDialog("You ran out of hearts!");
        }
      }
      return;
    }

    setState(() {
      gaps[gapIndex] = "-"; // Widen the correct gap

      if (!gaps.contains("|")) {
        if (currentStage == stagesGaps.length - 1) {
          isGameComplete = true;
          showCompletionDialog();
        } else {
          currentStage++;
          gaps = List.from(stagesGaps[currentStage]);
        }
      }
    });
  }

  void showCompletionDialog() {
    timer?.cancel();
    _playWinSound(); // Play win sound
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            "🎉 Level Complete!",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        content: Text(
          "Congratulations on completing Level $level!",
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              resetGame();
            },
            child: Text("Retry"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (level < 8) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SplittingGame(level: level + 1),
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("No More Levels!"),
                    content: Text(
                      "You’ve completed all available levels. More coming soon!",
                      textAlign: TextAlign.center,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("OK"),
                      ),
                    ],
                  ),
                );
              }
            },
            child: Text("Next Level"),
          ),
        ],
      ),
    );
  }

  void showFailureDialog(String message) {
    timer?.cancel();
    _playGameOverSound(); // Play game-over sound
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            "💔 Game Over",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              resetGame();
            },
            child: Text("Retry Level"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Splitting Game - Level $level"),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (!isGameComplete && level >= 5)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "⏳ Time: $timeRemaining",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: List.generate(
                        hearts,
                        (index) => Icon(Icons.favorite, color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            if (!isGameComplete)
              Text(
                "Stage ${currentStage + 1} / ${stagesGaps.length}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            Expanded(
              child: Center(
                child: buildStage(),
              ),
            ),
            ElevatedButton(
              onPressed: resetGame,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: Text(
                "Restart Level $level",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStage() {
    List<Widget> widgets = [];
    for (int i = 0; i < values.length; i++) {
      widgets.add(Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          values[i].toString(),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ));
      if (i < gaps.length) {
        widgets.add(GestureDetector(
          onTap: () => onGapTap(i),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: gaps[i] == "-" ? 100 : 10,
            height: 40,
            color: gaps[i] == "-" ? Colors.transparent : Colors.grey[400],
            margin: EdgeInsets.symmetric(horizontal: 4),
          ),
        ));
      }
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widgets,
      ),
    );
  }
}
