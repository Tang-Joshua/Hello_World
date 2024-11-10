import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/Data_Structure/Queues.dart';
import 'package:flutterapp/Data_Structure/stacks.dart';
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
    {'title': 'Stacks', 'image': 'assets/Stack_img.png', 'description': ''},
    {'title': 'Queues', 'image': 'assets/Stack_img2.png', 'description': ''}
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
          onPressed: () => Navigator.of(context).pop(), // Navigate back
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


  