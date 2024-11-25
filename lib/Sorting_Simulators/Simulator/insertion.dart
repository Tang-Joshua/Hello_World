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
    List<String> inputNumbers = inputController.text.split(',');
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
              labelText: 'Enter numbers (comma-separated)',
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
          _buildIconButton(Icons.check, Colors.green, insertNumbers),
        const SizedBox(width: 8),
        _buildIconButton(
          Icons.play_arrow,
          isSortEnabled ? Colors.blue : Colors.grey,
          isSortEnabled ? sort : null,
        ),
        const SizedBox(width: 8),
        _buildIconButton(Icons.refresh, Colors.red, () {
          setState(() {
            stack.clear();
            inputController.clear();
            isSortEnabled = false;
          });
        }),
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
