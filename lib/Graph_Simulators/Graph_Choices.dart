import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';
import 'package:flutterapp/Graph_Simulators/Simulator/binary_search_tree.dart'; // Simulation Page
import 'package:flutterapp/Graph_Simulators/Simulator/breadth_first.dart';
import 'package:flutterapp/Graph_Simulators/Simulator/depth_first.dart';
import 'package:flutterapp/Graph_Simulators/learn/binary_search_learn.dart'; // Tutorial Page
import 'package:flutterapp/main.dart';
import 'Games/Depth_game.dart';
import 'package:flutterapp/Graph_Simulators/learn/depth_search_learn.dart';
import 'package:flutterapp/Graph_Simulators/learn/breadth_search_learn.dart';
import 'Games/Binary_Breadth_Game.dart';
import 'Games/Binary_Search_Tree_Game.dart';

class GraphChoices extends StatefulWidget {
  const GraphChoices({Key? key}) : super(key: key);

  @override
  _GraphChoices createState() => _GraphChoices();
}

class _GraphChoices extends State<GraphChoices> {
  int _current = 0;
  dynamic _selectedIndex = {};
  var text = "??";

  final List<dynamic> _products = [
    {
      'title': 'Binary Search Tree',
      'image': 'assets/Tree_img.png',
      'description': '',
    },
    {
      'title': 'Breadth First',
      'image': 'assets/Tree_img2.png',
      'description': '',
    },
    {
      'title': 'Depth First',
      'image': 'assets/Tree_img3.png',
      'description': '',
    },
  ];

  void _openAnimationDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation1, animation2) {
        return Container();
      },
      transitionBuilder: (context, a1, a2, widget) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 0, 195, 255)),
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 255, 255, 255)),
                  ),
                  onPressed: () {
                    if (text == "Binary Search Tree") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BinarySearchLearnPage()),
                      );
                    } else if (text == "Depth First") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DepthFirstLearnPage()),
                      );
                    } else if (text == "Breadth First") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BreadthFirstLearnPage()),
                      );
                    }
                  },
                  child: Container(
                    width: 230,
                    height: 90,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/Learn.png',
                          width: 40,
                          height: 40,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Tutorial',
                          style: TextStyle(fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 35, 209, 0)),
                    foregroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 255, 255, 255)),
                  ),
                  onPressed: () {
                    if (text == "Binary Search Tree") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BinarySearchPage()),
                      );
                    } else if (text == "Breadth First") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BreadthFirstPage()),
                      );
                    } else if (text == "Depth First") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DepthFirstPage()),
                      );
                    }
                  },
                  child: Container(
                    width: 230,
                    height: 90,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/Simulation.png',
                          width: 40,
                          height: 40,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Simulation',
                          style: TextStyle(fontSize: 28),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 219, 0, 0)),
                    foregroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 255, 255, 255)),
                  ),
                  onPressed: () {
                    if (text == "Binary Search Tree") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BinarySearchTreeGameApp()),
                      );
                    } else if (text == "Breadth First") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StarGameApp()),
                      );
                    } else if (text == "Depth First") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DepthGamePage()),
                      );
                    }
                  },
                  child: Container(
                    width: 230,
                    height: 90,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/Game.png',
                          width: 40,
                          height: 40,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Game',
                          style: TextStyle(fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide.none,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MyApp()),
              (route) => false,
            );
          },
        ),
        title: Text(
          'Graph Algorithms',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Stack(
        children: [
          // Main Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CarouselSlider.builder(
                options: CarouselOptions(
                  height: 450.0,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.75,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
                itemCount: _products.length,
                itemBuilder: (BuildContext context, int index, int realIdx) {
                  var movie = _products[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_selectedIndex == movie) {
                          _selectedIndex = {};
                        } else {
                          _selectedIndex = movie;
                        }
                        text = movie['title'];
                      });
                      _openAnimationDialog(context);
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: _selectedIndex == movie
                            ? Border.all(
                                color: Color.fromARGB(255, 22, 207, 62),
                                width: 3,
                              )
                            : null,
                        boxShadow: _selectedIndex == movie
                            ? [
                                BoxShadow(
                                  color: Color.fromARGB(255, 70, 155, 129),
                                  blurRadius: 30,
                                  offset: Offset(0, 10),
                                )
                              ]
                            : [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 20,
                                  offset: Offset(0, 5),
                                )
                              ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 320,
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  movie['image'],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            movie['title'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),

              // Centered Page Indicator Dots
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _products.length,
                    (index) => Container(
                      width: 8.0,
                      height: 8.0,
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _current == index ? Colors.green : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Wave Background at the Bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 200,
              child: WaveWidget(
                config: CustomConfig(
                  gradients: [
                    [Colors.yellow.shade200, Colors.yellow.shade200],
                    [Colors.amber.shade300, Colors.amber.shade300],
                  ],
                  durations: [25000, 18000],
                  heightPercentages: [0.2, 0.25],
                  gradientBegin: Alignment.bottomLeft,
                  gradientEnd: Alignment.topRight,
                ),
                waveAmplitude: 10,
                size: const Size(double.infinity, double.infinity),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
