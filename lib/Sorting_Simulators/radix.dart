import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(MaterialApp(
    title: 'Radix Sort Visualization',
    theme: ThemeData(
      primarySwatch: Colors.green,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: RadixSortPage(),
  ));
}

class RadixSortPage extends StatefulWidget {
  @override
  _RadixSortPageState createState() => _RadixSortPageState();
}

class _RadixSortPageState extends State<RadixSortPage> {
  final TextEditingController inputController = TextEditingController();
  List<List<TextEditingController>> stepControllers =
      []; // List to store history of each step
  List<String> stepLabels =
      []; // List to store the label for each step (ones, tens, etc.)
  List<int> originalNumbers = []; // Store the original list of numbers
  bool canSort = false;
  bool isSorting = false;
  Duration animationDelay = Duration(seconds: 1); // Control animation speed

  void _insertit() {
    if (inputController.text.isEmpty) return;

    // Parse input into a list of integers
    List<int> initialNumbers = inputController.text
        .split(',')
        .map((e) => int.tryParse(e.trim()) ?? 0)
        .toList();

    if (initialNumbers.isNotEmpty) {
      setState(() {
        originalNumbers = initialNumbers; // Store original numbers
        stepControllers = [
          initialNumbers
              .map((num) => TextEditingController(text: num.toString()))
              .toList()
        ];
        stepLabels = [
          'Initial State'
        ]; // Initialize the first label as "Initial State"
        canSort = true;
        inputController.clear();
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

  Future<void> _animateSortingSteps(
      List<List<int>> steps, List<String> labels) async {
    for (int i = 0; i < steps.length; i++) {
      setState(() {
        // Append each step and its label to the history of steps
        stepControllers.add(steps[i]
            .map((num) => TextEditingController(text: num.toString()))
            .toList());
        stepLabels.add(labels[i]);
      });
      await Future.delayed(animationDelay);
    }
    setState(() {
      isSorting = false; // End sorting animation
    });
  }

  Future<void> _sort() async {
    if (!canSort || originalNumbers.isEmpty)
      return; // Prevent sorting if no numbers are inserted

    setState(() {
      isSorting = true;
    });

    List<int> numbers = List.from(originalNumbers); // Copy of original numbers
    int maxDigits = _getMaxDigits(numbers);
    List<List<int>> steps = []; // Store every step for animation
    List<String> labels = []; // Store label for each step

    // Perform radix sort by each digit place (ones, tens, hundreds, etc.)
    for (int digitPlace = 1; digitPlace <= maxDigits; digitPlace++) {
      String digitPlaceLabel = _getDigitPlaceName(digitPlace);

      // Place numbers into buckets based on the current digit
      List<List<int>> buckets = List.generate(10, (_) => []);
      for (int num in numbers) {
        int digit = (num ~/ pow(10, digitPlace - 1)) % 10;
        buckets[digit].add(num);

        // Capture the state after placing each number into a bucket
        List<int> snapshot = buckets.expand((bucket) => bucket).toList();
        steps.add(snapshot); // Add the current state to steps
        labels.add('Placing by $digitPlaceLabel'); // Label for placing phase
      }

      // Reassemble numbers from buckets and capture each step for visualization
      numbers.clear();
      for (var bucket in buckets) {
        numbers.addAll(bucket);

        // Capture the state after retrieving numbers from each bucket
        steps.add(List.from(numbers));
        labels.add(
            'Reassembling by $digitPlaceLabel'); // Label for reassembling phase
      }
    }

    // Animate through all captured steps to show the sorting process
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
                        child: TextFormField(
                          controller: controller,
                          textAlign: TextAlign.center,
                          readOnly: true,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: isFinalStep ? Colors.green : Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Radix Sort Visualization')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: inputController,
              decoration: InputDecoration(
                labelText: 'Enter numbers (comma-separated)',
                border: OutlineInputBorder(),
              ),
              enabled: !isSorting,
            ),
            SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                ElevatedButton(
                  onPressed: isSorting ? null : _insertit,
                  child: Text('Insert'),
                ),
                ElevatedButton(
                  onPressed: isSorting ? null : _clearSteps,
                  child: Text('Clear Steps'),
                ),
                ElevatedButton(
                  onPressed: canSort && !isSorting ? _sort : null,
                  child: Text('Sort'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: stepControllers.length,
                itemBuilder: (context, index) => _buildStep(index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
