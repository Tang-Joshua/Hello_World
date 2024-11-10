import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class Merge_Game extends StatefulWidget {
  @override
  _Merge_GameState createState() => _Merge_GameState();
}

class _Merge_GameState extends State<Merge_Game> {
  List<int> array = [];
  List<List<int>> splitArray = [];
  int lives = 3;
  int timeLeft = 60;
  Timer? gameTimer;
  Random random = Random();

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  void initializeGame() {
    // Reset game state
    array = List.generate(8, (_) => random.nextInt(100));
    splitArray = [array];
    lives = 3;
    timeLeft = 60;
    startTimer();
  }

  void startTimer() {
    gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        timeLeft--;
      });
      if (timeLeft <= 0) {
        timer.cancel();
        endGame("Time's up! You lost.");
      }
    });
  }

  void splitArrayInHalf(int listIndex) {
    List<int> currentArray = splitArray[listIndex];

    // Verify if it's valid to split exactly in half
    if (currentArray.length < 2) {
      // Cannot split further
      return;
    }

    int halfIndex = currentArray.length ~/ 2;

    // If not splitting in half, reduce lives and return
    if (currentArray.length % 2 != 0 || halfIndex == 0) {
      setState(() {
        lives--;
      });
      if (lives <= 0) {
        endGame("No more lives! You lost.");
      }
      return;
    }

    // Perform the split in half if valid
    List<int> left = currentArray.sublist(0, halfIndex);
    List<int> right = currentArray.sublist(halfIndex);

    setState(() {
      splitArray.removeAt(listIndex);
      splitArray.insert(listIndex, right);
      splitArray.insert(listIndex, left);
    });
  }

  void mergeArrays(int leftIndex, int rightIndex) {
    List<int> left = splitArray[leftIndex];
    List<int> right = splitArray[rightIndex];
    List<int> merged = mergeSortedLists(left, right);

    setState(() {
      splitArray.removeAt(rightIndex);
      splitArray[leftIndex] = merged;
    });

    if (splitArray.length == 1 && isSorted(splitArray[0])) {
      gameTimer?.cancel();
      endGame("Congratulations! You completed the merge sort.");
    }
  }

  List<int> mergeSortedLists(List<int> left, List<int> right) {
    List<int> result = [];
    int i = 0, j = 0;
    while (i < left.length && j < right.length) {
      if (left[i] <= right[j]) {
        result.add(left[i]);
        i++;
      } else {
        result.add(right[j]);
        j++;
      }
    }
    result.addAll(left.sublist(i));
    result.addAll(right.sublist(j));
    return result;
  }

  bool isSorted(List<int> list) {
    for (int i = 1; i < list.length; i++) {
      if (list[i] < list[i - 1]) return false;
    }
    return true;
  }

  void endGame(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Game Over"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              initializeGame();
            },
            child: Text("Play Again"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Merge Game"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text("Lives: $lives")),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text("Time: $timeLeft")),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: splitArray.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.blue[100],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < splitArray[index].length; i++) ...[
                        Text(
                          "${splitArray[index][i]}",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        if (i == splitArray[index].length ~/ 2 - 1 &&
                            splitArray[index].length > 1)
                          GestureDetector(
                            onTap: () => splitArrayInHalf(index),
                            child: Icon(Icons.cut, color: Colors.red),
                          ),
                      ]
                    ],
                  ),
                );
              },
            ),
          ),
          if (splitArray.length > 1)
            ElevatedButton(
              onPressed: () {
                if (splitArray.length >= 2) {
                  mergeArrays(0, 1);
                }
              },
              child: Text("Merge First Two Arrays"),
            ),
          if (lives <= 0 || timeLeft <= 0)
            Center(
              child: Text(
                "Game Over! Restart to play again.",
                style: TextStyle(fontSize: 20, color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}
