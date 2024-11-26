import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'dart:collection';

class Node {
  int value;
  Node? left;
  Node? right;

  Node(this.value);
}

class BinaryTree {
  Node? root;
  final int maxNodes;
  final int depth;

  BinaryTree(this.depth, this.maxNodes) {
    root = _createRandomTree(depth, maxNodes);
  }

  Node _createRandomTree(int depth, int maxNodes, [int currentCount = 1]) {
    if (depth == 0 || currentCount >= maxNodes)
      return Node(_generateRandomValue());

    Node node = Node(_generateRandomValue());
    int remainingNodes = maxNodes - currentCount;

    if (depth > 1 && remainingNodes > 1) {
      int leftNodes = Random().nextInt(remainingNodes);
      node.left =
          _createRandomTree(depth - 1, maxNodes, currentCount + leftNodes);
      node.right =
          _createRandomTree(depth - 1, maxNodes, currentCount + leftNodes + 1);
    }
    return node;
  }

  int _generateRandomValue() {
    return 100 + Random().nextInt(900); // Random values between 100 and 999
  }

  List<Node> breadthFirstTraversal() {
    List<Node> result = [];
    Queue<Node> queue = Queue<Node>();

    if (root != null) queue.add(root!);

    while (queue.isNotEmpty) {
      Node node = queue.removeFirst();
      result.add(node);

      if (node.left != null) queue.add(node.left!);
      if (node.right != null) queue.add(node.right!);
    }
    return result;
  }
}

void main() {
  runApp(StarGameApp());
}

class StarGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Space Constellation Game',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurpleAccent,
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: MainMenuScreen(),
    );
  }
}

class MainMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          StarryBackground(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Space Constellation Game",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurpleAccent,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.deepPurpleAccent.shade200,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                _buildMenuButton(
                  text: "Play Game",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DifficultySelectionScreen()),
                    );
                  },
                ),
                SizedBox(height: 20),
                _buildMenuButton(
                  text: "How to Play",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HowToPlayScreen()),
                    );
                  },
                ),
                SizedBox(height: 20),
                _buildMenuButton(
                  text: "Exit",
                  onTap: () {
                    Navigator.pop(
                        context); // Exit the app (or close the screen).
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton({required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 250,
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.shade700,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class StarryBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black, Colors.deepPurple.shade900],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: CustomPaint(
        painter: StarFieldPainter(),
        size: Size.infinite,
      ),
    );
  }
}

class StarFieldPainter extends CustomPainter {
  final Random random = Random();
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.7);
    for (int i = 0; i < 100; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      canvas.drawCircle(Offset(x, y), random.nextDouble() * 1.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DifficultySelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Difficulty")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDifficultyButton(context, "Easy"),
            _buildDifficultyButton(context, "Medium"),
            _buildDifficultyButton(context, "Hard"),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Back"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyButton(BuildContext context, String difficulty) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StarGameScreen(difficulty: difficulty)),
          );
        },
        child: Text(
          difficulty,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}

class HowToPlayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("How to Play")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "How to Play:",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              "1. Select the correct nodes in the order of breadth-first traversal.\n"
              "2. The game ends if you make a mistake or time runs out.\n"
              "3. Have fun!",
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Back"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StarGameScreen extends StatefulWidget {
  final String difficulty;
  StarGameScreen({required this.difficulty});

  @override
  _StarGameScreenState createState() => _StarGameScreenState();
}

class _StarGameScreenState extends State<StarGameScreen> {
  late int maxNodes;
  late int currentRound;
  late BinaryTree tree;
  late List<Node> traversalPath;
  late Timer _timer;
  int currentStep = 0;
  int timeLeft = 60;
  bool gameOver = false;
  String message =
      "Select nodes in the correct order of breadth-first traversal.";
  List<Node> selectedNodes = [];
  List<Color> lineColors = [];
  Map<Node, Offset> nodePositions = {};

  @override
  void initState() {
    super.initState();
    currentRound = 1;
    _setDifficulty();
    _startNewRound();
    _startTimer();
  }

  void _setDifficulty() {
    switch (widget.difficulty) {
      case "Easy":
        maxNodes = 15;
        break;
      case "Medium":
        maxNodes = 20;
        break;
      case "Hard":
        maxNodes = 30;
        break;
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeft > 0 && !gameOver) {
        setState(() {
          timeLeft--;
        });
      } else {
        _timer.cancel();
        _triggerGameOver("Time's up! Game over.");
      }
    });
  }

  void _triggerGameOver(String endMessage) {
    setState(() {
      gameOver = true;
      message = endMessage;
    });
  }

  void _startNewRound() {
    int treeDepth = min(2 + currentRound, maxNodes ~/ 2);
    tree = BinaryTree(treeDepth, maxNodes);
    traversalPath = tree.breadthFirstTraversal();
    selectedNodes.clear();
    lineColors.clear();
    currentStep = 0;
    gameOver = false;
    timeLeft = 60;
    message = "Round $currentRound: Select nodes in the correct order.";
  }

  void _calculateNodePositions(
      Node node, int level, double x, double y, double xOffset) {
    nodePositions[node] = Offset(x, y);

    if (node.left != null) {
      _calculateNodePositions(
          node.left!, level + 1, x - xOffset, y + 80, xOffset / 2);
    }
    if (node.right != null) {
      _calculateNodePositions(
          node.right!, level + 1, x + xOffset, y + 80, xOffset / 2);
    }
  }

  void onNodeSelected(Node node) {
    if (gameOver) return;

    if (currentStep < traversalPath.length &&
        traversalPath[currentStep] == node) {
      setState(() {
        selectedNodes.add(node);
        lineColors.add(_generateRandomColor());
        currentStep++;
        message = "Great! Keep going.";

        if (currentStep == traversalPath.length) {
          if (currentRound < 5) {
            currentRound++;
            _startNewRound();
          } else {
            _triggerGameOver("Congratulations! You've completed all rounds!");
            _timer.cancel();
          }
        }
      });
    } else {
      _timer.cancel();
      _triggerGameOver("Wrong node! Game over.");
    }
  }

  Color _generateRandomColor() {
    return Color.fromARGB(255, Random().nextInt(256), Random().nextInt(256),
        Random().nextInt(256));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget buildTreeNode(Node node) {
    final position = nodePositions[node] ?? Offset.zero;
    final selectionIndex = selectedNodes.indexOf(node);
    return Positioned(
      left: position.dx - 15,
      top: position.dy - 15,
      child: GestureDetector(
        onTap: () => onNodeSelected(node),
        child: Column(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: Colors.blueAccent,
              child: Text(
                'N${node.value}',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
            if (selectionIndex >= 0)
              Text(
                '${selectionIndex + 1}',
                style: TextStyle(color: Colors.white70),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameOverOverlay() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Game Over",
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent),
            ),
            SizedBox(height: 20),
            Text(
              message,
              style: TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  currentRound = 1;
                  _startNewRound();
                  _startTimer();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
              ),
              child: Text("Retry", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: Text("Return to Main Menu",
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    nodePositions.clear();
    _calculateNodePositions(
        tree.root!,
        0,
        MediaQuery.of(context).size.width / 2,
        100,
        MediaQuery.of(context).size.width / 4);

    return Scaffold(
      appBar: AppBar(
          title: Text("Game - ${widget.difficulty} - Round $currentRound")),
      body: Stack(
        children: [
          StarryBackground(),
          Positioned(
            top: 20,
            left: MediaQuery.of(context).size.width / 2 - 150,
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          Positioned(
            top: 60,
            left: MediaQuery.of(context).size.width / 2 - 40,
            child: Text(
              "Time Left: $timeLeft s",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent),
            ),
          ),
          CustomPaint(
            size: Size.infinite,
            painter: TreeLinePainter(nodePositions, selectedNodes, lineColors),
          ),
          for (var node in traversalPath) buildTreeNode(node),
          if (gameOver) _buildGameOverOverlay(),
        ],
      ),
    );
  }
}

class TreeLinePainter extends CustomPainter {
  final Map<Node, Offset> nodePositions;
  final List<Node> selectedNodes;
  final List<Color> lineColors;

  TreeLinePainter(this.nodePositions, this.selectedNodes, this.lineColors);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < selectedNodes.length - 1; i++) {
      final startNode = selectedNodes[i];
      final endNode = selectedNodes[i + 1];

      final startPosition = nodePositions[startNode];
      final endPosition = nodePositions[endNode];

      if (startPosition != null && endPosition != null) {
        paint.color = lineColors[i];
        canvas.drawLine(startPosition, endPosition, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
