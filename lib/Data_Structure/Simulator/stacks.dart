import 'dart:math';
import 'package:flutter/material.dart';

class StacksPage extends StatefulWidget {
  const StacksPage({Key? key}) : super(key: key);

  @override
  State<StacksPage> createState() => _StacksPageState();
}

class _StacksPageState extends State<StacksPage>
    with SingleTickerProviderStateMixin {
  List<int> stack = [];
  List<int> poppedItems = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  Color _visualizationBorderColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _autoGenerateInput() {
    final random = Random();
    final randomValues = List.generate(5, (_) => random.nextInt(100));
    _inputController.text = randomValues.join(', ');
  }

  void _showInstructions() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Instructions'),
          content: const Text(
            '1. Use the input field to enter numbers (comma or space-separated).\n'
            '2. Press "Push" to add the numbers to the stack.\n'
            '3. Press "Pop" to remove the top number from the stack.\n'
            '4. The auto-generate button creates random input values.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void push() {
    String inputText = _inputController.text.trim();
    if (inputText.isEmpty) {
      setState(() => _visualizationBorderColor = Colors.black);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Input field is empty!')),
      );
      return;
    }

    final numbers = inputText
        .split(RegExp(r'[,\s]+'))
        .where((value) => value.isNotEmpty)
        .map((e) => int.tryParse(e))
        .where((e) => e != null)
        .cast<int>()
        .toList();

    if (numbers.isEmpty) {
      setState(() => _visualizationBorderColor = Colors.black);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Invalid input! Please enter valid numbers.')),
      );
      return;
    }

    setState(() {
      for (final number in numbers) {
        stack.add(number);
        _listKey.currentState?.insertItem(
          stack.length - 1,
          duration: const Duration(milliseconds: 500),
        );
      }
      _visualizationBorderColor = Colors.blueAccent;
    });

    _inputController.clear();

    Future.delayed(const Duration(milliseconds: 500), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });
  }

  void pop() {
    if (stack.isEmpty) {
      setState(() => _visualizationBorderColor = Colors.black);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nothing to pop!')),
      );
      return;
    }

    int poppedNumber = stack.removeLast();
    poppedItems.add(poppedNumber);

    _listKey.currentState?.removeItem(
      stack.length,
      (context, animation) =>
          _buildItem(poppedNumber, animation, popping: true),
      duration: const Duration(milliseconds: 500),
    );

    setState(() => _visualizationBorderColor = Colors.redAccent);
  }

  Widget _buildItem(int number, Animation<double> animation,
      {bool popping = false}) {
    return SizeTransition(
      sizeFactor: animation,
      axis: Axis.vertical,
      child: FadeTransition(
        opacity: animation,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              190.0, 8.0, 0.0, 8.0), //adjust spacing of the box here
          child: Container(
            width: 80,
            height: 80,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: popping ? Colors.red : Colors.blueAccent,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Text(
              number.toString(),
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Stacks',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: _showInstructions,
            icon: const Icon(Icons.help_outline),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                labelPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                tabs: [
                  Tab(
                    child: Text(
                      'Simulate',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSimulateTab(),
          const Center(
            child: Text(
              'This feature is under construction.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimulateTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: _autoGenerateInput,
                icon: const Icon(Icons.auto_awesome, color: Colors.blue),
              ),
              Expanded(
                child: TextField(
                  controller: _inputController,
                  decoration: const InputDecoration(
                    hintText: 'Enter numbers (comma or space-separated)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Stack Visualization:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                decoration: BoxDecoration(
                  border:
                      Border.all(color: _visualizationBorderColor, width: 2),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: AnimatedList(
                    key: _listKey,
                    controller: _scrollController,
                    initialItemCount: stack.length,
                    reverse: true,
                    itemBuilder: (context, index, animation) {
                      return _buildItem(stack[index], animation);
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: push,
                icon: const Icon(Icons.add, color: Colors.white),
                label:
                    const Text('Push', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              ElevatedButton.icon(
                onPressed: pop,
                icon: const Icon(Icons.remove, color: Colors.white),
                label: const Text('Pop', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
