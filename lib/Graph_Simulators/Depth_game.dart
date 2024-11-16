import 'package:flutter/material.dart';
import 'dart:math';

class DepthGamePage extends StatefulWidget {
  const DepthGamePage({Key? key}) : super(key: key);

  @override
  _DepthGamePageState createState() => _DepthGamePageState();
}

class _DepthGamePageState extends State<DepthGamePage> {
  static const int gridSize = 10;
  static const int maxMoves = 20;

  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
  ];

  late List<List<Color>> grid;
  int remainingMoves = maxMoves;

  @override
  void initState() {
    super.initState();
    _initializeGrid();

    // Show instructions popup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showInstructions();
    });
  }

  void _initializeGrid() {
    Random random = Random();
    grid = List.generate(
      gridSize,
      (_) => List.generate(
        gridSize,
        (_) => colors[random.nextInt(colors.length)],
      ),
    );
  }

  void _floodFill(int x, int y, Color targetColor, Color replacementColor) {
    if (x < 0 ||
        x >= gridSize ||
        y < 0 ||
        y >= gridSize ||
        grid[x][y] != targetColor ||
        grid[x][y] == replacementColor) {
      return;
    }

    grid[x][y] = replacementColor;

    _floodFill(x + 1, y, targetColor, replacementColor);
    _floodFill(x - 1, y, targetColor, replacementColor);
    _floodFill(x, y + 1, targetColor, replacementColor);
    _floodFill(x, y - 1, targetColor, replacementColor);
  }

  void _onColorSelected(Color selectedColor) {
    if (remainingMoves <= 0) return;

    Color targetColor = grid[0][0];
    if (selectedColor == targetColor) return;

    setState(() {
      _floodFill(0, 0, targetColor, selectedColor);
      remainingMoves--;

      if (_isGameWon()) {
        _showEndDialog("You Won!");
      } else if (remainingMoves == 0) {
        _showEndDialog("Game Over");
      }
    });
  }

  bool _isGameWon() {
    Color firstColor = grid[0][0];
    for (var row in grid) {
      if (row.any((color) => color != firstColor)) {
        return false;
      }
    }
    return true;
  }

  void _showInstructions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("How to Play"),
        content: Text(
          "Flood the entire grid with a single color in $maxMoves moves or less.\n\n"
          "Tap on a color below to flood-fill the grid starting from the top-left corner.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Got it!"),
          ),
        ],
      ),
    );
  }

  void _showEndDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                remainingMoves = maxMoves;
                _initializeGrid();
              });
            },
            child: Text("Play Again"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pop(context);
            },
            child: Text("Exit"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Color Flood Game"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridSize,
              ),
              itemCount: gridSize * gridSize,
              itemBuilder: (context, index) {
                int x = index ~/ gridSize;
                int y = index % gridSize;
                return Container(
                  margin: EdgeInsets.all(1.0),
                  color: grid[x][y],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: colors.map((color) {
                return GestureDetector(
                  onTap: () => _onColorSelected(color),
                  child: Container(
                    width: 40,
                    height: 40,
                    color: color,
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Moves Left: $remainingMoves",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold, // Makes the text bold
              ),
            ),
          ),
        ],
      ),
    );
  }
}
