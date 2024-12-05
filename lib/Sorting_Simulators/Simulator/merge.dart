import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MergeSortPage extends StatefulWidget {
  const MergeSortPage({Key? key}) : super(key: key);

  @override
  State<MergeSortPage> createState() => _MergeSortPageState();
}

class _MergeSortPageState extends State<MergeSortPage>
    with TickerProviderStateMixin {
  List<int> stack = [];
  final TextEditingController inputController = TextEditingController();
  bool isSorting = false;
  late ScrollController _scrollController;
  late TabController _tabController;
  late AudioPlayer _audioPlayer;
  bool isMusicPlaying = false;

  bool isInsertClicked = false; // To track if insert/check button was clicked

  List<Map<String, dynamic>> topVisualizationSteps = [];
  List<Map<String, dynamic>> leftVisualizationSteps = [];
  List<Map<String, dynamic>> rightVisualizationSteps = [];
  List<Map<String, dynamic>> finalMergeStep = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _tabController = TabController(length: 2, vsync: this);

    _audioPlayer = AudioPlayer();
    _playBackgroundMusic(); // Start background music

    inputController.addListener(() {
      setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showInstructions();
    });
  }

  @override
  void dispose() {
    inputController.dispose();
    _scrollController.dispose();
    _tabController.dispose();
    _stopBackgroundMusic(); // Stop music when exiting the page
    super.dispose();
  }

  void _stopBackgroundMusic() async {
    try {
      await _audioPlayer.stop();
      setState(() => isMusicPlaying = false);
    } catch (e) {
      print("Error stopping background music: $e");
    }
  }

  void _playBackgroundMusic() async {
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop); // Loop the music
      await _audioPlayer.setVolume(0.2); // Adjust volume as needed
      await _audioPlayer.play(AssetSource('Sounds/simulationall.mp3'));
      setState(() => isMusicPlaying = true);
    } catch (e) {
      print("Error playing background music: $e");
    }
  }

  Future<void> sort() async {
    setState(() {
      isSorting = true;
      topVisualizationSteps.clear();
      leftVisualizationSteps.clear();
      rightVisualizationSteps.clear();
      finalMergeStep.clear();
    });

    List<int> initialList = List.from(stack);
    _addStep(topVisualizationSteps, [initialList], label: "Initial List");

    int mid = (initialList.length + 1) ~/ 2;
    List<int> leftArray = initialList.sublist(0, mid);
    List<int> rightArray = initialList.sublist(mid);

    _addStep(topVisualizationSteps, [leftArray, rightArray],
        label: "Initial Split");
    await Future.delayed(const Duration(milliseconds: 600));

    leftArray = await _mergeSortWithVisualization(
        leftArray, "Left Array", 1, leftVisualizationSteps);
    rightArray = await _mergeSortWithVisualization(
        rightArray, "Right Array", 1, rightVisualizationSteps);

    List<int> sortedArray = _merge(leftArray, rightArray);
    _addStep(finalMergeStep, [sortedArray], label: "Final Merged Array");

    setState(() {
      isSorting = false;
    });
  }

  Future<List<int>> _mergeSortWithVisualization(List<int> arr, String label,
      int level, List<Map<String, dynamic>> steps) async {
    if (arr.length <= 1) {
      return arr;
    }

    int mid = (arr.length + 1) ~/ 2;
    List<int> left = arr.sublist(0, mid);
    List<int> right = arr.sublist(mid);

    _addStep(steps, [left, right], label: "$label Split", level: level);
    await Future.delayed(const Duration(milliseconds: 600));

    left = await _mergeSortWithVisualization(left, label, level + 1, steps);
    right = await _mergeSortWithVisualization(right, label, level + 1, steps);

    List<int> merged = _merge(left, right);
    _addStep(steps, [merged], label: "$label Merge", level: level);
    await Future.delayed(const Duration(milliseconds: 600));

    return merged;
  }

  List<int> _merge(List<int> left, List<int> right) {
    List<int> result = [];
    int i = 0, j = 0;

    while (i < left.length && j < right.length) {
      if (left[i] <= right[j]) {
        result.add(left[i++]);
      } else {
        result.add(right[j++]);
      }
    }

    while (i < left.length) result.add(left[i++]);
    while (j < right.length) result.add(right[j++]);

    return result;
  }

  void _addStep(List<Map<String, dynamic>> steps, List<List<int>> groups,
      {String? label, int level = 0}) {
    List<List<int>> filteredGroups =
        groups.where((group) => group.isNotEmpty).toList();
    if (filteredGroups.isNotEmpty) {
      steps.add({
        'label': label,
        'groups': filteredGroups,
        'level': level,
      });
      setState(() {});
    }
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
            color: Colors.blueAccent,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Title
              Row(
                children: [
                  Icon(Icons.info, color: Colors.blue, size: 24),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'How to Use Merge Sort Visualization:',
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

              // Step-by-step Instructions
              _buildStep(
                icon: Icons.casino,
                text:
                    'Randomize Input: Click the dice icon to auto-generate random numbers.',
                iconColor: Colors.purple,
              ),
              _buildStep(
                icon: Icons.check_circle,
                text:
                    'Enter Input: Type comma-separated numbers (e.g., "10, 20, 30") and click the check button to add them.',
                iconColor: Colors.green,
              ),
              _buildStep(
                icon: Icons.play_arrow,
                text:
                    'Start Sorting: Click the play button to visualize the sorting process step by step.',
                iconColor: Colors.blue,
              ),
              _buildStep(
                icon: Icons.refresh,
                text:
                    'Clear Visualization: Resets the visualization after sorting is complete. This button will be disabled during sorting.',
                iconColor: Colors.red,
              ),
              const SizedBox(height: 16),

              // Button Guide
              Row(
                children: [
                  Icon(Icons.help_outline, color: Colors.blue, size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    'Button Guide:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildButtonGuide(
                icon: Icons.casino,
                label: 'Randomize Input',
                description:
                    'Automatically fills the input field with random numbers.',
                backgroundColor: Colors.purple[100]!,
                iconColor: Colors.purple,
              ),
              _buildButtonGuide(
                icon: Icons.check_circle,
                label: 'Insert Input',
                description: 'Adds your entered numbers to the visualization.',
                backgroundColor: Colors.green[100]!,
                iconColor: Colors.green,
              ),
              _buildButtonGuide(
                icon: Icons.play_arrow,
                label: 'Start Sorting',
                description: 'Begins sorting the numbers using Merge Sort.',
                backgroundColor: Colors.blue[100]!,
                iconColor: Colors.blue,
              ),
              _buildButtonGuide(
                icon: Icons.refresh,
                label: 'Clear Visualization',
                description: 'Resets the visualization and clears all steps.',
                backgroundColor: Colors.red[100]!,
                iconColor: Colors.red,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
        ],
      ),
    );
  }

// Helper to build each step with an icon
  Widget _buildStep(
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

// Helper to build the button guide with colored background
  Widget _buildButtonGuide({
    required IconData icon,
    required String label,
    required String description,
    required Color backgroundColor,
    required Color iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void insertNumbers() {
    List<String> inputNumbers = inputController.text.split(RegExp(r'[,\s]+'));
    stack.clear();
    for (String numStr in inputNumbers) {
      int? number = int.tryParse(numStr.trim());
      if (number != null) {
        stack.add(number);
      }
    }
    inputController.clear();

    setState(() {
      isInsertClicked = true;
    });
  }

  void generateRandomNumbers() {
    final random = Random();
    List<int> randomNumbers = List.generate(5, (_) => random.nextInt(100) + 1);
    inputController.text = randomNumbers.join(', ');
  }

  void clearVisualization() {
    setState(() {
      stack.clear();
      inputController.clear();
      topVisualizationSteps.clear();
      leftVisualizationSteps.clear();
      rightVisualizationSteps.clear();
      finalMergeStep.clear();
      isSorting = false;
      isInsertClicked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back
          },
        ),
        title: const Text('Merge Sort Visualization',
            style: TextStyle(color: Colors.black)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: _buildTabBar(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.black),
            onPressed: _showInstructions,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildVisualizationTab(),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
          ],
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, blurRadius: 2, offset: Offset(0, 2)),
            ],
          ),
          tabs: const [
            Tab(child: Text('Simulate', style: TextStyle(color: Colors.blue))),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualizationTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildInputRow(),
          const SizedBox(height: 16),
          _buildActionButtonsRow(),
          const SizedBox(height: 16),
          const Text(
            'Merge Sort Visualization:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildVisualizationContainer(),
        ],
      ),
    );
  }

  Widget _buildInputRow() {
    return Row(
      children: [
        SizedBox(
          height: 40,
          width: 40,
          child: ElevatedButton(
            onPressed: generateRandomNumbers,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(8),
              backgroundColor: Colors.blue,
              shape: const CircleBorder(),
            ),
            child: const Icon(Icons.casino, color: Colors.white),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: inputController,
            decoration: const InputDecoration(
              labelText: 'Enter numbers (comma or space-separated only)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtonsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (inputController.text.isNotEmpty)
          ElevatedButton(
            onPressed: insertNumbers,
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(12),
              backgroundColor: Colors.green,
            ),
            child: const Icon(Icons.check, color: Colors.white),
          ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed:
              !isSorting && isInsertClicked && stack.isNotEmpty ? sort : null,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(12),
            backgroundColor: Colors.blue,
          ),
          child: const Icon(Icons.play_arrow, color: Colors.white),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: !isSorting ? clearVisualization : null,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(12),
            backgroundColor: Colors.red,
          ),
          child: const Icon(Icons.refresh, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildVisualizationContainer() {
    return Expanded(
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            _buildContainerWithTitle("Initial Split", topVisualizationSteps),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: _buildContainerWithTitle(
                        "Left Array Steps", leftVisualizationSteps)),
                const SizedBox(width: 16),
                Expanded(
                    child: _buildContainerWithTitle(
                        "Right Array Steps", rightVisualizationSteps)),
              ],
            ),
            const SizedBox(height: 16),
            _buildContainerWithTitle("Final Merge", finalMergeStep),
          ],
        ),
      ),
    );
  }

  Widget _buildContainerWithTitle(
      String title, List<Map<String, dynamic>> steps) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Column(
            children: steps
                .map((step) =>
                    _buildStepWithLabel(step['groups'], step['label']))
                .toList(),
          ),
        ],
      ),
    );
  }

  // Updated Step Widget to Place Label on Top and Center the Grouped Values
  Widget _buildStepWithLabel(List<List<int>> groups, String? label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: groups.map(_buildGroupBox).toList(),
        ),
        const SizedBox(height: 8), // Add spacing between steps
      ],
    );
  }

  Widget _buildGroupBox(List<int> group) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blueAccent),
      ),
      child: Text(
        group.join(', '),
        style: const TextStyle(fontSize: 18, color: Colors.black),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: MergeSortPage(),
  ));
}
