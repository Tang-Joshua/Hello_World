import 'package:flutter/material.dart';

import 'package:flutterapp/Sorting_Simulators/Simulator/radix.dart';
import 'package:flutterapp/Sorting_Simulators/Simulator/insertion.dart';
import 'package:flutterapp/Sorting_Simulators/Simulator/merge.dart';

import 'package:flutterapp/Graph_Simulators/Simulator/breadth_first.dart';
import 'package:flutterapp/Graph_Simulators/Simulator/depth_first.dart';
import 'package:flutterapp/Graph_Simulators/Simulator/binary_search_tree.dart';

import 'package:flutterapp/Data_Structure/Simulator/stacks.dart';
import 'package:flutterapp/Data_Structure/Simulator/Queues.dart';

// import 'package:flutterapp/image.dart';

class simPage extends StatefulWidget {
  const simPage({super.key});

  @override
  State<simPage> createState() => _simPageState();
}

class _simPageState extends State<simPage> {
  // Constants for the heights of the first ListView in portrait and landscape orientations
  static const double _portraitListViewHeight = 725;
  static const double _landscapeListViewHeight = 800;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AL-GO!')),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Simulators',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  height: _getFirstListViewHeight(orientation),
                  child: ListView.builder(
                    scrollDirection: orientation == Orientation.portrait
                        ? Axis.vertical
                        : Axis.horizontal,
                    itemCount: 3, // Three categories
                    itemBuilder: (context, categoryIndex) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: _buildCategoryWidget(categoryIndex),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  double _getFirstListViewHeight(Orientation orientation) {
    // Return different height based on orientation
    return orientation == Orientation.portrait
        ? _portraitListViewHeight
        : _landscapeListViewHeight;
  }

  Widget _buildCategoryWidget(int categoryIndex) {
    // Define your category widgets here
    List<String> categories = [
      'Sorting Algorithms',
      'Graph Algorithms',
      'Data Structures'
    ];
    List<List<Widget>> categoryWidgets = [
      [
        radix(),
        merge(),
        insertion(),
      ],
      [
        breadth_first(),
        depth_first(),
      ],
      [
        stacks(),
        Queues(),
        binary_search(),
      ],
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            categories[categoryIndex],
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Center(
          // Wrap the category's Column with Center
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: categoryWidgets[categoryIndex],
          ),
        ),
      ],
    );
  }
}

// Widget _buildSimulatorWidget(int index) {
//   // Define your simulator widgets here
//   List<Widget> simulators = [
//     radix(),
//     merge(),
//     insertion(),
//     binary_search(),
//     breadth_first(),
//     depth_first(),
//     stacks(),
//     Queues(),
//   ];

//   return simulators[index];
// }

class radix extends StatefulWidget {
  const radix({super.key});

  @override
  State<radix> createState() => _radixState();
}

class _radixState extends State<radix> {
  String text =
      "Radix sort is a non-comparative sorting algorithm that sorts integers by processing their digits from the least significant to the most significant, efficiently arranging them into the correct order.";

  void click() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RadixSortPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(
                  0, 10, 0, 0), // Adjust the value as needed
              child: Text(
                "Radix Sort",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: 300,
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.greenAccent),
              child: Text(
                text,
                style: TextStyle(fontSize: 14),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 65, 65, 71)),
                foregroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 255, 255, 255)),
              ),
              onPressed: this.click,
              child: Container(
                child: Text(
                  'Enter',
                  style: TextStyle(fontSize: 15),
                ),
                width: 150,
                padding: EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
              ),
            ),
          ],
        ));
  }
}

class merge extends StatefulWidget {
  const merge({super.key});

  @override
  State<merge> createState() => _mergeState();
}

class _mergeState extends State<merge> {
  String text =
      "Merge sort is a comparison-based sorting algorithm that divides the unsorted list into smaller sublists, recursively sorts them, and then merges the sorted sublists to produce a sorted output.";

  void click() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MergeSortPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(
                  0, 10, 0, 0), // Adjust the value as needed
              child: Text(
                "Merge Sort",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: 300,
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.greenAccent),
              child: Text(
                text,
                style: TextStyle(fontSize: 14),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 65, 65, 71)),
                foregroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 255, 255, 255)),
              ),
              onPressed: this.click,
              child: Container(
                child: Text(
                  'Enter',
                  style: TextStyle(fontSize: 15),
                ),
                width: 150,
                padding: EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
              ),
            ),
          ],
        ));
  }
}

class insertion extends StatefulWidget {
  const insertion({super.key});

  @override
  State<insertion> createState() => _insertionState();
}

class _insertionState extends State<insertion> {
  String text =
      "Insertion sort is a simple sorting algorithm that builds the final sorted list one element at a time by repeatedly inserting the next element into the proper position in the already sorted part of the list.";

  void click() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => InsertionSortPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(
                  0, 10, 0, 0), // Adjust the value as needed
              child: Text(
                "Insertion Sort",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: 300,
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.greenAccent),
              child: Text(
                text,
                style: TextStyle(fontSize: 14),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 65, 65, 71)),
                foregroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 255, 255, 255)),
              ),
              onPressed: this.click,
              child: Container(
                child: Text(
                  'Enter',
                  style: TextStyle(fontSize: 15),
                ),
                width: 150,
                padding: EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
              ),
            ),
          ],
        ));
  }
}

class binary_search extends StatefulWidget {
  const binary_search({super.key});

  @override
  State<binary_search> createState() => _binary_searchState();
}

class _binary_searchState extends State<binary_search> {
  String text =
      "Binary search trees (BSTs) are a data structure that organizes elements in a tree-like structure, where each node has at most two children and the left child is less than the parent, while the right child is greater, enabling efficient search, insertion, and deletion operations.";

  void click() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => BinarySearchPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(
                  0, 10, 0, 0), // Adjust the value as needed
              child: Text(
                "Binary Search Tree",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: 300,
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.greenAccent),
              child: Text(
                text,
                style: TextStyle(fontSize: 14),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 65, 65, 71)),
                foregroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 255, 255, 255)),
              ),
              onPressed: this.click,
              child: Container(
                child: Text(
                  'Enter',
                  style: TextStyle(fontSize: 15),
                ),
                width: 150,
                padding: EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
              ),
            ),
          ],
        ));
  }
}

class breadth_first extends StatefulWidget {
  const breadth_first({super.key});

  @override
  State<breadth_first> createState() => _breadth_firstState();
}

class _breadth_firstState extends State<breadth_first> {
  String text =
      "Breadth-first search (BFS) is a graph traversal algorithm that explores all neighbor nodes at the present depth prior to moving on to the nodes at the next depth level.";

  void click() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => BreadthFirstPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(
                  0, 10, 0, 0), // Adjust the value as needed
              child: Text(
                "Breadth-first Algorithm",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: 300,
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.greenAccent),
              child: Text(
                text,
                style: TextStyle(fontSize: 14),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 65, 65, 71)),
                foregroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 255, 255, 255)),
              ),
              onPressed: this.click,
              child: Container(
                child: Text(
                  'Enter',
                  style: TextStyle(fontSize: 15),
                ),
                width: 150,
                padding: EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
              ),
            ),
          ],
        ));
  }
}

class depth_first extends StatefulWidget {
  const depth_first({super.key});

  @override
  State<depth_first> createState() => _depth_firstState();
}

class _depth_firstState extends State<depth_first> {
  String text =
      "Depth-first search (DFS) is a graph traversal algorithm that explores as far as possible along each branch before backtracking.";

  void click() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DepthFirstPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(
                  0, 10, 0, 0), // Adjust the value as needed
              child: Text(
                "Depth-First Algorithm",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: 300,
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.greenAccent),
              child: Text(
                text,
                style: TextStyle(fontSize: 14),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 65, 65, 71)),
                foregroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 255, 255, 255)),
              ),
              onPressed: this.click,
              child: Container(
                child: Text(
                  'Enter',
                  style: TextStyle(fontSize: 15),
                ),
                width: 150,
                padding: EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
              ),
            ),
          ],
        ));
  }
}

class stacks extends StatefulWidget {
  const stacks({super.key});

  @override
  State<stacks> createState() => _stacksState();
}

class _stacksState extends State<stacks> {
  String text =
      "Stacks are a data structure that follows the Last In, First Out (LIFO) principle, where elements are inserted and removed from the same end, typically used for managing function calls, parsing expressions, and backtracking.";

  void click() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => StacksPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(
                  0, 10, 0, 0), // Adjust the value as needed
              child: Text(
                "Stacks",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: 300,
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.greenAccent),
              child: Text(
                text,
                style: TextStyle(fontSize: 14),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 65, 65, 71)),
                foregroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 255, 255, 255)),
              ),
              onPressed: this.click,
              child: Container(
                child: Text(
                  'Enter',
                  style: TextStyle(fontSize: 15),
                ),
                width: 150,
                padding: EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
              ),
            ),
          ],
        ));
  }
}

class Queues extends StatefulWidget {
  const Queues({super.key});

  @override
  State<Queues> createState() => _QueuesState();
}

class _QueuesState extends State<Queues> {
  String text =
      "Queues are a data structure that follows the First In, First Out (FIFO) principle, where elements are inserted at the rear and removed from the front, commonly used in task scheduling, breadth-first search, and implementing caches.";

  void click() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => QueuesPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(
                  0, 10, 0, 0), // Adjust the value as needed
              child: Text(
                "Queues",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: 300,
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.greenAccent),
              child: Text(
                text,
                style: TextStyle(fontSize: 14),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 65, 65, 71)),
                foregroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 255, 255, 255)),
              ),
              onPressed: this.click,
              child: Container(
                child: Text(
                  'Enter',
                  style: TextStyle(fontSize: 15),
                ),
                width: 150,
                padding: EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
              ),
            ),
          ],
        ));
  }
}

// HomePage

class img extends StatefulWidget {
  const img({super.key});

  @override
  State<img> createState() => _imgState();
}

class _imgState extends State<img> {
  String text = "Palagay ng explanation ni img.";

  void click() {
    // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(
                  0, 10, 0, 0), // Adjust the value as needed
              child: Text(
                "img",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: 300,
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.greenAccent),
              child: Text(
                text,
                style: TextStyle(fontSize: 14),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 65, 65, 71)),
                foregroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 255, 255, 255)),
              ),
              onPressed: this.click,
              child: Container(
                child: Text(
                  'Enter',
                  style: TextStyle(fontSize: 15),
                ),
                width: 150,
                padding: EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
              ),
            ),
          ],
        ));
  }
}
