import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
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
  bool isAnimating = false; // Disable buttons during animation
  bool showTopLeftBorder = true; // Show border for top-left cell initially

  late AudioPlayer audioPlayer;

  late AudioPlayer backgroundMusicPlayer; // New player for background music

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    backgroundMusicPlayer = AudioPlayer();
    _initializeGrid();

    // Play background music
    _playBackgroundMusic();

    // Show instructions popup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showInstructions();
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    backgroundMusicPlayer.dispose(); // Dispose of background music player
    super.dispose();
  }

  void _playBackgroundMusic() async {
    try {
      await backgroundMusicPlayer.setReleaseMode(ReleaseMode.loop); // Loop mode
      await backgroundMusicPlayer.setVolume(0.3); // Set volume to max
      await backgroundMusicPlayer
          .play(AssetSource('Sounds/radix.mp3')); // Play background music
    } catch (e) {
      print('Error playing background music: $e');
    }
  }

  void _playSound(String assetPath) async {
    await audioPlayer.play(AssetSource(assetPath));
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

  Future<void> _waveFloodFill(
      int x, int y, Color targetColor, Color replacementColor) async {
    if (targetColor == replacementColor) return;

    setState(() {
      isAnimating = true;
    });

    List<List<bool>> visited =
        List.generate(gridSize, (_) => List.filled(gridSize, false));

    Future<void> floodCell(int x, int y) async {
      if (x < 0 ||
          x >= gridSize ||
          y < 0 ||
          y >= gridSize ||
          visited[x][y] ||
          grid[x][y] != targetColor) {
        return;
      }

      visited[x][y] = true;
      await Future.delayed(Duration(milliseconds: 50));

      setState(() {
        grid[x][y] = replacementColor;
      });

      await floodCell(x + 1, y);
      await floodCell(x - 1, y);
      await floodCell(x, y + 1);
      await floodCell(x, y - 1);
    }

    await floodCell(x, y);

    setState(() {
      isAnimating = false;
      showTopLeftBorder = false;
    });

    if (_isGameWon()) {
      _showEndDialog(
          "Congratulations! You Won!"); // Winning sound will play here
    } else if (remainingMoves == 0) {
      _showEndDialog("Game Over");
    }
  }

  void _onColorSelected(Color selectedColor) async {
    if (isAnimating || remainingMoves <= 0) return;

    Color targetColor = grid[0][0];
    if (selectedColor == targetColor) return;

    setState(() {
      remainingMoves--;
    });

    _playSound('Sounds/binarysearchclick.mp3'); // Add this line

    await _waveFloodFill(0, 0, targetColor, selectedColor);
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
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: Center(
          child: Column(
            children: [
              Icon(Icons.colorize, size: 50, color: Colors.deepPurpleAccent),
              SizedBox(height: 10),
              Text(
                "How to Play",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _instructionStep(
                icon: Icons.color_lens,
                iconColor: Colors.blueAccent,
                text:
                    "Your goal is to flood the entire grid with one color in $maxMoves moves or fewer.",
              ),
              SizedBox(height: 12),
              _instructionStep(
                icon: Icons.touch_app,
                iconColor: Colors.orange,
                text:
                    "Tap on a color button below. The grid will fill in a wave-like pattern starting from the top-left corner.",
              ),
              SizedBox(height: 12),
              _instructionStep(
                icon: Icons.animation,
                iconColor: Colors.green,
                text:
                    "Watch the grid animate as the colors fill up! The wave spreads dynamically.",
              ),
              SizedBox(height: 12),
              _instructionStep(
                icon: Icons.lightbulb,
                iconColor: Colors.yellow,
                text:
                    "Plan your moves wisely! Fill the grid with a single color before running out of moves.",
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  "Good luck, and have fun!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text(
                "Start Game",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _instructionStep(
      {required IconData icon,
      required Color iconColor,
      required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24, color: iconColor),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  void _showEndDialog(String message) {
    if (message.contains("Won")) {
      _playSound('Sounds/win.mp3'); // Play win sound only for win
    } else {
      _playSound('Sounds/gameover.mp3'); // Gameover sound remains
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          // AlertDialog code here
          ),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: Center(
          child: Text(
            message,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: message.contains("Won") ? Colors.green : Colors.red,
            ),
          ),
        ),
        actions: [
          Center(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      remainingMoves = maxMoves;
                      _initializeGrid();
                      showTopLeftBorder = true; // Reset border for a new game
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Text(
                    "Play Again",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Text(
                    "Exit",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Color Flood Game",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: Colors.white),
            onPressed: _showInstructions,
          ),
        ],
      ),
      body: Stack(
        children: [
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridSize,
            ),
            itemCount: gridSize * gridSize,
            itemBuilder: (context, index) {
              int x = index ~/ gridSize;
              int y = index % gridSize;

              return AnimatedContainer(
                duration: Duration(milliseconds: 200), // Faster animation
                margin: EdgeInsets.all(1.0),
                decoration: BoxDecoration(
                  color: grid[x][y],
                  border: (x == 0 && y == 0 && showTopLeftBorder)
                      ? Border.all(color: Colors.black, width: 3)
                      : null,
                ),
              );
            },
          ),
          Positioned(
            bottom: 150,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  "Moves Left: $remainingMoves",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: colors.map((color) {
                  return GestureDetector(
                    onTap: isAnimating ? null : () => _onColorSelected(color),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
