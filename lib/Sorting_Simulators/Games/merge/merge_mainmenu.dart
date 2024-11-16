import 'package:flutter/material.dart';
import 'Split/Splitting_game.dart'; // Import splitting game
import 'Merge/Merge_game.dart'; // Import merging game

class MergeMainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Merge Sort Games",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
