import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: DepthFirstPage()));
}

class DepthFirstPage extends StatefulWidget {
  const DepthFirstPage({Key? key}) : super(key: key);

  @override
  _DepthFirstPageState createState() => _DepthFirstPageState();
}

class TreeNode {
  int value;
  TreeNode? left;
  TreeNode? right;
  int index;

  TreeNode(this.value, this.index);
}

class _DepthFirstPageState extends State<DepthFirstPage>
    with TickerProviderStateMixin {
  TreeNode? _root;
  final Map<int, TextEditingController> _controllers = {};
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isConverted = false;
  List<int> _userNodeValues = [];
  List<int> _dfsTraversal = [];
  Set<int> _highlightedNodes = {};
  int? _highlightedIndex;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeRootNode();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showInstructions();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
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
      _userNodeValues = [_root!.value];
      _dfsTraversal.clear();
      _highlightedNodes.clear();
      _highlightedIndex = null;
    });
  }

  void convertTree() {
    setState(() {
      _isConverted = true;
    });
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
            color: Colors.purpleAccent,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Title
              Row(
                children: [
                  Icon(Icons.info, color: Colors.purple, size: 24),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'How to Use Depth-First Search Visualization:',
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
                text: 'Add Node: Use the "+" button to insert new nodes.',
                iconColor: Colors.blue,
              ),
              _buildSteps(
                icon: Icons.remove_circle_outline,
                text: 'Delete Node: Use the "-" button to remove nodes.',
                iconColor: Colors.red,
              ),
              _buildSteps(
                icon: Icons.transform,
                text: 'Convert Tree: Finalize the tree structure before DFS.',
                iconColor: Colors.green,
              ),
              _buildSteps(
                icon: Icons.trending_flat,
                text:
                    'Perform DFS: Click the "Play" button to visualize the traversal.',
                iconColor: Colors.purple,
              ),
              _buildSteps(
                icon: Icons.clear,
                text:
                    'Clear Tree: Resets the tree visualization for a fresh start.',
                iconColor: Colors.red,
              ),
              const SizedBox(height: 16),

              // Button Guide
              Row(
                children: [
                  Icon(Icons.help_outline, color: Colors.purple, size: 24),
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
                description: 'Inserts a node into the tree.',
                backgroundColor: Colors.blue[100]!,
                iconColor: Colors.blue,
              ),
              _buildButtonGuide(
                icon: Icons.remove_circle_outline,
                label: 'Delete Node',
                description: 'Removes a selected node from the tree.',
                backgroundColor: Colors.red[100]!,
                iconColor: Colors.red,
              ),
              _buildButtonGuide(
                icon: Icons.transform,
                label: 'Convert Tree',
                description: 'Locks the structure for DFS traversal.',
                backgroundColor: Colors.green[100]!,
                iconColor: Colors.green,
              ),
              _buildButtonGuide(
                icon: Icons.trending_flat,
                label: 'Perform DFS',
                description: 'Executes Depth-First Search traversal.',
                backgroundColor: Colors.purple[100]!,
                iconColor: Colors.purple,
              ),
              _buildButtonGuide(
                icon: Icons.clear,
                label: 'Clear Tree',
                description: 'Clears the visualization.',
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
              style: TextStyle(color: Colors.purpleAccent),
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

  void depthFirstTraversal() async {
    _dfsTraversal.clear();
    _highlightedNodes.clear();
    _highlightedIndex = null;
    if (_root == null) return;

    await _dfsAnimate(_root);
    setState(() {
      _highlightedIndex = null;
    });
  }

  Future<void> _dfsAnimate(TreeNode? node) async {
    if (node == null) return;

    setState(() {
      _highlightedNodes.add(node.index);
      _highlightedIndex = _userNodeValues.indexOf(node.value);
    });

    _animationController.forward(from: 0.0);
    await Future.delayed(const Duration(milliseconds: 600));

    _dfsTraversal.add(node.value);

    setState(() {
      _highlightedNodes.remove(node.index);
    });

    await _dfsAnimate(node.left);
    await _dfsAnimate(node.right);
  }

  String _getNodeListAsString() {
    return _userNodeValues.join(', ');
  }

  Widget buildTree(TreeNode? node) {
    if (node == null) return const SizedBox();

    return Column(
      children: [
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _highlightedNodes.contains(node.index) ||
                      (_highlightedIndex != null &&
                          _userNodeValues[_highlightedIndex!] == node.value)
                  ? _scaleAnimation.value
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
                  enabled: !_isConverted,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    fillColor: _highlightedNodes.contains(node.index) ||
                            (_highlightedIndex != null &&
                                _userNodeValues[_highlightedIndex!] ==
                                    node.value)
                        ? Colors.lightGreen
                        : Colors.white,
                    filled: true,
                  ),
                  textAlign: TextAlign.center,
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

  Widget buildDfsList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _dfsTraversal.map((value) {
        bool isHighlighted = _highlightedIndex != null &&
            _userNodeValues[_highlightedIndex!] == value;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 600),
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
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text('Depth First Search',
            style: TextStyle(color: Colors.black)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: _buildTabBar(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.black),
            onPressed:
                _showInstructions, // Call the method to show instructions
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Node List: ${_getNodeListAsString()}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          if (_dfsTraversal.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: buildDfsList(),
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
                onPressed: _isConverted ? depthFirstTraversal : null,
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(12),
                  backgroundColor: Colors.purple,
                ),
                child: const Icon(Icons.trending_flat, color: Colors.white),
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
              'Depth First Search Visualization',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _isConverted
                ? CustomPaint(
                    painter: TreePainter(_root, _highlightedNodes),
                    child: Container(),
                  )
                : Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(2, 2)),
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
  //           '5. Use "DFS Traversal" to perform a depth-first traversal.\n'
  //           '6. Use "Clear" to reset and start again.\n',
  //           style: TextStyle(fontSize: 14),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

class TreePainter extends CustomPainter {
  final TreeNode? root;
  final Set<int> highlightedNodes;

  TreePainter(this.root, this.highlightedNodes);

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

    paint.color =
        highlightedNodes.contains(node.index) ? Colors.lightGreen : Colors.blue;
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
