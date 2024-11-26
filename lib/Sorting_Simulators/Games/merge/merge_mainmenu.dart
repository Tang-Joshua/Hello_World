import 'package:flutter/material.dart';
import 'Split/Splitting_game.dart'; // Import splitting game
import 'Merge/Merge_game.dart'; // Import merging game

class MergeMainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showInstructions(
          context); // Automatically show instructions when the menu opens
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Merge Sort Games",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {
              _showInstructions(
                  context); // Show instructions when '?' is tapped
            },
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                // Section Title: Divide/Splitting Stages
                _buildSectionTitle("Divide/Splitting Stages"),
                const SizedBox(height: 20),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    _buildLevelBox("1", context, "split"),
                    _buildLevelBox("2", context, "split"),
                    _buildLevelBox("3", context, "split"),
                    _buildLevelBox("4", context, "split"),
                    _buildLevelBox("5", context, "split"),
                    _buildLevelBox("6", context, "split"),
                    _buildLevelBox("7", context, "split"),
                    _buildLevelBox("8", context, "split"),
                  ],
                ),
                const SizedBox(height: 40),

                // Section Title: Conquer/Merge Stages
                _buildSectionTitle("Conquer/Merge Stages"),
                const SizedBox(height: 20),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    _buildLevelBox("1", context, "merge"),
                    _buildLevelBox("2", context, "merge"),
                    _buildLevelBox("3", context, "merge"),
                    _buildLevelBox("4", context, "merge"),
                    _buildLevelBox("5", context, "merge"),
                    _buildLevelBox("6", context, "merge"),
                    _buildLevelBox("7", context, "merge"),
                    _buildLevelBox("8", context, "merge"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white, // Clean white background
    );
  }

  // Helper function to create the section title
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.green, // Green section titles
      ),
      textAlign: TextAlign.center,
    );
  }

  void _showInstructions(BuildContext context) {
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
              // Section: Merge Game Instructions
              Row(
                children: [
                  Icon(Icons.merge_type, color: Colors.green, size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    'Merge Game Instructions:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildInstructionStep(
                icon: Icons.merge,
                text:
                    'Merge numbers into sorted groups by selecting the correct merge steps.',
                iconColor: Colors.blue,
              ),
              _buildInstructionStep(
                icon: Icons.done,
                text: 'Complete all stages to finish the level.',
                iconColor: Colors.green,
              ),
              _buildInstructionStep(
                icon: Icons.timer,
                text: 'Keep an eye on the timer (if applicable).',
                iconColor: Colors.red,
              ),
              const SizedBox(height: 16),

              // Section: Split Game Instructions
              Row(
                children: [
                  Icon(Icons.call_split, color: Colors.orange, size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    'Split Game Instructions:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildInstructionStep(
                icon: Icons.drag_handle,
                text:
                    'Tap the correct split points to divide numbers into groups.',
                iconColor: Colors.purple,
              ),
              _buildInstructionStep(
                icon: Icons.favorite,
                text:
                    'You have limited hearts; wrong actions will reduce them.',
                iconColor: Colors.red,
              ),
              _buildInstructionStep(
                icon: Icons.refresh,
                text: 'Complete all split stages to finish the level.',
                iconColor: Colors.green,
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

// Helper for creating each step in instructions
  Widget _buildInstructionStep({
    required IconData icon,
    required String text,
    required Color iconColor,
  }) {
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

  // Helper function to create the level boxes
  Widget _buildLevelBox(String level, BuildContext context, String type) {
    return GestureDetector(
      onTap: () {
        if (type == "split") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SplittingGame(level: level)),
          );
        } else if (type == "merge") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MergeSortGamePage(level: level)),
          );
        }
      },
      child: Container(
        width: 80,
        height: 80,
        alignment: Alignment.center,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green, Colors.blue], // Green to blue gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: Offset(2, 3), // Subtle shadow
            ),
          ],
        ),
        child: Text(
          level,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white, // White text for contrast
          ),
        ),
      ),
    );
  }
}
