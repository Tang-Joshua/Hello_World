import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class QueuesPage extends StatefulWidget {
  const QueuesPage({Key? key}) : super(key: key);

  @override
  State<QueuesPage> createState() => _QueuesPageState();
}

class _QueuesPageState extends State<QueuesPage> {
  List<int> queue = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late AudioPlayer _audioPlayer;
  bool isMusicPlaying = false;

  Color _visualizationBorderColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _playBackgroundMusic();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showInstructions();
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    _stopBackgroundMusic();
    super.dispose();
  }

  // Initialize the AudioPlayer and play background music:
  void _playBackgroundMusic() async {
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop); // Loop the music
      await _audioPlayer.setVolume(0.2); // Adjust the volume
      await _audioPlayer.play(AssetSource('Sounds/simulationall.mp3'));
      setState(() => isMusicPlaying = true);
    } catch (e) {
      print("Error playing background music: $e");
    }
  }

// Stop the background music:
  void _stopBackgroundMusic() async {
    try {
      await _audioPlayer.stop();
      setState(() => isMusicPlaying = false);
    } catch (e) {
      print("Error stopping background music: $e");
    }
  }

  void _autoGenerateInput() {
    final random = Random();
    final randomValues = List.generate(5, (_) => random.nextInt(100));
    _inputController.text = randomValues.join(', ');
  }

  void _showInstructions() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Instructions',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info, color: Colors.indigo, size: 24),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'How to Use Queues Visualization:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildSteps(
                icon: Icons.add_box,
                text: 'Enqueue: Adds a new item to the end of the queue.',
                iconColor: Colors.green,
              ),
              _buildSteps(
                icon: Icons.remove_circle,
                text: 'Dequeue: Removes the front item from the queue.',
                iconColor: Colors.red,
              ),
              _buildSteps(
                icon: Icons.casino,
                text:
                    'Randomize Input: Automatically fills the queue with random numbers.',
                iconColor: Colors.purple,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.indigo),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSteps(
      {required IconData icon,
      required String text,
      required Color iconColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  void enqueue() {
    String inputText = _inputController.text.trim();
    if (inputText.isEmpty) {
      _showSnackbar('Input field is empty!');
      return;
    }

    final numbers = inputText
        .split(RegExp(r'[,\s]+'))
        .where((value) => value.isNotEmpty)
        .map((e) => int.tryParse(e))
        .where((e) => e != null)
        .cast<int>()
        .toList();

    if (numbers.isEmpty) {
      _showSnackbar('Invalid input! Please enter valid numbers.');
      return;
    }

    setState(() {
      for (final number in numbers) {
        queue.add(number);
        _listKey.currentState?.insertItem(
          queue.length - 1,
          duration: const Duration(milliseconds: 500),
        );
      }
      _visualizationBorderColor = Colors.blueAccent;
    });

    _inputController.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });
  }

  void dequeue() {
    if (queue.isEmpty) {
      _showSnackbar('Nothing to dequeue!');
      return;
    }

    int dequeuedNumber = queue.removeAt(0);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });

    Future.delayed(const Duration(seconds: 0), () {
      _listKey.currentState?.removeItem(
        0,
        (context, animation) =>
            _buildItem(dequeuedNumber, animation, dequeuing: true),
        duration: const Duration(milliseconds: 500),
      );

      setState(() {
        _visualizationBorderColor = Colors.redAccent;
      });
    });
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildItem(int number, Animation<double> animation,
      {bool dequeuing = false}) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        axis: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: dequeuing ? Colors.red : Colors.blueAccent,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Text(
              number.toString(),
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text('Queues', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            onPressed: _showInstructions,
            icon: const Icon(Icons.help_outline, color: Colors.black),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: _autoGenerateInput,
                  icon: const Icon(Icons.casino, color: Colors.blue),
                ),
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    decoration: const InputDecoration(
                      hintText: 'Enter numbers (comma or space-separated)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Queue Visualization:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                decoration: BoxDecoration(
                  border:
                      Border.all(color: _visualizationBorderColor, width: 2),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width *
                        0.25, // 10% of screen width
                    top: MediaQuery.of(context).size.height *
                        0.25, // 20% of screen height
                  ),
                  child: AnimatedList(
                    key: _listKey,
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    initialItemCount: queue.length,
                    itemBuilder: (context, index, animation) {
                      return _buildItem(queue[index], animation);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: enqueue,
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('Enqueue',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
                ElevatedButton.icon(
                  onPressed: dequeue,
                  icon: const Icon(Icons.remove, color: Colors.white),
                  label: const Text('Dequeue',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(
      const MaterialApp(home: QueuesPage(), debugShowCheckedModeBanner: false));
}
