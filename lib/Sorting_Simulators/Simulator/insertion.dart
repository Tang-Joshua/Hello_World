import 'dart:math';
import 'package:flutter/material.dart';

class InsertionSortPage extends StatefulWidget {
  const InsertionSortPage({Key? key}) : super(key: key);

  @override
  State<InsertionSortPage> createState() => _InsertionSortPageState();
}

class _InsertionSortPageState extends State<InsertionSortPage>
    with SingleTickerProviderStateMixin {
  List<int> stack = [];
  final TextEditingController inputController = TextEditingController();
  late TabController _tabController;
  late ScrollController _scrollController; // For controlling the scroll.
  int currentIndex = -1;
  int movingIndex = -1;
  bool isSorting = false;
  bool isSortEnabled = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController(); // Initialize ScrollController.

    inputController.addListener(() {
      setState(() {}); // Rebuild the UI whenever input changes.
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showInstructions();
    });
  }

  @override
  void dispose() {
    inputController.dispose();
    _tabController.dispose();
    _scrollController.dispose(); // Dispose the ScrollController.
    super.dispose();
  }

  /// Smooth Insertion Sort with centered scrolling.
  Future<void> sort() async {
    setState(() => isSorting = true); // Mark sorting as active.

    for (int i = 0; i < stack.length; i++) {
      int key = stack[i]; // The element to be inserted.
      int j = i - 1;

      // Highlight the current element in red.
      setState(() => currentIndex = i);
      await Future.delayed(const Duration(milliseconds: 1200));
      _scrollToIndex(i); // Scroll to center the red-highlighted element.

      bool swapped = false;

      // Move the element while highlighting it in green.
      while (j >= 0 && stack[j] > key) {
        setState(() {
          stack[j + 1] = stack[j];
          stack[j] = key;
          movingIndex = j; // Highlight the moving element.
        });

        await Future.delayed(const Duration(milliseconds: 1500));
        _scrollToIndex(j); // Scroll to center the green-highlighted element.
        swapped = true;
        j--;
      }

      setState(() {
        movingIndex = -1; // Reset moving element.
        currentIndex = -1; // Reset current index.
      });

      // Restart if a swap occurred.
      if (swapped) {
        i = -1; // Restart from the beginning.
        await Future.delayed(const Duration(milliseconds: 1000));
      }
    }

    setState(() => isSorting = false); // Mark sorting as complete.
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
            color: Colors.orangeAccent,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Title
              Row(
                children: [
                  Icon(Icons.info, color: Colors.orange, size: 24),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'How to Use Insertion Sort Visualization:',
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
                icon: Icons.casino,
                text:
                    'Randomize Input: Click the dice icon to generate random numbers.',
                iconColor: Colors.purple,
              ),
              _buildSteps(
                icon: Icons.check_circle,
                text:
                    'Enter Input: Type numbers separated by commas (e.g., "10, 20") and click the check button to add them.',
                iconColor: Colors.green,
              ),
              _buildSteps(
                icon: Icons.play_arrow,
                text:
                    'Start Sorting: Click the play button to begin the Insertion Sort visualization.',
                iconColor: Colors.orange,
              ),
              _buildSteps(
                icon: Icons.refresh,
                text:
                    'Clear Visualization: Resets the visualization after sorting is complete.',
                iconColor: Colors.red,
              ),
              const SizedBox(height: 16),

              // Button Guide
              Row(
                children: [
                  Icon(Icons.help_outline, color: Colors.orange, size: 24),
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
                icon: Icons.casino,
                label: 'Randomize Input',
                description: 'Generates random numbers to use as input.',
                backgroundColor: Colors.purple[100]!,
                iconColor: Colors.purple,
              ),
              _buildButtonGuide(
                icon: Icons.check_circle,
                label: 'Insert Input',
                description: 'Adds your entered numbers to the visualization.',
                backgroundColor: Colors.green[100]!,
                iconColor: Colors.green,
              ),
              _buildButtonGuide(
                icon: Icons.play_arrow,
                label: 'Start Sorting',
                description: 'Begins the Insertion Sort visualization.',
                backgroundColor: Colors.orange[100]!,
                iconColor: Colors.orange,
              ),
              _buildButtonGuide(
                icon: Icons.refresh,
                label: 'Clear Visualization',
                description: 'Resets the sorting process and clears the steps.',
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
              style: TextStyle(color: Colors.orangeAccent),
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

  /// Scrolls the highlighted element to the center.
  void _scrollToIndex(int index) {
    final position =
        (index * 80.0) - (MediaQuery.of(context).size.width / 2 - 40);
    _scrollController.animateTo(
      position,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void insertNumbers() {
    List<String> inputNumbers = inputController.text.split(RegExp(r'[,\s]+'));
    for (String numStr in inputNumbers) {
      int? number = int.tryParse(numStr.trim());
      if (number != null) {
        setState(() => stack.add(number));
      }
    }
    inputController.clear(); // Clear input after insertion.
    setState(() => isSortEnabled = true); // Enable sort button.
  }

  void generateRandomNumbers() {
    final random = Random();
    int count = random.nextInt(3) + 3; // Generate 3 to 5 numbers.
    List<int> randomNumbers =
        List.generate(count, (_) => random.nextInt(10) + 1);
    inputController.text = randomNumbers.join(', ');
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
        title:
            const Text('Insertion Sort', style: TextStyle(color: Colors.black)),
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
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSimulateTab(),
          const Center(
            child: Text('Instructions are under construction.',
                style: TextStyle(fontSize: 18, color: Colors.grey)),
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
                child: Text('I\'ll Take a Shot',
                    style: TextStyle(color: Colors.grey))),
          ],
        ),
      ),
    );
  }

  Widget _buildSimulateTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildInputRow(),
          const SizedBox(height: 16),
          _buildActionButtonsRow(),
          const SizedBox(height: 16),
          const Text(
            'Insertion Sort Visualization:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildVisualizationContainer(),
        ],
      ),
    );
  }

  Widget _buildInputRow() {
    return Row(
      children: [
        SizedBox(
          height: 40,
          width: 40,
          child: ElevatedButton(
            onPressed: generateRandomNumbers,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(8),
              backgroundColor: Colors.blue,
              shape: const CircleBorder(),
            ),
            child: const Icon(Icons.casino, color: Colors.white),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: inputController,
            decoration: const InputDecoration(
              labelText: 'Enter numbers (comma or space-separated only)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtonsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (inputController.text.isNotEmpty)
          ElevatedButton(
            onPressed:
                !isSorting ? insertNumbers : null, // Disable while sorting
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(12),
              backgroundColor: Colors.green,
            ),
            child: const Icon(Icons.check, color: Colors.white),
          ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: !isSorting && isSortEnabled
              ? sort
              : null, // Disable sort button while sorting
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(12),
            backgroundColor: Colors.blue,
          ),
          child: const Icon(Icons.play_arrow, color: Colors.white),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: !isSorting
              ? () {
                  setState(() {
                    stack.clear();
                    inputController.clear();
                    isSortEnabled = false;
                  });
                }
              : null, // Disable clear button while sorting
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(12),
            backgroundColor: Colors.red,
          ),
          child: const Icon(Icons.refresh, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, Color color, VoidCallback? onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(12),
        backgroundColor: color,
      ),
      child: Icon(icon, color: Colors.white),
    );
  }

  Widget _buildVisualizationContainer() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey, width: 2), // Add border here.
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: stack
                .asMap()
                .entries
                .map((entry) => _buildAnimatedElement(entry.key, entry.value))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedElement(int index, int value) {
    bool isHighlighted = index == movingIndex;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 700),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: isHighlighted ? 70 : 50,
      width: isHighlighted ? 70 : 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _getColorForIndex(index),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(value.toString(),
          style: const TextStyle(fontSize: 20, color: Colors.white)),
    );
  }

  Color _getColorForIndex(int index) {
    if (isSorting && index == currentIndex) return Colors.red;
    if (isSorting && index == movingIndex) return Colors.green;
    return Colors.lightBlue;
  }
}

void main() {
  runApp(const MaterialApp(home: InsertionSortPage()));
}
