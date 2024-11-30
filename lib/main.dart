import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:flutterapp/Sorting_Simulators/Sorting_Choices.dart';
import 'package:flutterapp/Graph_Simulators/Graph_Choices.dart';
import 'package:flutterapp/Data_Structure/Data_Choices.dart';
import 'package:flutter/rendering.dart';

void main() {
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
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 68, 237, 133)),
        useMaterial3: false,
      ),
      home: MyHomePage(),
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
          // Gradient background with curves, testings
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 88, 255, 70),
                    Color.fromARGB(255, 166, 244, 169),
                    Color.fromARGB(255, 218, 255, 216),
                  ],
                ),
              ),
            ),
          ),
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align text to the start
              children: <Widget>[
                const SizedBox(height: 70),
                // Designed Text
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      height: 1.5, // Line height
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'AL-GO!:',
                        style: TextStyle(
                          fontSize: 30, // Larger font size for emphasis
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 255,
                              255), // Different color for emphasis
                        ),
                      ),
                      const TextSpan(
                        text:
                            '\nA Mobile-Based Educational Simulator For Algorithms',
                        style: TextStyle(
                          fontSize: 24,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: StaggeredGrid.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      StaggeredGridTile.count(
                        crossAxisCellCount: 1,
                        mainAxisCellCount: 1,
                        child: _buildGridButton(
                          'Sorting Algorithms',
                          Icons.sort,
                          () {
                            print('Sorting Algorithms pressed');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SortingChoices()));
                          },
                        ),
                      ),
                      StaggeredGridTile.count(
                        crossAxisCellCount: 1,
                        mainAxisCellCount: 1,
                        child: _buildGridButton(
                          'Graph Algorithms',
                          Icons.graphic_eq,
                          () {
                            print('Graph Algorithm pressed');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GraphChoices()));
                          },
                        ),
                      ),
                      StaggeredGridTile.count(
                        crossAxisCellCount: 2, // Make this tile span 2 columns
                        mainAxisCellCount:
                            1.1, // Adjust the height to 1.5 cells
                        child: _buildGridButton(
                          'Data Structures',
                          Icons.storage,
                          () {
                            print('Data Structures pressed');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DataChoices()));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridButton(String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered)) {
              return Colors.greenAccent; // Change color on hover
            }
            return const Color.fromARGB(255, 35, 135, 40); // Normal color
          },
        ),
        elevation: MaterialStateProperty.resolveWith<double>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered)) {
              return 10.0; // Elevate the button on hover
            }
            return 2.0; // Normal elevation
          },
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.all(20),
        ),
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, size: 40, color: Colors.white),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(fontSize: 18, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Clipper for the first curve
class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height * 0.6);

    var firstControlPoint = Offset(size.width * 0.25, size.height * 0.55);
    var firstEndPoint = Offset(size.width * 0.5, size.height * 0.65);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width * 0.75, size.height * 0.75);
    var secondEndPoint = Offset(size.width, size.height * 0.6);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

// Clipper for the second curve
class MySecondClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height * 0.5);

    var firstControlPoint = Offset(size.width * 0.5, size.height * 0.7);
    var firstEndPoint = Offset(size.width, size.height * 0.5);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
