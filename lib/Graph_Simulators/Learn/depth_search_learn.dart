import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class DepthFirstLearnPage extends StatefulWidget {
  @override
  _DepthFirstLearnPageState createState() => _DepthFirstLearnPageState();
}

class _DepthFirstLearnPageState extends State<DepthFirstLearnPage> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();

    // Initialize the video player with an asset video
    _controller =
        VideoPlayerController.asset('assets/Depth_First_Search_Tree.mp4')
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
          title: Text('Learn About Depth First Search'),
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
                  'What is Depth First Search?',
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
                      'Depth First Search (DFS) is an algorithm for traversing or searching tree or graph data structures. '
                      'The algorithm starts at the root node and explores as far as possible along each branch before backtracking.',
                ),
                ExpandableCard(
                  title: 'Key Properties',
                  content:
                      '- **Uses a stack (either explicit or via recursion):** Helps in backtracking.\n'
                      '- **Explores deeper nodes first:** Prioritizes visiting the children before moving to siblings.\n'
                      '- **Applications:** Cycle detection, pathfinding, topological sorting, and solving puzzles.',
                ),
                ExpandableCard(
                  title: 'Algorithm Steps',
                  content:
                      '1. Start at the root node (or any arbitrary node in a graph).\n'
                      '2. Mark the current node as visited and push it onto the stack.\n'
                      '3. Explore the unvisited neighbors of the current node.\n'
                      '4. Repeat steps 2-3 until all nodes are visited.\n'
                      '5. Backtrack when no unvisited neighbors are left.',
                ),
                SizedBox(height: 24),

                // History Section
                Text(
                  'History of Depth First Search',
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
                      'The concept of Depth First Search was first introduced in the early 19th century in the context of mathematics and graph theory. '
                      'It gained prominence in computer science as an efficient way to explore data structures.',
                ),
                ExpandableCard(
                  title: 'Significance',
                  content:
                      'Depth First Search laid the groundwork for many modern algorithms, including those for solving mazes, planning, and analyzing networks. '
                      'It is one of the most fundamental algorithms in graph theory.',
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
  runApp(DepthFirstLearnPage());
}
