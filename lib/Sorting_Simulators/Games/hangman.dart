import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async'; // For Future and async operations

void main() {
  runApp(HangmanGame());
}

class HangmanGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hangman Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HangmanScreen(),
    );
  }
}

class HangmanScreen extends StatefulWidget {
  @override
  _HangmanScreenState createState() => _HangmanScreenState();
}

class _HangmanScreenState extends State<HangmanScreen> {
  late List<int> _generatedNumbers;
  late List<int> _hiddenNumbers;
  late List<List<int>> _allSteps;
  int _incorrectGuesses = 0;
  // int _maxGuesses = 6;
  late List<List<int>> _gridNumbers;
  int _currentRow = 0;
  int _currentColumn = 0;

  bool _isFirstBox = true; // Flag to track the first box in the first step

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  // Generate random numbers for the game
  void _generateRandomNumbers() {
    final random = Random();
    _generatedNumbers = List.generate(4, (_) => random.nextInt(999) + 1);
    _hiddenNumbers = List.from(_generatedNumbers);
    _allSteps = [List.from(_generatedNumbers)];
    _gridNumbers = _createGridFromNumbers(_generatedNumbers);
    setState(() {});
  }

  // Create a grid of numbers from the list
  List<List<int>> _createGridFromNumbers(List<int> numbers) {
    int rows = 2;
    int columns = 2;
    List<List<int>> grid = List.generate(
        rows, (i) => List.generate(columns, (j) => numbers[i * columns + j]));
    return grid;
  }

  // Perform a single step of radix sort
  Future<List<int>> _radixSortStep(List<int> numbers, int digitPlace) async {
    int radix = 10;
    List<List<int>> buckets = List.generate(radix, (_) => []);
    for (int num in numbers) {
      int digit = (num ~/ pow(radix, digitPlace - 1)) % radix;
      buckets[digit].add(num);
    }
    return buckets.expand((bucket) => bucket).toList();
  }

  // Perform the full radix sort with steps
  Future<void> _performRadixSort() async {
    int maxDigitLength =
        _generatedNumbers.map((num) => num.toString().length).reduce(max);

    for (int digitPlace = 1; digitPlace <= maxDigitLength; digitPlace++) {
      var sortedList = await _radixSortStep(_generatedNumbers, digitPlace);
      _allSteps.add(List.from(sortedList));
      setState(() {});

      // Delay for a second to visualize the sorting step
      await Future.delayed(Duration(seconds: 1));

      // Apply the red border after the first step
      if (digitPlace == 1) {
        setState(() {
          _isFirstBox = true;
        });
      }
    }
  }

  void _startGame() {
    _generateRandomNumbers();
    _performRadixSort();
  }

  void _onNumberButtonPressed(int num) {
    if (_hiddenNumbers.contains(num)) {
      setState(() {
        _hiddenNumbers.remove(num);
        _moveToNextBox();
      });
    } else {
      setState(() {
        _incorrectGuesses++;
      });
    }
  }

  void _moveToNextBox() {
    if (_currentColumn < _gridNumbers[0].length - 1) {
      _currentColumn++;
    } else if (_currentRow < _gridNumbers.length - 1) {
      _currentRow++;
      _currentColumn = 0;
    } else {
      _showGameOver();
    }
  }

  void _showGameOver() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Game Over"),
          content: Text("You have guessed all the numbers or lost the game!"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _startGame();
              },
              child: Text("Restart"),
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
        title: Text('Hangman Game'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _startGame,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Center(
                      child: CustomPaint(
                        size: Size(150, 150),
                        painter: HangmanPainter(_incorrectGuesses),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Generated Numbers: ${_generatedNumbers.join(", ")}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _allSteps.map((stepNumbers) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: stepNumbers.map((num) {
                                bool isFirstBox =
                                    stepNumbers.indexOf(num) == 0 &&
                                        _isFirstBox;
                                return Container(
                                  width: 45,
                                  height: 45,
                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: isFirstBox
                                          ? Colors.red
                                          : Colors.black,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  alignment: Alignment.center,
                                  child: Visibility(
                                    visible: !_hiddenNumbers.contains(num),
                                    child: Text(
                                      num.toString(),
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (int row = 0; row < _gridNumbers.length; row++)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_gridNumbers[row].length, (column) {
                      int number = _gridNumbers[row][column];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            _onNumberButtonPressed(number);
                            _moveToNextBox();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text(
                            number.toString(),
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      );
                    }),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// CustomPainter class to draw the Hangman figure
class HangmanPainter extends CustomPainter {
  final int incorrectGuesses;
  HangmanPainter(this.incorrectGuesses);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    // Drawing the base (gallows)
    canvas.drawLine(Offset(size.width * 0.2, size.height * 0.9),
        Offset(size.width * 0.8, size.height * 0.9), paint);
    // Base
    canvas.drawLine(Offset(size.width * 0.5, size.height * 0.1),
        Offset(size.width * 0.5, size.height * 0.9), paint); // Vertical post
    canvas.drawLine(Offset(size.width * 0.5, size.height * 0.1),
        Offset(size.width * 0.75, size.height * 0.1), paint); // Top beam
    canvas.drawLine(Offset(size.width * 0.75, size.height * 0.1),
        Offset(size.width * 0.75, size.height * 0.2), paint); // Rope

    // Drawing the hangman parts based on incorrect guesses
    if (incorrectGuesses > 0) {
      // Head
      canvas.drawOval(
        Rect.fromCircle(
            center: Offset(size.width * 0.75, size.height * 0.25), radius: 20),
        paint,
      );
    }
    if (incorrectGuesses > 1) {
      // Body
      canvas.drawLine(
        Offset(size.width * 0.75, size.height * 0.3),
        Offset(size.width * 0.75, size.height * 0.5),
        paint,
      );
    }
    if (incorrectGuesses > 2) {
      // Left arm
      canvas.drawLine(
        Offset(size.width * 0.75, size.height * 0.35),
        Offset(size.width * 0.7, size.height * 0.4),
        paint,
      );
    }
    if (incorrectGuesses > 3) {
      // Right arm
      canvas.drawLine(
        Offset(size.width * 0.75, size.height * 0.35),
        Offset(size.width * 0.8, size.height * 0.4),
        paint,
      );
    }
    if (incorrectGuesses > 4) {
      // Left leg
      canvas.drawLine(
        Offset(size.width * 0.75, size.height * 0.5),
        Offset(size.width * 0.7, size.height * 0.6),
        paint,
      );
    }
    if (incorrectGuesses > 5) {
      // Right leg
      canvas.drawLine(
        Offset(size.width * 0.75, size.height * 0.5),
        Offset(size.width * 0.8, size.height * 0.6),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint whenever incorrectGuesses changes
  }
}
