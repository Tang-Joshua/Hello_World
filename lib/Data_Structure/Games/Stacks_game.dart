import 'package:flutter/material.dart';
import 'package:flutterapp/Data_Structure/Data_Choices.dart';

void main() => runApp(TowerOfHanoiApp());

class TowerOfHanoiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tower of Hanoi',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: TowerOfHanoiScreen(),
    );
  }
}

class TowerOfHanoiScreen extends StatefulWidget {
  @override
  _TowerOfHanoiScreenState createState() => _TowerOfHanoiScreenState();
}

class _TowerOfHanoiScreenState extends State<TowerOfHanoiScreen> {
  static const int numDisks = 4;
  List<List<int>> towers = [[], [], []];
  int moves = 0;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    setState(() {
      towers[0] = List.generate(numDisks, (index) => numDisks - index);
      towers[1] = [];
      towers[2] = [];
      moves = 0;
    });
  }

  bool _isValidMove(int from, int to) {
    if (towers[from].isEmpty) return false;
    if (towers[to].isEmpty) return true;
    return towers[from].last < towers[to].last;
  }

  bool _checkWin() {
    return towers[1].length == numDisks || towers[2].length == numDisks;
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Congratulations!',
              style: TextStyle(color: Colors.green[800])),
          content: Text('You solved it in $moves moves!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _initializeGame();
              },
              child: Text('Play Again',
                  style: TextStyle(color: Colors.green[800])),
            ),
          ],
        );
      },
    );
  }

  void _moveDisk(int from, int to) {
    setState(() {
      if (_isValidMove(from, to)) {
        towers[to].add(towers[from].removeLast());
        moves++;
        if (_checkWin()) _showWinDialog();
      }
    });
  }

  Widget _buildDisk(int size, int towerIndex, bool isTopDisk) {
    final diskColors = [Colors.blue, Colors.red, Colors.amber, Colors.purple];
    final diskColor = diskColors[size - 1];

    final diskWidget = Container(
      width: 24.0 * size,
      height: 24,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            diskColor.withOpacity(0.8),
            diskColor.withOpacity(1.0),
            diskColor.withOpacity(0.9),
          ],
          stops: [0.1, 0.5, 0.9],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(vertical: 6),
    );

    if (isTopDisk) {
      return Draggable<int>(
        data: towerIndex,
        child: diskWidget,
        feedback: Material(
          color: Colors.transparent,
          child: diskWidget,
        ),
        childWhenDragging: Container(
          width: 24.0 * size,
          height: 24,
          color: Colors.transparent,
        ),
      );
    } else {
      return diskWidget;
    }
  }

  Widget _buildTower(int index) {
    return Expanded(
      child: DragTarget<int>(
        onWillAccept: (fromIndex) => _isValidMove(fromIndex!, index),
        onAccept: (fromIndex) => _moveDisk(fromIndex, index),
        builder: (context, candidateData, rejectedData) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 20,
                  bottom: 12,
                  child: Container(
                    width: 8,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.grey[300]!,
                          Colors.grey[500]!,
                          Colors.grey[700]!
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: towers[index]
                      .reversed
                      .map((disk) =>
                          _buildDisk(disk, index, disk == towers[index].last))
                      .toList(),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: 100,
                    height: 10,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.grey[400]!,
                          Colors.grey[600]!,
                          Colors.grey[800]!
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tower of Hanoi'),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('How to Play'),
                  content: Text(
                    'Move all the disks from the first tower to the third tower, using the second tower as an intermediary.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DataChoices()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.green[50]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  'Tower of Hanoi',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  'Moves: $moves',
                  style: TextStyle(fontSize: 18, color: Colors.green[700]),
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTower(0),
                    _buildTower(1),
                    _buildTower(2),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: _initializeGame,
                  child: Text('Restart Game'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
