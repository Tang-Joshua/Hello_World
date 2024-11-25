import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class BinarySearchLearnPage extends StatefulWidget {
  @override
  _BinarySearchLearnPageState createState() => _BinarySearchLearnPageState();
}

class _BinarySearchLearnPageState extends State<BinarySearchLearnPage> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();

    // Initialize the video player with an asset video
    _controller = VideoPlayerController.asset('assets/Binary_Search_Tree.mp4')
      ..initialize().then((_) {
        setState(() {}); // Update UI after video initialization
        _isPlaying = _controller.value.isPlaying;
      });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the video controller
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

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
          title: Text('Learn About Binary Search Tree'),
          backgroundColor: Colors.green[700],
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
                // Video Player Section
                if (_controller.value.isInitialized)
                  Column(
                    children: [
                      AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                      SizedBox(height: 8),

                      // Video Progress Indicator with drag support
                      VideoProgressIndicator(
                        _controller,
                        allowScrubbing: true, // Enable dragging
                        colors: VideoProgressColors(
                          playedColor: Colors.green,
                          backgroundColor: Colors.grey.shade300,
                          bufferedColor: Colors.green.shade200,
                        ),
                      ),
                      SizedBox(height: 8),

                      // Play/Pause Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: _togglePlayPause,
                            icon: Icon(
                              _isPlaying ? Icons.pause : Icons.play_arrow,
                              size: 30,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            _isPlaying ? "Playing" : "Paused",
                            style: TextStyle(fontSize: 16, color: Colors.green),
                          ),
                        ],
                      ),
                    ],
                  )
                else
                  Center(child: CircularProgressIndicator()),

                SizedBox(height: 16),

                // Section Header
                Text(
                  'What is a Binary Search Tree?',
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
                      'A Binary Search Tree (BST) is a data structure in which each node has at most two children, '
                      'referred to as the left child and the right child. The left subtree of a node contains '
                      'only nodes with values less than the node\'s value, and the right subtree contains only nodes '
                      'with values greater than the node\'s value.',
                ),
                ExpandableCard(
                  title: 'Properties',
                  content: '- Each node has at most two children.\n'
                      '- The left subtree contains values smaller than the root.\n'
                      '- The right subtree contains values greater than the root.\n'
                      '- No duplicate values are allowed.',
                ),
                ExpandableCard(
                  title: 'Operations',
                  content: '- Search: Find if a value exists in the tree.\n'
                      '- Insertion: Add a new value to the tree while maintaining the BST property.\n'
                      '- Deletion: Remove a value while reorganizing the tree to maintain its properties.\n'
                      '- Traversal: Visit all nodes in a specific order (e.g., Inorder, Preorder, Postorder).',
                ),
                SizedBox(height: 24),
                // History Section
                Text(
                  'History of Binary Search Tree',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[900],
                  ),
                ),
                SizedBox(height: 12),
                ExpandableCard(
                  title: 'Early Development',
                  content:
                      'The concept of the Binary Search Tree emerged in the early days of computer science as a way '
                      'to organize data for efficient searching, insertion, and deletion. It was formalized in the mid-20th century.',
                ),
                ExpandableCard(
                  title: 'Significance',
                  content:
                      '- BSTs became a cornerstone in algorithm design for search and sort operations.\n'
                      '- They paved the way for the development of balanced trees such as AVL trees and Red-Black trees.',
                ),
                SizedBox(height: 24),
                // Applications Section
                Text(
                  'Applications of Binary Search Tree',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[900],
                  ),
                ),
                SizedBox(height: 12),
                ExpandableCard(
                  title: 'Practical Use Cases',
                  content:
                      '- Databases: Efficiently manage and retrieve sorted data.\n'
                      '- Compilers: Organize syntax trees for parsing.\n'
                      '- Networking: Route IP addresses using tree structures.',
                ),
                ExpandableCard(
                  title: 'Algorithm Design',
                  content:
                      '- BSTs are used in constructing efficient algorithms for searching, dynamic sets, and associative arrays.\n'
                      '- Many modern applications utilize tree-based structures for quick data access.',
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
      color: Colors.green[100], // Matching card background color
      elevation: 0, // Flat cards for a clean look
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
                      color: Colors.green[900], // Matching title color
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.green[900], // Matching icon color
                  ),
                ],
              ),
              if (_isExpanded) ...[
                SizedBox(height: 8),
                Text(
                  widget.content,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green[800], // Matching content color
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
  runApp(BinarySearchLearnPage());
}
