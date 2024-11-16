import 'package:flutter/material.dart';

class QueueEducationalPage extends StatelessWidget {
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
            'Learn About Queue',
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
                  'What is a Queue?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[900],
                  ),
                ),
                SizedBox(height: 12),
                ExpandableCard(
                  title: 'Definition',
                  content: 'A queue is a linear data structure that follows the First In, First Out (FIFO) principle. '
                      'This means the first element added to the queue is the first one to be removed.',
                ),
                ExpandableCard(
                  title: 'Common Queue Operations',
                  content: '- Enqueue: Add an element to the end of the queue.\n'
                      '- Dequeue: Remove the element from the front of the queue.\n'
                      '- Peek: View the front element without removing it.\n'
                      '- IsEmpty: Check if the queue is empty.',
                ),
                ExpandableCard(
                  title: 'Applications of Queue',
                  content: '- Managing requests in a printer or CPU scheduling.\n'
                      '- Handling asynchronous tasks (e.g., message queues).\n'
                      '- Breadth-First Search (BFS) in graph traversal.\n'
                      '- Managing customer service or ticketing systems.',
                ),
                SizedBox(height: 24),
                Text(
                  'History of the Queue',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[900],
                  ),
                ),
                SizedBox(height: 12),
                ExpandableCard(
                  title: 'Early Development',
                  content: 'The concept of the queue emerged from the need to handle multiple tasks in an organized way. '
                      'It has been used in computer science for task scheduling since the 1960s.',
                ),
                ExpandableCard(
                  title: 'Key Contributions',
                  content: '- Introduced as a fundamental structure for managing resources.\n'
                      '- Key in the development of process scheduling in operating systems.\n'
                      '- Plays a central role in network traffic and packet switching.',
                ),
                ExpandableCard(
                  title: 'Modern Importance',
                  content: 'Queues are essential in modern computing for handling large-scale systems such as web servers, '
                      'databases, and distributed message systems like Kafka and RabbitMQ.',
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
  runApp(QueueEducationalPage());
}
