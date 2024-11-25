import 'dart:math';
import 'package:flutter/material.dart';

class MergeSortPage extends StatefulWidget {
  const MergeSortPage({Key? key}) : super(key: key);

  @override
  State<MergeSortPage> createState() => _MergeSortPageState();
}

class _MergeSortPageState extends State<MergeSortPage>
    with TickerProviderStateMixin {
  List<int> stack = [];
  final TextEditingController inputController = TextEditingController();
  bool isSorting = false;
  late ScrollController _scrollController;
  late TabController _tabController;

  bool isInsertClicked = false; // To track if insert/check button was clicked

  List<Map<String, dynamic>> topVisualizationSteps = [];
  List<Map<String, dynamic>> leftVisualizationSteps = [];
  List<Map<String, dynamic>> rightVisualizationSteps = [];
  List<Map<String, dynamic>> finalMergeStep = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _tabController = TabController(length: 2, vsync: this);

    inputController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    inputController.dispose();
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> sort() async {
    setState(() {
      isSorting = true;
      topVisualizationSteps.clear();
      leftVisualizationSteps.clear();
      rightVisualizationSteps.clear();
      finalMergeStep.clear();
    });

    List<int> initialList = List.from(stack);
    _addStep(topVisualizationSteps, [initialList], label: "Initial List");

    int mid = (initialList.length + 1) ~/ 2;
    List<int> leftArray = initialList.sublist(0, mid);
    List<int> rightArray = initialList.sublist(mid);

    _addStep(topVisualizationSteps, [leftArray, rightArray],
        label: "Initial Split");
    await Future.delayed(const Duration(milliseconds: 600));

    leftArray = await _mergeSortWithVisualization(
        leftArray, "Left Array", 1, leftVisualizationSteps);
    rightArray = await _mergeSortWithVisualization(
        rightArray, "Right Array", 1, rightVisualizationSteps);

    List<int> sortedArray = _merge(leftArray, rightArray);
    _addStep(finalMergeStep, [sortedArray], label: "Final Merged Array");

    setState(() {
      isSorting = false;
    });
  }

  Future<List<int>> _mergeSortWithVisualization(List<int> arr, String label,
      int level, List<Map<String, dynamic>> steps) async {
    if (arr.length <= 1) {
      return arr;
    }

    int mid = (arr.length + 1) ~/ 2;
    List<int> left = arr.sublist(0, mid);
    List<int> right = arr.sublist(mid);

    _addStep(steps, [left, right], label: "$label Split", level: level);
    await Future.delayed(const Duration(milliseconds: 600));

    left = await _mergeSortWithVisualization(left, label, level + 1, steps);
    right = await _mergeSortWithVisualization(right, label, level + 1, steps);

    List<int> merged = _merge(left, right);
    _addStep(steps, [merged], label: "$label Merge", level: level);
    await Future.delayed(const Duration(milliseconds: 600));

    return merged;
  }

  List<int> _merge(List<int> left, List<int> right) {
    List<int> result = [];
    int i = 0, j = 0;

    while (i < left.length && j < right.length) {
      if (left[i] <= right[j]) {
        result.add(left[i++]);
      } else {
        result.add(right[j++]);
      }
    }

    while (i < left.length) result.add(left[i++]);
    while (j < right.length) result.add(right[j++]);

    return result;
  }

  void _addStep(List<Map<String, dynamic>> steps, List<List<int>> groups,
      {String? label, int level = 0}) {
    List<List<int>> filteredGroups =
        groups.where((group) => group.isNotEmpty).toList();
    if (filteredGroups.isNotEmpty) {
      steps.add({
        'label': label,
        'groups': filteredGroups,
        'level': level,
      });
      setState(() {});
    }
  }

  void insertNumbers() {
    List<String> inputNumbers = inputController.text.split(',');
    stack.clear();
    for (String numStr in inputNumbers) {
      int? number = int.tryParse(numStr.trim());
      if (number != null) {
        stack.add(number);
      }
    }
    inputController.clear();

    setState(() {
      isInsertClicked = true;
    });
  }

  void generateRandomNumbers() {
    final random = Random();
    List<int> randomNumbers = List.generate(5, (_) => random.nextInt(100) + 1);
    inputController.text = randomNumbers.join(', ');
  }

  void clearVisualization() {
    setState(() {
      stack.clear();
      inputController.clear();
      topVisualizationSteps.clear();
      leftVisualizationSteps.clear();
      rightVisualizationSteps.clear();
      finalMergeStep.clear();
      isSorting = false;
      isInsertClicked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back
          },
        ),
        title: const Text('Merge Sort Visualization',
            style: TextStyle(color: Colors.black)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: _buildTabBar(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildVisualizationTab(),
          _buildInstructionsTab(),
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

  Widget _buildVisualizationTab() {
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
            'Merge Sort Visualization:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildVisualizationContainer(),
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
            'Instructions:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            '1. Enter numbers separated by commas and press the check button.\n'
            '2. Use the random button to generate random numbers.\n'
            '3. Press play to start the merge sort visualization.\n'
            '4. Use the clear button to reset the visualization.\n',
            style: TextStyle(fontSize: 14),
          ),
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
          ElevatedButton(
            onPressed: insertNumbers,
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(12),
              backgroundColor: Colors.green,
            ),
            child: const Icon(Icons.check, color: Colors.white),
          ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: isInsertClicked && stack.isNotEmpty ? sort : null,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(12),
            backgroundColor: Colors.blue,
          ),
          child: const Icon(Icons.play_arrow, color: Colors.white),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: clearVisualization,
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

  Widget _buildVisualizationContainer() {
    return Expanded(
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            _buildContainerWithTitle("Initial Split", topVisualizationSteps),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: _buildContainerWithTitle(
                        "Left Array Steps", leftVisualizationSteps)),
                const SizedBox(width: 16),
                Expanded(
                    child: _buildContainerWithTitle(
                        "Right Array Steps", rightVisualizationSteps)),
              ],
            ),
            const SizedBox(height: 16),
            _buildContainerWithTitle("Final Merge", finalMergeStep),
          ],
        ),
      ),
    );
  }

  Widget _buildContainerWithTitle(
      String title, List<Map<String, dynamic>> steps) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Column(
            children: steps
                .map((step) =>
                    _buildStepWithLabel(step['groups'], step['label']))
                .toList(),
          ),
        ],
      ),
    );
  }

  // Updated Step Widget to Place Label on Top and Center the Grouped Values
  Widget _buildStepWithLabel(List<List<int>> groups, String? label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: groups.map(_buildGroupBox).toList(),
        ),
        const SizedBox(height: 8), // Add spacing between steps
      ],
    );
  }

  Widget _buildGroupBox(List<int> group) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blueAccent),
      ),
      child: Text(
        group.join(', '),
        style: const TextStyle(fontSize: 18, color: Colors.black),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: MergeSortPage(),
  ));
}
