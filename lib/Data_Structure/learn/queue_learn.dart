import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class QueueLearnPage extends StatefulWidget {
  @override
  _QueueLearnPageState createState() => _QueueLearnPageState();
}

class _QueueLearnPageState extends State<QueueLearnPage> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();

    // Initialize the video player with an asset video
    _controller = VideoPlayerController.asset('assets/Queue.mp4')
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
          title: Text('Learn About Queues'),
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
                  content:
                      'A queue is a linear data structure that follows the First In, First Out (FIFO) principle. '
                      'This means the first element added to the queue is the first one to be removed.',
                ),
                ExpandableCard(
                  title: 'Common Operations',
                  content:
                      '- **Enqueue:** Add an element to the back of the queue.\n'
                      '- **Dequeue:** Remove the element at the front of the queue.\n'
                      '- **Peek:** View the front element without removing it.\n'
                      '- **IsEmpty:** Check if the queue is empty.',
                ),
                ExpandableCard(
                  title: 'Characteristics',
                  content:
                      '- Operates like a line of people waiting, where the first person in line is served first.\n'
                      '- Uses two ends: one for insertion (rear) and one for removal (front).',
                ),
                SizedBox(height: 24),
                // History Section
                Text(
                  'History of Queues',
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
                      'Queues have been used in computing since the early days of computer science to manage tasks '
                      'such as scheduling and buffering.',
                ),
                ExpandableCard(
                  title: 'Significance',
                  content:
                      'Queues are essential in scenarios where data needs to be processed in the order it arrives, '
                      'ensuring fairness and predictability.',
                ),
                SizedBox(height: 24),
                // Applications Section
                Text(
                  'Applications of Queues',
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
                      '- **Task Scheduling:** Used in CPU scheduling and print queues.\n'
                      '- **Data Buffering:** Manages data streams in networked applications.\n'
                      '- **Breadth-First Search:** Used in graph traversal algorithms.',
                ),
                ExpandableCard(
                  title: 'Advanced Applications',
                  content:
                      '- **Messaging Systems:** Ensures messages are processed in the correct order.\n'
                      '- **Simulation Systems:** Models real-world systems like customer service lines.\n'
                      '- **Data Processing Pipelines:** Ensures orderly handling of data streams.',
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
  runApp(QueueLearnPage());
}
