import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(MaterialApp(
    title: 'Radix Sort Visualization',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: RadixSortPage(),
  ));
}

class RadixSortPage extends StatefulWidget {
  @override
  _RadixSortPageState createState() => _RadixSortPageState();
}

class _RadixSortPageState extends State<RadixSortPage>
    with TickerProviderStateMixin {
  final TextEditingController inputController = TextEditingController();
  List<List<TextEditingController>> stepControllers = [];
  List<String> stepLabels = [];
  List<int> originalNumbers = [];
  bool canSort = false;
  bool isSorting = false;
  bool showInsertButton = false; // Control the visibility of the Insert button
  late TabController _tabController;
  Duration animationDelay = Duration(milliseconds: 600);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Listen to input changes to control the visibility of the Insert button
    inputController.addListener(() {
      setState(() {
        showInsertButton = inputController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    inputController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _insertit() {
    if (inputController.text.isEmpty) return;
    List<int> initialNumbers = inputController.text
        .split(',')
        .map((e) => int.tryParse(e.trim()) ?? 0)
        .toList();

    if (initialNumbers.isNotEmpty) {
      setState(() {
        originalNumbers = initialNumbers;
        stepControllers = [
          initialNumbers
              .map((num) => TextEditingController(text: num.toString()))
              .toList()
        ];
        stepLabels = ['Initial State'];
        canSort = true;
        inputController.clear();
        showInsertButton = false; // Hide the Insert button after insertion
      });
    }
  }

  void _clearSteps() {
    setState(() {
      stepControllers.clear();
      stepLabels.clear();
      originalNumbers.clear();
      canSort = false;
    });
  }

  void _generateRandomNumbers() {
    final random = Random();
    List<int> randomNumbers = List.generate(5, (_) => random.nextInt(100) + 1);
    inputController.text = randomNumbers.join(', ');
  }

  Future<void> _animateSortingSteps(
      List<List<int>> steps, List<String> labels) async {
    for (int i = 0; i < steps.length; i++) {
      setState(() {
        stepControllers.add(steps[i]
            .map((num) => TextEditingController(text: num.toString()))
            .toList());
        stepLabels.add(labels[i]);
      });
      await Future.delayed(animationDelay);
    }
    setState(() {
      isSorting = false;
    });
  }

  Future<void> _sort() async {
    if (!canSort || originalNumbers.isEmpty) return;

    setState(() {
      isSorting = true;
      // Clear previous steps before starting a new sort to avoid duplicates
      stepControllers.clear();
      stepLabels.clear();
    });

    List<int> numbers = List.from(originalNumbers);
    int maxDigits = _getMaxDigits(numbers);
    List<List<int>> steps = [];
    List<String> labels = [];

    // Add initial state only once
    steps.add(List.from(numbers));
    labels.add('Initial State');

    for (int digitPlace = 1; digitPlace <= maxDigits; digitPlace++) {
      String digitPlaceLabel = _getDigitPlaceName(digitPlace);
      List<List<int>> buckets = List.generate(10, (_) => []);

      // Place numbers into buckets based on the current digit
      for (int num in numbers) {
        int digit = (num ~/ pow(10, digitPlace - 1)) % 10;
        buckets[digit].add(num);
      }

      // Reassemble numbers from buckets and capture each step
      numbers.clear();
      int stepIndex = 1;
      for (var bucket in buckets) {
        for (var num in bucket) {
          numbers.add(num);
          steps.add(List.from(numbers));
          labels.add('Sorting by $digitPlaceLabel - Step $stepIndex');
          stepIndex++;
        }
      }
    }

    // Add final sorted state
    steps.add(List.from(numbers));
    labels.add('Final Sorted List');

    await _animateSortingSteps(steps, labels);
  }

  int _getMaxDigits(List<int> numbers) {
    return numbers.fold<int>(
        0, (maxDigits, num) => max(maxDigits, num.toString().length));
  }

  String _getDigitPlaceName(int digitPlace) {
    switch (digitPlace) {
      case 1:
        return 'Ones';
      case 2:
        return 'Tens';
      case 3:
        return 'Hundreds';
      case 4:
        return 'Thousands';
      default:
        return '${pow(10, digitPlace - 1)}s';
    }
  }

  Widget _buildStep(int index) {
    bool isFinalStep = (index == stepControllers.length - 1);
    String stepLabel = stepLabels[index];
    int digitPlace = _getCurrentDigitPlace(stepLabel);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              stepLabels[index],
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Text(
                  isFinalStep ? 'Sorted:' : 'Step ${index + 1}:',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: stepControllers[index].map((controller) {
                      return SizedBox(
                        width: 50,
                        child: _buildHighlightedDigit(
                            controller.text, digitPlace, isFinalStep),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Build the number display with highlighted digit
  Widget _buildHighlightedDigit(
      String numberText, int digitPlace, bool isFinalStep) {
    int number = int.tryParse(numberText) ?? 0;
    String numberString =
        number.toString().padLeft(digitPlace, '0'); // Pad for highlighting

    int highlightIndex =
        numberString.length - digitPlace; // Position of the current digit

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: List.generate(numberString.length, (i) {
          bool isHighlighted = i == highlightIndex && !isFinalStep;
          return TextSpan(
            text: numberString[i],
            style: TextStyle(
              fontSize: 16,
              color: isHighlighted ? Colors.blue : Colors.black,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
            ),
          );
        }),
      ),
    );
  }

  int _getCurrentDigitPlace(String label) {
    if (label.contains("Ones")) return 1;
    if (label.contains("Tens")) return 2;
    if (label.contains("Hundreds")) return 3;
    if (label.contains("Thousands")) return 4;
    return 1;
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
        title: const Text('Radix Sort Visualization',
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
            'Radix Sort Visualization:',
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
            '1. Enter numbers separated by commas and press Insert to add them.\n'
            '2. Use the random button to generate random numbers.\n'
            '3. Press play to start the radix sort visualization.\n'
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
            onPressed: _generateRandomNumbers,
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
        if (showInsertButton)
          ElevatedButton(
            onPressed: isSorting ? null : _insertit,
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(12),
              backgroundColor: Colors.green,
            ),
            child: const Icon(Icons.check, color: Colors.white),
          ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: canSort && !isSorting ? _sort : null,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(12),
            backgroundColor: Colors.blue,
          ),
          child: const Icon(Icons.play_arrow, color: Colors.white),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _clearSteps,
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
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListView.builder(
          itemCount: stepControllers.length,
          itemBuilder: (context, index) => _buildStep(index),
        ),
      ),
    );
  }
}
