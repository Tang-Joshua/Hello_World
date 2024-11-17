import 'package:flutter/material.dart';

class RadixSortLearnPage extends StatelessWidget {
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
          title: Text('Learn About Radix Sort'),
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
                  'What is Radix Sort?',
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
                      'Radix Sort is a non-comparative sorting algorithm that sorts numbers by processing their digits. '
                      'It groups numbers based on their individual digit values, starting from the least significant digit '
                      'to the most significant digit.',
                ),
                ExpandableCard(
                  title: 'Key Properties',
                  content:
                      '- **Stable Sort:** Maintains the relative order of elements with equal keys.\n'
                      '- **Non-Comparative:** Does not compare individual elements directly, unlike Quick Sort or Merge Sort.\n'
                      '- **Requires Auxiliary Space:** Uses additional space to group elements by digit values.',
                ),
                ExpandableCard(
                  title: 'Algorithm Steps',
                  content:
                      '1. Find the maximum number in the list and determine the number of digits.\n'
                      '2. Start from the least significant digit (LSD) and sort numbers into buckets (0-9).\n'
                      '3. Combine the buckets in order and move to the next significant digit.\n'
                      '4. Repeat steps 2-3 for all digits, from LSD to most significant digit (MSD).\n'
                      '5. The list is now sorted.',
                ),
                SizedBox(height: 24),
                // History Section
                Text(
                  'History of Radix Sort',
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
                      'Radix Sort was introduced by Herman Hollerith in 1887 for use in tabulating machines. '
                      'It was later formalized as a sorting algorithm in the mid-20th century and remains '
                      'a popular choice for sorting large datasets with numeric keys.',
                ),
                ExpandableCard(
                  title: 'Significance',
                  content:
                      'Radix Sort is especially efficient for sorting large datasets with a fixed range of numbers. '
                      'Its non-comparative nature makes it ideal for certain applications like card sorting and phone directories.',
                ),
                SizedBox(height: 24),
                // Applications Section
                Text(
                  'Applications of Radix Sort',
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
                      '- **Sorting Numbers:** Used to sort large datasets of integers or floating-point numbers.\n'
                      '- **Card Sorting:** Helps in sorting card decks in casino games.\n'
                      '- **Phone Directories:** Efficiently organizes large lists of phone numbers.\n'
                      '- **DNA Sequencing:** Sorting data with fixed-length keys.',
                ),
                ExpandableCard(
                  title: 'Advanced Applications',
                  content:
                      '- **Distributed Systems:** Works well with datasets distributed across multiple machines.\n'
                      '- **Specialized Hardware:** Optimized for parallel processing in GPUs.\n'
                      '- **Data Analysis:** Sorting fixed-length strings or categorical data in analytics pipelines.',
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
      color: Colors.green[100], // Same as the screenshot
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
                      color: Colors.green[900], // Same text color
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
                    color: Colors.green[800], // Consistent with other pages
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
  runApp(RadixSortLearnPage());
}
