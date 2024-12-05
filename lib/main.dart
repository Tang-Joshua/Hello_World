import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'Login.dart';
import 'firebase_options.dart';

import 'package:flutterapp/Sorting_Simulators/Sorting_Choices.dart';
import 'package:flutterapp/Graph_Simulators/Graph_Choices.dart';
import 'package:flutterapp/Data_Structure/Data_Choices.dart';
import 'package:flutter/rendering.dart';
import 'music.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    demoProjectId: "demo-project-id",
  );
  debugPaintSizeEnabled = false;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AL-GO!',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 68, 237, 133),
        ),
        useMaterial3: false,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 190, 240, 190),
                    Color.fromARGB(255, 240, 250, 240),
                  ],
                ),
              ),
            ),
          ),

          // Background curves
          Positioned.fill(
            child: ClipPath(
              clipper: MyClipper(),
              child: Container(
                color: Colors.green.shade400.withOpacity(0.4),
              ),
            ),
          ),
          Positioned.fill(
            child: ClipPath(
              clipper: MySecondClipper(),
              child: Container(
                color: Colors.green.shade600.withOpacity(0.6),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  Text(
                    "AL-GO!",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Sorting Algorithms Button
                  _buildMenuButton(
                    context,
                    label: "SORTING ALGORITHMS",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SortingChoices()),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Graph Algorithms Button
                  _buildMenuButton(
                    context,
                    label: "GRAPH ALGORITHMS",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GraphChoices()),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Data Structures Button
                  _buildMenuButton(
                    context,
                    label: "DATA STRUCTURES",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DataChoices()),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Account Button
                  _buildMenuButton(
                    context,
                    label: "ACCOUNT",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CenterButtonScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 40),

                  // Exit Button
                  _buildMenuButton(
                    context,
                    label: "EXIT",
                    onPressed: () {
                      // Exit action (can close app or return to main screen)
                      print("Exit selected");
                    },
                    isExit: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required String label,
    required VoidCallback onPressed,
    bool isExit = false,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isExit ? Colors.grey : Colors.green.shade700,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}

// Clipper for the first curve
class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.6);

    Offset firstControlPoint = Offset(size.width * 0.25, size.height * 0.55);
    Offset firstEndPoint = Offset(size.width * 0.5, size.height * 0.65);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    Offset secondControlPoint = Offset(size.width * 0.75, size.height * 0.75);
    Offset secondEndPoint = Offset(size.width, size.height * 0.6);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Clipper for the second curve
class MySecondClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.5);

    Offset firstControlPoint = Offset(size.width * 0.5, size.height * 0.75);
    Offset firstEndPoint = Offset(size.width, size.height * 0.5);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
