// import 'package:flutter/material.dart';
// import 'hangman.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: HangmanIntroScreen(),
//     );
//   }
// }

// class HangmanIntroScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Radix Sort Hangman"),
//         centerTitle: true,
//         backgroundColor: const Color.fromARGB(255, 100, 72, 34),
//       ),
//       body: Column(
//         children: [
//           // Image container with dark overlay (40% of the screen)
//           Stack(
//             children: [
//               // Image container with dark overlay
//               Container(
//                 height: MediaQuery.of(context).size.height * 0.4, // 40% of screen height
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage('assets/hangman_play.png'), // Replace with your image path
//                     fit: BoxFit.cover,
//                   ),
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(20), // Top left corner radius
//                     topRight: Radius.circular(20), // Top right corner radius
//                   ),
//                 ),
//                 child: Container(
//                   color: Colors.black.withOpacity(0.5), // Darken the image with 50% opacity
//                 ),
//               ),

//               // Title and description placed directly on the image
//               Positioned(
//                 top: MediaQuery.of(context).size.height * 0.1, // Adjust top position as needed
//                 left: 16,
//                 right: 16,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     // Game title "Radix Sort Hangman"
//                     Text(
//                       'Radix Sort Hangman',
//                       style: TextStyle(
//                         fontSize: 36,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                         shadows: [
//                           Shadow(
//                             blurRadius: 10.0,
//                             color: Colors.black.withOpacity(0.6),
//                             offset: Offset(3, 3),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     // Game description
//                     Text(
//                       'Learn Radix Sort in a fun way! Place numbers in the correct order based on digit places while avoiding mistakes.',
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: Colors.white,
//                         shadows: [
//                           Shadow(
//                             blurRadius: 10.0,
//                             color: Colors.black.withOpacity(0.6),
//                             offset: Offset(3, 3),
//                           ),
//                         ],
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),

//           // Panel with Play button (60% of the screen)
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Play Button
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         // Navigate to the Radix Sort Hangman game screen
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => RadixSortScreen()),
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         padding: EdgeInsets.symmetric(vertical: 20),
//                         backgroundColor: const Color.fromARGB(255, 199, 103, 13),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: Text(
//                         'PLAY',
//                         style: TextStyle(fontSize: 29, color: Colors.white),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 20), // Space between the buttons
//                   // Help button (optional, could link to an instruction page or dialog)
//                   IconButton(
//                     icon: Icon(Icons.help_outline, color: Colors.black, size: 36),
//                     onPressed: () {
//                       showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return AlertDialog(
//                             title: Text("How to Play"),
//                             content: Text(
//                               "In Radix Sort Hangman, place numbers based on the current digit place.\n"
//                               "Start with the units place, then tens, and finally hundreds.\n"
//                               "Each correct placement progresses sorting, while each mistake adds a part to the hangman figure.\n"
//                               "Win by fully sorting the numbers; lose if the hangman figure is completed.",
//                             ),
//                             actions: [
//                               TextButton(
//                                 onPressed: () => Navigator.pop(context),
//                                 child: Text("Got it!"),
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }