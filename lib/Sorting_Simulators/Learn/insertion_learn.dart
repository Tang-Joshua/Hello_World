import 'package:flutter/material.dart';

class InsertionSortLearnPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.green[50],
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Learn About Insertion Sort'),
          backgroundColor: Colors.green,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Header
                Text(
                  'What is Insertion Sort?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[900],
                  ),
                ),
                SizedBox(height: 12),
                ExpandableCard(
                  title: 'Definition',
                  content:
                      'Insertion Sort is a simple sorting algorithm that builds the final sorted array one element at a time. '
                      'It compares each new element to the already sorted elements and places it in the correct position.',
                ),
                ExpandableCard(
                  title: 'Key Properties',
                  content:
                      '- **Time Complexity:** Best case O(n) (when the array is already sorted), Worst case O(n²).\n'
                      '- **Space Complexity:** O(1), as it sorts the array in place.\n'
                      '- **Stable Sort:** Maintains the relative order of equal elements.',
                ),
                ExpandableCard(
                  title: 'Algorithm Steps',
                  content:
                      '1. Start with the second element of the array (assuming the first element is already sorted).\n'
                      '2. Compare the current element with the previous elements.\n'
                      '3. Shift the previous elements to the right until the correct position for the current element is found.\n'
                      '4. Insert the current element at its correct position.\n'
                      '5. Repeat the process for all remaining elements in the array.',
                ),
                SizedBox(height: 24),
                // History Section
                Text(
                  'History of Insertion Sort',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[900],
                  ),
                ),
                SizedBox(height: 12),
                ExpandableCard(
                  title: 'Origins',
                  content:
                      'Insertion Sort has been known and used for centuries as a natural way of sorting things by hand. '
                      'It is often taught as an introduction to sorting algorithms due to its simplicity and intuitiveness.',
                ),
                ExpandableCard(
                  title: 'Significance',
                  content:
                      'Despite its inefficiency for large datasets, Insertion Sort is very effective for small or nearly sorted arrays due to its low overhead.',
                ),
                SizedBox(height: 24),
                // Applications Section
                Text(
                  'Applications of Insertion Sort',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[900],
                  ),
                ),
                SizedBox(height: 12),
                ExpandableCard(
                  title: 'Common Use Cases',
                  content:
                      '- **Small Datasets:** Used for sorting small arrays due to its simplicity.\n'
                      '- **Nearly Sorted Arrays:** Performs efficiently when the array is almost sorted.\n'
                      '- **Educational Purposes:** Ideal for teaching basic sorting concepts due to its straightforward implementation.',
                ),
                ExpandableCard(
                  title: 'Advanced Applications',
                  content:
                      '- **Hybrid Sorting Algorithms:** Used as a subroutine in more complex algorithms like Timsort for sorting small chunks.\n'
                      '- **Real-Time Systems:** Suitable for applications where simplicity and low memory usage are crucial.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ExpandableCard extends StatefulWidget {
  final String title;
  final String content;

  const ExpandableCard({required this.title, required this.content});

  @override
  _ExpandableCardState createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green[100], // Matches the design
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[900],
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.green[900],
                  ),
                ],
              ),
              if (_isExpanded) ...[
                SizedBox(height: 8),
                Text(
                  widget.content,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green[800],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(InsertionSortLearnPage());
}
