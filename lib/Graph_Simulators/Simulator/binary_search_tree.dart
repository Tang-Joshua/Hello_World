import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MaterialApp(home: BinarySearchPage()));
}

class BinarySearchPage extends StatefulWidget {
  const BinarySearchPage({Key? key}) : super(key: key);

  @override
  _BinarySearchPageState createState() => _BinarySearchPageState();
}

class TreeNode {
  int value;
  TreeNode? left;
  TreeNode? right;
  int index;
  bool isMoving = false;
  bool isCorrectPosition = true;

  TreeNode(this.value, this.index);
}

class _BinarySearchPageState extends State<BinarySearchPage>
    with TickerProviderStateMixin {
  TreeNode? _root;
  final Map<int, TextEditingController> _controllers = {};
  late TabController _tabController;
  AnimationController? _animationController;
  Animation<double>? _scaleAnimation;
  int? _highlightedIndex;
  bool _isConverted = false;
  bool _isChecked = false;
  List<int> _userNodeValues = [];
  late AudioPlayer _audioPlayer;
  bool isMusicPlaying = false; // To track the state of the music

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeRootNode();

    _audioPlayer = AudioPlayer(); // Initialize the audio player
    _playBackgroundMusic(); // Start playing background music

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showInstructions();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController?.dispose();
    _stopBackgroundMusic(); // Stop the music
    super.dispose();
  }

  void _playBackgroundMusic() async {
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop); // Loop the audio
      await _audioPlayer.setVolume(0.2); // Lower the volume
      await _audioPlayer
          .play(AssetSource('Sounds/simulationall.mp3')); // Play music file
      setState(() => isMusicPlaying = true);
    } catch (e) {
      print("Error playing background music: $e");
    }
  }

  void _stopBackgroundMusic() async {
    try {
      await _audioPlayer.stop();
      setState(() => isMusicPlaying = false);
    } catch (e) {
      print("Error stopping background music: $e");
    }
  }

  void _initializeRootNode() {
    _userNodeValues = [10];
    _root = TreeNode(_userNodeValues[0], 0);
    _controllers[_root!.index] =
        TextEditingController(text: _root!.value.toString());
  }

  void addNode(TreeNode parentNode, String position, int value) {
    int newIndex = (position == "left")
        ? parentNode.index * 2 + 1
        : parentNode.index * 2 + 2;
    TreeNode newNode = TreeNode(value, newIndex);
    _controllers[newIndex] = TextEditingController(text: value.toString());

    setState(() {
      if (position == "left" && parentNode.left == null) {
        parentNode.left = newNode;
      } else if (position == "right" && parentNode.right == null) {
        parentNode.right = newNode;
      }
      _userNodeValues.add(value);
    });
  }

  void deleteNode(TreeNode parentNode, String position) {
    setState(() {
      if (position == "left" && parentNode.left != null) {
        _removeSubtree(parentNode.left!);
        parentNode.left = null;
      } else if (position == "right" && parentNode.right != null) {
        _removeSubtree(parentNode.right!);
        parentNode.right = null;
      }
    });
  }

  void _removeSubtree(TreeNode node) {
    if (node.left != null) {
      _removeSubtree(node.left!);
    }
    if (node.right != null) {
      _removeSubtree(node.right!);
    }
    _userNodeValues.remove(node.value);
    _controllers.remove(node.index);
  }

  void clearTree() {
    setState(() {
      _controllers.clear();
      _initializeRootNode();
      _isConverted = false;
      _isChecked = false;
      _userNodeValues = [_root!.value];
    });
  }

  void convertTree() {
    setState(() {
      _isConverted = true;
    });
  }

  void checkTree() {
    if (_root == null) return;

    _resetCorrectness(_root);
    setState(() {
      _isChecked = true;
      _validateBST(_root, null, null);
    });
  }

  void _resetCorrectness(TreeNode? node) {
    if (node == null) return;
    node.isCorrectPosition = true;
    _resetCorrectness(node.left);
    _resetCorrectness(node.right);
  }

  void _showInstructions() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Instructions',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Title
              Row(
                children: [
                  Icon(Icons.info, color: Colors.blue, size: 24),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'How to Use Binary Search Tree Visualization:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Step-by-step Instructions
              _buildSteps(
                icon: Icons.add_circle_outline,
                text: 'Add Node: Use the "+" button to add nodes to the tree.',
                iconColor: Colors.green,
              ),
              _buildSteps(
                icon: Icons.remove_circle_outline,
                text:
                    'Delete Node: Use the "-" button to remove a specific node.',
                iconColor: Colors.red,
              ),
              _buildSteps(
                icon: Icons.transform,
                text:
                    'Convert Tree: Click the "Convert" button to finalize the tree structure.',
                iconColor: Colors.blue,
              ),
              _buildSteps(
                icon: Icons.check_circle,
                text:
                    'Check Tree: Validates the Binary Search Tree and highlights incorrect nodes.',
                iconColor: Colors.orange,
              ),
              _buildSteps(
                icon: Icons.sort,
                text:
                    'Sort Tree: Rearranges nodes to adhere to BST rules after validation.',
                iconColor: Colors.purple,
              ),
              _buildSteps(
                icon: Icons.clear,
                text:
                    'Clear Tree: Resets the tree structure for a fresh start.',
                iconColor: Colors.red,
              ),
              const SizedBox(height: 16),

              // Button Guide
              Row(
                children: [
                  Icon(Icons.help_outline, color: Colors.blue, size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    'Button Guide:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildButtonGuide(
                icon: Icons.add_circle_outline,
                label: 'Add Node',
                description: 'Inserts a new node into the tree.',
                backgroundColor: Colors.green[100]!,
                iconColor: Colors.green,
              ),
              _buildButtonGuide(
                icon: Icons.remove_circle_outline,
                label: 'Delete Node',
                description: 'Deletes a selected node from the tree.',
                backgroundColor: Colors.red[100]!,
                iconColor: Colors.red,
              ),
              _buildButtonGuide(
                icon: Icons.transform,
                label: 'Convert Tree',
                description: 'Finalizes the tree structure for operations.',
                backgroundColor: Colors.blue[100]!,
                iconColor: Colors.blue,
              ),
              _buildButtonGuide(
                icon: Icons.check_circle,
                label: 'Check Tree',
                description:
                    'Validates and highlights errors in the tree structure.',
                backgroundColor: Colors.orange[100]!,
                iconColor: Colors.orange,
              ),
              _buildButtonGuide(
                icon: Icons.sort,
                label: 'Sort Tree',
                description: 'Arranges nodes to meet BST rules.',
                backgroundColor: Colors.purple[100]!,
                iconColor: Colors.purple,
              ),
              _buildButtonGuide(
                icon: Icons.clear,
                label: 'Clear Tree',
                description: 'Resets the tree visualization.',
                backgroundColor: Colors.red[100]!,
                iconColor: Colors.red,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSteps(
      {required IconData icon,
      required String text,
      required Color iconColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

// Helper to build the button guide with colored background
  Widget _buildButtonGuide({
    required IconData icon,
    required String label,
    required String description,
    required Color backgroundColor,
    required Color iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _validateBST(TreeNode? node, int? min, int? max) {
    if (node == null) return true;

    bool isCorrect = true;
    if ((min != null && node.value <= min) ||
        (max != null && node.value >= max)) {
      node.isCorrectPosition = false;
      isCorrect = false;
    }

    return _validateBST(node.left, min, node.value) &
        _validateBST(node.right, node.value, max) &
        isCorrect;
  }

  void sortTree() async {
    if (_userNodeValues.isEmpty) return;

    // Initialize animation controller and scale animation with slower duration
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut),
    );

    // Clear child nodes of the root, keeping only the root
    TreeNode? currentNode = _root;
    if (currentNode != null) {
      setState(() {
        currentNode.left = null;
        currentNode.right = null;
      });
    }

    // Start from index 1 to avoid re-inserting the root node
    for (int i = 1; i < _userNodeValues.length; i++) {
      int currentValue = _userNodeValues[i];

      setState(() {
        _highlightedIndex = i;
        _root!.isMoving = true;
      });

      _animationController!.forward(from: 0.0);
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _insertIntoBST(_root!, currentValue);
        _root!.isMoving = false;
      });
    }

    // Dispose of the animation controller after sorting is complete
    _animationController?.dispose();
    _animationController = null;
    _scaleAnimation = null;

    setState(() {
      _highlightedIndex = null;
    });
  }

  void _insertIntoBST(TreeNode node, int value) {
    if (value < node.value) {
      if (node.left == null) {
        setState(() {
          node.left = TreeNode(value, node.index * 2 + 1)..isMoving = true;
          _controllers[node.left!.index] =
              TextEditingController(text: value.toString());
        });
      } else {
        _insertIntoBST(node.left!, value);
      }
    } else {
      if (node.right == null) {
        setState(() {
          node.right = TreeNode(value, node.index * 2 + 2)..isMoving = true;
          _controllers[node.right!.index] =
              TextEditingController(text: value.toString());
        });
      } else {
        _insertIntoBST(node.right!, value);
      }
    }
  }

  String _getNodeListAsString() {
    return _userNodeValues.join(', ');
  }

  Widget buildTree(TreeNode? node) {
    if (node == null) return const SizedBox();

    return Column(
      children: [
        AnimatedBuilder(
          animation: _animationController ?? kAlwaysCompleteAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: node.isMoving && _scaleAnimation != null
                  ? _scaleAnimation!.value
                  : 1.0,
              child: child,
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!_isConverted) ...[
                IconButton(
                  icon: Icon(
                    node.left == null
                        ? Icons.add_circle_outline
                        : Icons.remove_circle_outline,
                    color: node.left == null ? Colors.green : Colors.red,
                  ),
                  onPressed: () => node.left == null
                      ? addNode(node, 'left', Random().nextInt(100))
                      : deleteNode(node, 'left'),
                ),
              ],
              SizedBox(
                width: 60,
                child: TextField(
                  controller: _controllers[node.index],
                  onChanged: (value) => updateNodeValue(node, value),
                  enabled: !_isConverted,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    fillColor: Colors.green, // Green color for all nodes
                    filled: true,
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              if (!_isConverted) ...[
                IconButton(
                  icon: Icon(
                    node.right == null
                        ? Icons.add_circle_outline
                        : Icons.remove_circle_outline,
                    color: node.right == null ? Colors.green : Colors.red,
                  ),
                  onPressed: () => node.right == null
                      ? addNode(node, 'right', Random().nextInt(100))
                      : deleteNode(node, 'right'),
                ),
              ],
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: buildTree(node.left),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: buildTree(node.right),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Enable horizontal scrolling
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _userNodeValues.map((value) {
          bool isHighlighted = _highlightedIndex != null &&
              _userNodeValues[_highlightedIndex!] == value;

          return Stack(
            alignment: Alignment.topCenter,
            children: [
              AnimatedContainer(
                duration: const Duration(seconds: 1), // Slower duration
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: isHighlighted ? Colors.lightGreenAccent : Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  value.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              if (isHighlighted)
                Positioned(
                  top: -20, // Adjust arrow position
                  child: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.orange,
                    size: 30,
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  void updateNodeValue(TreeNode node, String newValue) {
    int? value = int.tryParse(newValue);
    if (value != null) {
      setState(() {
        int oldValueIndex = _userNodeValues.indexOf(node.value);
        if (oldValueIndex != -1) {
          _userNodeValues[oldValueIndex] = value;
        }
        node.value = value;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid integer value.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            _stopBackgroundMusic(); // Stop music when navigating back
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Binary Search Tree',
          style: TextStyle(color: Colors.black),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: _buildTabBar(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.black),
            onPressed: _showInstructions,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBinarySearchTab(),
                // _buildInstructionsTab(),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Node List:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: buildList(), // Call the updated buildList method
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
          ],
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, blurRadius: 2, offset: Offset(0, 2)),
            ],
          ),
          tabs: const [
            Tab(child: Text('Simulate', style: TextStyle(color: Colors.blue))),
          ],
        ),
      ),
    );
  }

  Widget _buildBinarySearchTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: _isConverted ? null : convertTree,
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(12),
                  backgroundColor: Colors.blue,
                ),
                child: const Icon(Icons.transform, color: Colors.white),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: (_isConverted && !_isChecked) ? checkTree : null,
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(12),
                  backgroundColor: Colors.green,
                ),
                child:
                    const Icon(Icons.check_circle_outline, color: Colors.white),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: (_isConverted && _isChecked) ? sortTree : null,
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(12),
                  backgroundColor: Colors.orange,
                ),
                child: const Icon(Icons.sort, color: Colors.white),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: clearTree,
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(12),
                  backgroundColor: Colors.red,
                ),
                child: const Icon(Icons.clear, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Binary Search Tree Visualization',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _isConverted
                ? Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: CustomPaint(
                          painter: TreePainter(_root, _isChecked),
                          child: Container(
                            constraints: BoxConstraints(
                              minWidth: 400,
                              minHeight:
                                  _calculateTreeHeight(), // Dynamically calculate height
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Center(
                          child: _root != null
                              ? buildTree(_root)
                              : const Text('No tree built yet.'),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  int _getTreeDepth(TreeNode? node) {
    if (node == null) return 0;
    return 1 + max(_getTreeDepth(node.left), _getTreeDepth(node.right));
  }

  double _calculateTreeHeight() {
    int depth = _getTreeDepth(_root);
    const double nodeHeight = 80; // Vertical spacing between levels
    const double padding = 50; // Padding for the top and bottom
    return depth * nodeHeight + padding; // Total height based on depth
  }

  // Widget _buildInstructionsTab() {
  //   return Padding(
  //     padding: const EdgeInsets.all(16.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: const [
  //         Text(
  //           'How to Use:',
  //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //         ),
  //         SizedBox(height: 8),
  //         Text(
  //           '1. Use the text boxes to edit node values directly.\n'
  //           '2. Click the + icons to add nodes.\n'
  //           '3. Click the - icons to delete nodes.\n'
  //           '4. Use the "Convert" button to lock in values and create the tree.\n'
  //           '5. Use "Check" to highlight incorrect nodes based on BST rules.\n'
  //           '6. Use "Sort" to organize the tree in order after checking.\n'
  //           '7. Use "Clear" to reset and start again.\n',
  //           style: TextStyle(fontSize: 14),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

class TreePainter extends CustomPainter {
  final TreeNode? root;
  final bool isChecked;

  TreePainter(this.root, this.isChecked);

  @override
  void paint(Canvas canvas, Size size) {
    if (root == null) return;

    final double radius = 20.0;
    final Paint paint = Paint()..style = PaintingStyle.fill;
    final Paint linePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;

    _drawNode(canvas, root, size.width / 2, 50, size.width / 4, radius, paint,
        linePaint);
  }

  void _drawNode(Canvas canvas, TreeNode? node, double x, double y,
      double xOffset, double radius, Paint paint, Paint linePaint) {
    if (node == null) return;

    if (node.left != null) {
      canvas.drawLine(Offset(x, y), Offset(x - xOffset, y + 80), linePaint);
      _drawNode(canvas, node.left, x - xOffset, y + 80, xOffset / 2, radius,
          paint, linePaint);
    }

    if (node.right != null) {
      canvas.drawLine(Offset(x, y), Offset(x + xOffset, y + 80), linePaint);
      _drawNode(canvas, node.right, x + xOffset, y + 80, xOffset / 2, radius,
          paint, linePaint);
    }

    paint.color = node.isMoving
        ? Colors.green
        : isChecked && node.isCorrectPosition
            ? Colors.green
            : isChecked && !node.isCorrectPosition
                ? Colors.red
                : Colors.green;

    canvas.drawCircle(Offset(x, y), radius, paint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: node.value.toString(),
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(x - textPainter.width / 2, y - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
