import 'package:flutter/material.dart';

class MergeSortLearnPage extends StatelessWidget {
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
          title: Text('Learn About Merge Sort'),
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
                  'What is Merge Sort?',
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
                      'Merge Sort is a divide-and-conquer algorithm that splits an array into smaller subarrays, '
                      'sorts the subarrays, and then merges them back together to form a sorted array.',
                ),
                ExpandableCard(
                  title: 'Key Properties',
                  content:
                      '- **Stable Sort:** Maintains the relative order of elements with equal keys.\n'
                      '- **Time Complexity:** O(n log n) in all cases (best, worst, average).\n'
                      '- **Space Complexity:** Requires extra space for merging.',
                ),
                ExpandableCard(
                  title: 'Algorithm Steps',
                  content:
                      '1. Divide the array into two halves.\n'
                      '2. Recursively sort each half using Merge Sort.\n'
                      '3. Merge the two sorted halves back together into one sorted array.\n'
                      '4. Repeat until the entire array is sorted.',
                ),
                SizedBox(height: 24),
                // History Section
                Text(
                  'History of Merge Sort',
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
                      'Merge Sort was developed by John von Neumann in 1945. '
                      'It was one of the first sorting algorithms to be developed, and it laid the groundwork for many modern algorithms.',
                ),
                ExpandableCard(
                  title: 'Significance',
                  content:
                      'Merge Sort is especially useful for sorting large datasets or linked lists due to its stability and predictable time complexity.',
                ),
                SizedBox(height: 24),
                // Applications Section
                Text(
                  'Applications of Merge Sort',
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
                      '- **Sorting Large Datasets:** Ideal for datasets too large to fit in memory.\n'
                      '- **Linked Lists:** Works efficiently due to its non-contiguous nature.\n'
                      '- **External Sorting:** Used in scenarios where data resides on external storage devices like hard disks.',
                ),
                ExpandableCard(
                  title: 'Advanced Applications',
                  content:
                      '- **Multithreading:** Merge Sort can be implemented with multiple threads for parallel processing.\n'
                      '- **Data Analysis:** Used in processing large amounts of structured data.\n'
                      '- **File Systems:** Helps in merging sorted data across distributed systems.',
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
      color: Colors.green[100], // Matches the provided design
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
  runApp(MergeSortLearnPage());
}
