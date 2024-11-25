import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MergeSortLearnPage extends StatefulWidget {
  @override
  _MergeSortLearnPageState createState() => _MergeSortLearnPageState();
}

class _MergeSortLearnPageState extends State<MergeSortLearnPage> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();

    // Initialize the video player with an asset video
    _controller = VideoPlayerController.asset('assets/Merge_Sort.mp4')
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
                  content: '1. Divide the array into two halves.\n'
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
