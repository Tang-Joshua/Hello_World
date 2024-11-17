import 'package:flutter/material.dart';

class BreadthFirstLearnPage extends StatelessWidget {
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
          title: Text('Learn About Breadth First Search'),
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
                  'What is Breadth First Search?',
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
                      'Breadth First Search (BFS) is an algorithm for traversing or searching tree or graph data structures. '
                      'It starts at the root (or any arbitrary node in a graph) and explores all neighbors at the current depth '
                      'before moving on to the next depth level.',
                ),
                ExpandableCard(
                  title: 'Key Properties',
                  content:
                      '- **Uses a queue:** Ensures nodes are explored level by level.\n'
                      '- **Explores all neighbors:** Visits all neighboring nodes before proceeding.\n'
                      '- **Applications:** Shortest path finding, graph traversal, and solving puzzles like mazes.',
                ),
                ExpandableCard(
                  title: 'Algorithm Steps',
                  content:
                      '1. Start at the root node (or any arbitrary node in a graph).\n'
                      '2. Mark the current node as visited and enqueue it.\n'
                      '3. Dequeue a node and visit all its unvisited neighbors.\n'
                      '4. Mark the neighbors as visited and enqueue them.\n'
                      '5. Repeat steps 3-4 until the queue is empty.',
                ),
                SizedBox(height: 24),
                // History Section
                Text(
                  'History of Breadth First Search',
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
                      'Breadth First Search was developed as part of graph theory in the 20th century. '
                      'Its roots lie in the study of networks and data organization, making it one of the earliest traversal algorithms.',
                ),
                ExpandableCard(
                  title: 'Significance',
                  content:
                      'BFS became widely adopted due to its ability to find the shortest path in unweighted graphs, '
                      'and its versatility in exploring graph structures in systematic ways.',
                ),
                SizedBox(height: 24),
                // Applications Section
                Text(
                  'Applications of Breadth First Search',
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
                      '- **Shortest Path:** Used in unweighted graphs to find the shortest path.\n'
                      '- **Web Crawlers:** Traverse the web level by level.\n'
                      '- **Social Networks:** Find the shortest connection or relationships between users.\n'
                      '- **Maze Solving:** Explore all possible paths level by level.',
                ),
                ExpandableCard(
                  title: 'Advanced Applications',
                  content:
                      '- **Network Broadcasts:** Ensure information spreads level by level across a network.\n'
                      '- **Garbage Collection:** Used in algorithms like mark-and-sweep for memory management.\n'
                      '- **Artificial Intelligence:** Pathfinding in AI games and decision-making.',
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
      color: Colors.green[100],
      elevation: 0, // Flat design
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
  runApp(BreadthFirstLearnPage());
}
