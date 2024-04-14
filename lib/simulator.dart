import 'package:flutter/material.dart';

import 'package:flutterapp/radix.dart';
import 'package:flutterapp/insertion.dart';
import 'package:flutterapp/merge.dart';

import 'package:flutterapp/breadth_first.dart';
import 'package:flutterapp/depth_first.dart';
import 'package:flutterapp/binary_search_tree.dart';

import 'package:flutterapp/stacks.dart';
import 'package:flutterapp/Queues.dart';


class simPage extends StatefulWidget {
  const simPage({super.key});

  @override
  State<simPage> createState() => _simPageState();
}

class _simPageState extends State<simPage> {
  // Constants for the heights of the first ListView in portrait and landscape orientations
  static const double _portraitListViewHeight = 600;
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
    List<String> categories = ['Sorting Algorithms', 'Graph Algorithms', 'Data Structures'];
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
        Center( // Wrap the category's Column with Center
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
      "Palagay ng explanation ni Radix Sort.";

  void click() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => radixPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0), // Adjust the value as needed
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
        )
      );
  }
}

class merge extends StatefulWidget {
  const merge({super.key});

  @override
  State<merge> createState() => _mergeState();
}

class _mergeState extends State<merge> {
  String text =
      "Palagay ng explanation ni Merge Sort.";

  void click() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => mergePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0), // Adjust the value as needed
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
        )
      );
  }
}

class insertion extends StatefulWidget {
  const insertion({super.key});

  @override
  State<insertion> createState() => _insertionState();
}

class _insertionState extends State<insertion> {
  String text =
      "Palagay ng explanation ni Insertion Sort.";

  void click() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => InsertionSortPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0), // Adjust the value as needed
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
        )
      );
  }
}

class binary_search extends StatefulWidget {
  const binary_search({super.key});

  @override
  State<binary_search> createState() => _binary_searchState();
}

class _binary_searchState extends State<binary_search> {
  String text =
      "Palagay ng explanation ni Binary Search Tree.";

  void click() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => BinarySearchPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0), // Adjust the value as needed
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
        )
      );
  }
}

class breadth_first extends StatefulWidget {
  const breadth_first({super.key});

  @override
  State<breadth_first> createState() => _breadth_firstState();
}

class _breadth_firstState extends State<breadth_first> {
  String text =
      "Palagay ng explanation ni Breadth-first Algorithm.";

  void click() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => BreadthFirstPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0), // Adjust the value as needed
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
        )
      );
  }
}

class depth_first extends StatefulWidget {
  const depth_first({super.key});

  @override
  State<depth_first> createState() => _depth_firstState();
}

class _depth_firstState extends State<depth_first> {
  String text =
      "Palagay ng explanation ni Depth-First Algorithm.";

  void click() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => DepthFirstPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0), // Adjust the value as needed
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
        )
      );
  }
}


class stacks extends StatefulWidget {
  const stacks({super.key});

  @override
  State<stacks> createState() => _stacksState();
}

class _stacksState extends State<stacks> {
  String text =
      "Palagay ng explanation ni Stacks.";

  void click() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => StacksPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0), // Adjust the value as needed
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
        )
      );
  }
}

class Queues extends StatefulWidget {
  const Queues({super.key});

  @override
  State<Queues> createState() => _QueuesState();
}

class _QueuesState extends State<Queues> {
  String text =
      "Palagay ng explanation ni Queues.";

  void click() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => QueuesPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0), // Adjust the value as needed
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
        )
      );
  }
}