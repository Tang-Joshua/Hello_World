import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/Graph_Simulators/binary_search_tree.dart'; // Simulation Page
import 'package:flutterapp/Graph_Simulators/breadth_first.dart';
import 'package:flutterapp/Graph_Simulators/depth_first.dart';
import 'package:flutterapp/Graph_Simulators/learn/binary_search_learn.dart'; // Tutorial Page
import 'package:flutterapp/main.dart';
import 'Depth_game.dart';

class GraphChoices extends StatefulWidget {
  const GraphChoices({Key? key}) : super(key: key);

  @override
  _GraphChoices createState() => _GraphChoices();
}

class _GraphChoices extends State<GraphChoices> {
  int _current = 0;
  dynamic _selectedIndex = {};

  final List<Color> _backgroundColors = [
    const Color.fromARGB(255, 255, 205, 202),
    const Color.fromARGB(255, 193, 255, 195),
    const Color.fromARGB(255, 152, 240, 255),
  ];

  var text = "??";

  List<dynamic> _products = [
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
                // Tutorial Button
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
                // Simulation Button
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
                          style: TextStyle(fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                ),
                // Game Button (Placeholder or Other Future Feature)
                SizedBox(height: 20),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 219, 0, 0)),
                    foregroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 255, 255, 255)),
                  ),
                  onPressed: () {
                    // Placeholder for future game functionality
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
      backgroundColor: Colors.white, // Set background to pure white
      floatingActionButton: _selectedIndex.isNotEmpty
          ? FloatingActionButton(
              onPressed: () => _openAnimationDialog(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            )
          : null,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // Black arrow icon
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MyApp()),
              (route) => false,
            );
          }, // Navigate back
        ),
        title: Text(
          'Sorting Algorithms',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: CarouselSlider.builder(
          carouselController: CarouselSliderController(),
          options: CarouselOptions(
            height: 450.0,
            aspectRatio: 16 / 9,
            viewportFraction: 0.70,
            enlargeCenterPage: true,
            pageSnapping: true,
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
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: MediaQuery.of(context).size.width,
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 320,
                        margin: EdgeInsets.only(top: 10),
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Image.network(
                          movie['image'],
                          fit: BoxFit.cover,
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
                      SizedBox(height: 20),
                      Text(
                        movie['description'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
