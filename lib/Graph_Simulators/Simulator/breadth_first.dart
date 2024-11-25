import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: BreadthFirstPage()));
}

class BreadthFirstPage extends StatefulWidget {
  const BreadthFirstPage({Key? key}) : super(key: key);

  @override
  _BreadthFirstPageState createState() => _BreadthFirstPageState();
}

class TreeNode {
  int value;
  TreeNode? left;
  TreeNode? right;
  int index;

  TreeNode(this.value, this.index);
}

class _BreadthFirstPageState extends State<BreadthFirstPage>
    with TickerProviderStateMixin {
  TreeNode? _root;
  final Map<int, TextEditingController> _controllers = {};
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isConverted = false;
  List<int> _userNodeValues = [];
  List<int> _bfsTraversal = [];
  Set<int> _highlightedNodes = {};
  int? _highlightedIndex;
  final Map<int, List<int?>> _userTreeStructure =
      {}; // Store user-defined structure

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
    _userTreeStructure[0] = [null, null]; // Initialize root with no children
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
        _userTreeStructure[parentNode.index]![0] = newIndex; // Track left child
      } else if (position == "right" && parentNode.right == null) {
        parentNode.right = newNode;
        _userTreeStructure[parentNode.index]![1] =
            newIndex; // Track right child
      }
      _userTreeStructure[newIndex] = [
        null,
        null
      ]; // Initialize new node children
      _userNodeValues.add(value);
    });
  }

  void deleteNode(TreeNode parentNode, String position) {
    setState(() {
      if (position == "left" && parentNode.left != null) {
        _removeSubtree(parentNode.left!);
        parentNode.left = null;
        _userTreeStructure[parentNode.index]![0] =
            null; // Remove left child reference
      } else if (position == "right" && parentNode.right != null) {
        _removeSubtree(parentNode.right!);
        parentNode.right = null;
        _userTreeStructure[parentNode.index]![1] =
            null; // Remove right child reference
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
    _userTreeStructure.remove(node.index);
  }

  void clearTree() {
    setState(() {
      _controllers.clear();
      _initializeRootNode();
      _isConverted = false;
      _userNodeValues = [_root!.value];
      _bfsTraversal.clear();
      _highlightedNodes.clear();
      _highlightedIndex = null;
    });
  }

  void convertTree() {
    if (_root == null) return;

    setState(() {
      _isConverted = true;
    });

    // Lock in node values based on user-defined structure
    Queue<TreeNode> queue = Queue<TreeNode>();
    queue.add(_root!);

    while (queue.isNotEmpty) {
      TreeNode node = queue.removeFirst();
      _controllers[node.index]?.text = node.value.toString();

      if (node.left != null) {
        queue.add(node.left!);
      }
      if (node.right != null) {
        queue.add(node.right!);
      }
    }
  }

  void breadthFirstTraversal() async {
    _bfsTraversal.clear();
    _highlightedNodes.clear();
    if (_root == null) return;

    Queue<TreeNode> queue = Queue<TreeNode>();
    queue.add(_root!);

    while (queue.isNotEmpty) {
      TreeNode node = queue.removeFirst();
      _bfsTraversal.add(node.value);

      setState(() {
        _highlightedNodes.add(node.index);
        _highlightedIndex = _userNodeValues.indexOf(node.value);
      });

      _animationController.forward(from: 0.0);
      await Future.delayed(const Duration(milliseconds: 600));

      setState(() {
        _highlightedNodes.remove(node.index);
      });

      if (node.left != null) queue.add(node.left!);
      if (node.right != null) queue.add(node.right!);
    }

    setState(() {
      _highlightedIndex = null;
    });
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

  Widget buildBfsList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _bfsTraversal.map((value) {
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
        title: const Text('Breadth First Search',
            style: TextStyle(color: Colors.black)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: _buildTabBar(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBinarySearchTab(),
                _buildInstructionsTab(),
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
          if (_bfsTraversal.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: buildBfsList(),
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
            Tab(
                child:
                    Text('Instructions', style: TextStyle(color: Colors.grey))),
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
                onPressed: _isConverted ? breadthFirstTraversal : null,
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
              'Breadth First Search Visualization',
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

  Widget _buildInstructionsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'How to Use:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            '1. Use the text boxes to edit node values directly.\n'
            '2. Click the + icons to add nodes.\n'
            '3. Click the - icons to delete nodes.\n'
            '4. Use the "Convert" button to lock in values and create the tree.\n'
            '5. Use "BFS Traversal" to perform a breadth-first traversal.\n'
            '6. Use "Clear" to reset and start again.\n',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
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
