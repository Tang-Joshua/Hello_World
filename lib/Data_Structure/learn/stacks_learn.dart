import 'package:flutter/material.dart';

class StackEducationalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white, // Set background to white
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Learn About Stack',
            style: TextStyle(color: Colors.green[900]), // Green title text
          ),
          backgroundColor: Colors.white, // White app bar
          iconTheme: IconThemeData(color: Colors.green[900]), // Green back button
          elevation: 1,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Navigate back
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
                  content: 'A stack is a linear data structure that follows the Last In, First Out (LIFO) principle. '
                      'This means the last element added to the stack is the first one to be removed.',
                ),
                ExpandableCard(
                  title: 'Common Stack Operations',
                  content: '- Push: Add an element to the top of the stack.\n'
                      '- Pop: Remove the top element of the stack.\n'
                      '- Peek: View the top element without removing it.\n'
                      '- IsEmpty: Check if the stack is empty.',
                ),
                ExpandableCard(
                  title: 'Applications of Stack',
                  content: '- Function call management in programming.\n'
                      '- Undo functionality in text editors.\n'
                      '- Balancing symbols (e.g., parentheses in expressions).\n'
                      '- Navigation in browsers (back and forward operations).',
                ),
                SizedBox(height: 24),
                Text(
                  'History of the Stack',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[900],
                  ),
                ),
                SizedBox(height: 12),
                ExpandableCard(
                  title: 'Early Development',
                  content: 'The concept of the stack was first introduced by Friedrich L. Bauer and Klaus Samelson in 1957. '
                      'They developed the idea while working on the translation of mathematical formulae into machine language.',
                ),
                ExpandableCard(
                  title: 'Key Contributions',
                  content: '- In 1957, the stack was utilized in the implementation of recursive functions.\n'
                      '- It was integral to the development of early compilers.\n'
                      '- The stack is now a critical component in the design of many algorithms, '
                      'including depth-first search and expression evaluation.',
                ),
                ExpandableCard(
                  title: 'Modern Importance',
                  content: 'Stacks play a key role in programming languages, operating systems, and computer architecture. '
                      'For example, they are used in the management of function calls and local variables in program execution.',
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
      color: Colors.green[50], // Light green card background
      elevation: 2,
      child: InkWell(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
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
                      color: Colors.green[900], // Dark green text
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.green[700], // Medium green icon
                  ),
                ],
              ),
              if (_isExpanded) ...[
                SizedBox(height: 8),
                Text(
                  widget.content,
                  style: TextStyle(fontSize: 16, color: Colors.green[800]),
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
  runApp(StackEducationalPage());
}
