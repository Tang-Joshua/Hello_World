import 'package:flutter/material.dart';
import 'package:flutterapp/Sorting_Simulators/Sorting_Choices.dart';
import 'package:flutterapp/Graph_Simulators/Graph_Choices.dart';
import 'package:flutterapp/Data_Structure/Data_Choices.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA), // Light background color
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(2), // Adjusted AppBar height
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // AL-GO Title
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  colors: [Colors.blue.shade500, Colors.green.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              child: const Text(
                'AL-GO!',
                style: TextStyle(
                  fontSize: 90, // Larger font size for prominence
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Gradient applied here
                  fontFamily: 'CrimsonPro', // Elegant font style
                  letterSpacing: 2.0,
                ),
              ),
            ),
            const SizedBox(
                height: 90), // Space between AL-GO and "Select an Algorithm"
            const Text(
              'Select an Algorithm',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: GridView.count(
                shrinkWrap: true, // Make GridView height fit the content
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildBox(
                    icon: Icons.sort,
                    title: "Sorting",
                    itemCount: "Explore Sorting Techniques",
                    color: Colors.blue.shade300,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SortingChoices()),
                      );
                    },
                  ),
                  _buildBox(
                    icon: Icons.graphic_eq,
                    title: "Graph",
                    itemCount: "Explore Graph Algorithms",
                    color: Colors.green.shade400,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GraphChoices()),
                      );
                    },
                  ),
                  _buildBox(
                    icon: Icons.storage_rounded,
                    title: "Data Structures",
                    itemCount: "Learn Data Structures",
                    color: Colors.orange.shade400,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DataChoices()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Exit action: Close the app
      //     print("Exit selected");
      //   },
      //   backgroundColor: Colors.red, // Red color for exit
      //   child: const Icon(Icons.exit_to_app, color: Colors.white), // Exit icon
      // ),
    );
  }

  Widget _buildBox({
    required IconData icon,
    required String title,
    required String itemCount,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: const Offset(4, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 28, color: Colors.white),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                itemCount,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
