import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/Data_Structure/Simulator/Queues.dart';
import 'package:flutterapp/Data_Structure/Simulator/stacks.dart';
import 'package:flutterapp/main.dart';
import 'Games/Queues_game.dart';
import 'Games/Stacks_game.dart';
import 'learn/stacks_learn.dart'; // For Stacks tutorial page
import 'learn/queue_learn.dart'; // For Queue tutorial page

class DataChoices extends StatefulWidget {
  const DataChoices({Key? key}) : super(key: key);

  @override
  _DataChoices createState() => _DataChoices();
}

class _DataChoices extends State<DataChoices> {
  int _current = 0;
  dynamic _selectedIndex = {};
  var text = "??";

  final List<dynamic> _products = [
    {'title': 'Stacks', 'image': 'assets/Stack_img.png', 'description': ''},
    {'title': 'Queues', 'image': 'assets/Stack_img2.png', 'description': ''},
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
                SizedBox(height: 20), // Tutorial Button
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 0, 195, 255)),
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 255, 255, 255)),
                  ),
                  onPressed: () {
                    if (text == "Stacks") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StacksLearnPage()),
                      );
                    } else if (text == "Queues") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QueueLearnPage()),
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
                SizedBox(height: 20), // Simulation Button
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 35, 209, 0)),
                    foregroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 255, 255, 255)),
                  ),
                  onPressed: () {
                    if (text == "Queues") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QueuesPage()),
                      );
                    } else if (text == "Stacks") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StacksPage()),
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
                SizedBox(height: 20), // Game Button
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 219, 0, 0)),
                    foregroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 255, 255, 255)),
                  ),
                  onPressed: () {
                    if (text == "Queues") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FifoGameApp()),
                      );
                    } else if (text == "Stacks") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TowerOfHanoiApp()),
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
          'Data Structures',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Carousel Slider
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
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
    );
  }
}
