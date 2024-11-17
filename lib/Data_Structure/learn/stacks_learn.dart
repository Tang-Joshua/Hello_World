import 'package:flutter/material.dart';

class StacksLearnPage extends StatelessWidget {
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
          title: Text('Learn About Stacks'),
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
                  'What is a Stack?',
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
                      'A stack is a linear data structure that follows the Last In, First Out (LIFO) principle. '
                      'This means the last element added to the stack is the first one to be removed.',
                ),
                ExpandableCard(
                  title: 'Common Operations',
                  content:
                      '- **Push:** Add an element to the top of the stack.\n'
                      '- **Pop:** Remove the top element of the stack.\n'
                      '- **Peek:** View the top element without removing it.\n'
                      '- **IsEmpty:** Check if the stack is empty.',
                ),
                ExpandableCard(
                  title: 'Characteristics',
                  content:
                      '- Operates like a stack of plates where the last plate added is the first to be removed.\n'
                      '- Uses a single end for both insertion and removal.',
                ),
                SizedBox(height: 24),
                // History Section
                Text(
                  'History of Stacks',
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
                      'The concept of the stack was first introduced in 1957 by Friedrich L. Bauer and Klaus Samelson '
                      'to aid in the translation of mathematical formulae into machine language.',
                ),
                ExpandableCard(
                  title: 'Significance',
                  content:
                      'Stacks are fundamental in computer science and are widely used in algorithms, compilers, and memory management.',
                ),
                SizedBox(height: 24),
                // Applications Section
                Text(
                  'Applications of Stacks',
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
                      '- **Function Call Management:** Tracks function calls in programming.\n'
                      '- **Undo Functionality:** Supports undo operations in text editors.\n'
                      '- **Expression Evaluation:** Evaluates expressions with parentheses.\n'
                      '- **Browser Navigation:** Implements the back and forward buttons.',
                ),
                ExpandableCard(
                  title: 'Advanced Applications',
                  content:
                      '- **Parsing Algorithms:** Used in syntax parsing for compilers.\n'
                      '- **Recursive Algorithms:** Supports recursive function calls by storing return addresses.\n'
                      '- **Memory Management:** Helps in managing program execution stack.',
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
  runApp(StacksLearnPage());
}
