import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/Data_Structure/Queues.dart';
import 'package:flutterapp/Data_Structure/stacks.dart';
import 'package:flutterapp/main.dart';
import 'Games/Queues_game.dart';
import 'Games/Stacks_game.dart';

class DataChoices extends StatefulWidget {
  const DataChoices({Key? key}) : super(key: key);

  @override
  _DataChoices createState() => _DataChoices();
}

class _DataChoices extends State<DataChoices> {
  int _current = 0;
  dynamic _selectedIndex = {};

  // CarouselController _carouselController = new CarouselController();

  // Define the background colors for each page
  final List<Color> _backgroundColors = [
    const Color.fromARGB(
        255, 255, 205, 202), // Background color for the first page
    const Color.fromARGB(
        255, 193, 255, 195), // Background color for the second page
    Color.fromARGB(255, 152, 240, 255), // Background color for the third page
    // Add more colors if you have more pages
  ];

  var text = "??";

  List<dynamic> _products = [
    {
      'title': 'Stacks',
      'image':
          'data:image/png;base64,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',
      'description': ''
    },
    {
      'title': 'Queues',
      'image':
          'https://cdn.iconscout.com/icon/premium/png-256-thumb/mergesort-11015499-8910886.png',
      'description': ''
    }
  ];

  void _openAnimationDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      // barrierColor: Colors.black38,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation1, animation2) {
        return Container();
      },
      transitionBuilder: (context, a1, a2, widget) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            // title: const Text('Hello'),
            // content: const Text('I am Madhi'),
            content: Column(
              mainAxisSize:
                  MainAxisSize.min, // Make sure content fits within the dialog
              children: [
                // const Text('I am Madhi'),
                SizedBox(height: 20), // Add spacing between content and button
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 0, 195, 255)),
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 255, 255, 255)),
                  ),
                  onPressed: () {
                    // Handle button press if needed
                    Navigator.of(context)
                        .pop(); // Close the dialog on button press
                  },
                  child: Container(
                    width: 230,
                    height: 90,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .start, // Center align the content in the row
                      children: [
                        Image.asset(
                          'assets/Learn.png',
                          width: 40, // Adjust width as needed
                          height: 40, // Adjust height as needed
                        ),
                        SizedBox(width: 8), // Ad
                        Text(
                          'Tutorial',
                          style: TextStyle(fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20), // Adds vertical space
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
                      mainAxisAlignment: MainAxisAlignment
                          .start, // Center align the content in the row
                      children: [
                        Image.asset(
                          'assets/Simulation.png',
                          width: 40, // Adjust width as needed
                          height: 40, // Adjust height as needed
                        ),
                        SizedBox(width: 8), // Ad
                        Text(
                          'Simulation',
                          style: TextStyle(fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                  // Text('START', style: TextStyle(fontSize: 30),),
                  // donut
                ),
                SizedBox(height: 20), // Adds vertical space
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
                        MaterialPageRoute(
                            builder: (context) => CardBattleGame()),
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
                      mainAxisAlignment: MainAxisAlignment
                          .start, // Center align the content in the row
                      children: [
                        Image.asset(
                          'assets/Game.png',
                          width: 40, // Adjust width as needed
                          height: 40, // Adjust height as needed
                        ),
                        SizedBox(width: 8), // Ad
                        Text(
                          'Game',
                          style: TextStyle(fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                  // Text('START', style: TextStyle(fontSize: 30),),
                  // donut
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
      // Set the background color based on the current index
      backgroundColor: _backgroundColors[_current],
      floatingActionButton: _selectedIndex.isNotEmpty
          ? FloatingActionButton(
              onPressed: () => _openAnimationDialog(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_forward_ios),
                  // Text(
                  //   'Tutorial',
                  //   style: TextStyle(fontSize: 12), // Smaller font size to fit
                  // ),
                ],
              ),
            )
          : null,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Data Structure',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
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
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: CarouselSlider(
          carouselController:
              CarouselSliderController(), // Updated to use the controller
          options: CarouselOptions(
            height: 450.0,
            aspectRatio: 16 / 9,
            viewportFraction: 0.70,
            enlargeCenterPage: true,
            pageSnapping: true,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index; // Update the current index
              });
            },
          ),
          items: _products.map((movie) {
            return Builder(
              builder: (BuildContext context) {
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
            );
          }).toList(),
        ),
      ),
    );
  }

// @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // Set the background image based on the current index
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           // Background image
//           Image.asset(
//             _backgroundImages[_current],
//             fit: BoxFit.cover, // Ensure the image covers the whole screen
//           ),
//           // Main content
//           Column(
//             children: [
//               AppBar(
//                 elevation: 0,
//                 backgroundColor: Colors.transparent,
//                 title: Text(
//                   'Sorting Algorithms',
//                   style: TextStyle(
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: Container(
//                   width: double.infinity,
//                   height: double.infinity,
//                   child: CarouselSlider(
//                     carouselController: _carouselController,
//                     options: CarouselOptions(
//                       height: 450.0,
//                       aspectRatio: 16 / 9,
//                       viewportFraction: 0.70,
//                       enlargeCenterPage: true,
//                       pageSnapping: true,
//                       onPageChanged: (index, reason) {
//                         setState(() {
//                           _current = index; // Update the current index
//                         });
//                       },
//                     ),
//                     items: _products.map((movie) {
//                       return Builder(
//                         builder: (BuildContext context) {
//                           return GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 if (_selectedIndex == movie) {
//                                   _selectedIndex = {};
//                                 } else {
//                                   _selectedIndex = movie;
//                                 }
//                               });
//                             },
//                             child: AnimatedContainer(
//                               duration: Duration(milliseconds: 300),
//                               width: MediaQuery.of(context).size.width,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(20),
//                                 border: _selectedIndex == movie
//                                     ? Border.all(
//                                         color: Color.fromARGB(255, 22, 207, 62),
//                                         width: 3,
//                                       )
//                                     : null,
//                                 boxShadow: _selectedIndex == movie
//                                     ? [
//                                         BoxShadow(
//                                           color: Color.fromARGB(255, 70, 155, 129),
//                                           blurRadius: 30,
//                                           offset: Offset(0, 10),
//                                         )
//                                       ]
//                                     : [
//                                         BoxShadow(
//                                           color: Colors.grey.withOpacity(0.2),
//                                           blurRadius: 20,
//                                           offset: Offset(0, 5),
//                                         )
//                                       ],
//                               ),
//                               child: SingleChildScrollView(
//                                 child: Column(
//                                   children: [
//                                     Container(
//                                       height: 320,
//                                       margin: EdgeInsets.only(top: 10),
//                                       clipBehavior: Clip.hardEdge,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(20),
//                                       ),
//                                       child: Image.network(
//                                         movie['image'],
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ),
//                                     SizedBox(height: 20),
//                                     Text(
//                                       movie['title'],
//                                       style: TextStyle(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     SizedBox(height: 20),
//                                     Text(
//                                       movie['description'],
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         color: Colors.grey.shade600,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ),
//               _selectedIndex.isNotEmpty
//                   ? FloatingActionButton(
//                       onPressed: () => _openAnimationDialog(context),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.arrow_forward_ios),
//                           // Uncomment the following line if you want to show text
//                           // Text(
//                           //   'Tutorial',
//                           //   style: TextStyle(fontSize: 12), // Smaller font size to fit
//                           // ),
//                         ],
//                       ),
//                     )
//                   : SizedBox.shrink(),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
}

// Widget buildSheet() => Column(
//   mainAxisAlignment: MainAxisAlignment.start,
  
//   children: [
//     SizedBox(height: 20),
//     TextButton(
//       style: ButtonStyle(
//         backgroundColor:
//             MaterialStateProperty.all<Color>(Color.fromARGB(255, 0, 195, 255)),
//         foregroundColor: MaterialStateProperty.all<Color>(
//             const Color.fromARGB(255, 255, 255, 255)),
//       ),
      
//       onPressed: (){},
//       child: Container(
//         child: Text(
//           'Tutorial',
//           style: TextStyle(fontSize: 30),
//         ),
//         width: 200,
//         height: 50,
//         padding: EdgeInsets.symmetric(horizontal: 16),
//         alignment: Alignment.center,
//       ),
//       // Text('START', style: TextStyle(fontSize: 30),),
//       // donut
//     ),// Adds vertical space
//     SizedBox(height: 20), // Adds vertical space
//     TextButton(
//       style: ButtonStyle(
//         backgroundColor:
//             MaterialStateProperty.all<Color>(Color.fromARGB(255, 35, 209, 0)),
//         foregroundColor: MaterialStateProperty.all<Color>(
//             const Color.fromARGB(255, 255, 255, 255)),
//       ),
//       onPressed: (){},
//       child: Container(
//         child: Text(
//           'Simulation',
//           style: TextStyle(fontSize: 30),
//         ),
//         width: 200,
//         height: 50,
//         padding: EdgeInsets.symmetric(horizontal: 16),
//         alignment: Alignment.center,
//       ),
//       // Text('START', style: TextStyle(fontSize: 30),),
//       // donut
//     ),
//     SizedBox(height: 20), // Adds vertical space
//     TextButton(
//       style: ButtonStyle(
//         backgroundColor:
//             MaterialStateProperty.all<Color>(Color.fromARGB(255, 219, 0, 0)),
//         foregroundColor: MaterialStateProperty.all<Color>(
//             const Color.fromARGB(255, 255, 255, 255)),
//       ),
//       onPressed: () {},
//       child: Container(
//         child: Text(
//           'Game',
//           style: TextStyle(fontSize: 30),
//         ),
//         width: 200,
//         height: 50,
//         padding: EdgeInsets.symmetric(horizontal: 16),
//         alignment: Alignment.center,
//       ),
//       // Text('START', style: TextStyle(fontSize: 30),),
//       // donut
//     ),
//   ],
// );


  