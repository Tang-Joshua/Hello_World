import 'package:flutter/material.dart';

class QueuesPage extends StatefulWidget {
  const QueuesPage({Key? key}) : super(key: key);

  @override
  State<QueuesPage> createState() => _QueuesPageState();
}

class _QueuesPageState extends State<QueuesPage>
    with SingleTickerProviderStateMixin {
  List<int> queue = [];
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
    _tabController.dispose();
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void enqueue() {
    String inputText = _inputController.text.trim();
    if (inputText.isEmpty) {
      _showSnackbar('Input field is empty!');
      return;
    }

    int? number = int.tryParse(inputText);
    if (number == null) {
      _showSnackbar('Invalid input! Please enter a valid number.');
      return;
    }

    setState(() {
      queue.add(number);
      _listKey.currentState?.insertItem(
        queue.length - 1,
        duration: const Duration(milliseconds: 500),
      );
      _visualizationBorderColor = Colors.blueAccent;
    });

    _inputController.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });
  }

  void dequeue() {
    if (queue.isEmpty) {
      _showSnackbar('Nothing to dequeue!');
      return;
    }

    int dequeuedNumber = queue.removeAt(0);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });

    Future.delayed(const Duration(seconds: 1), () {
      _listKey.currentState?.removeItem(
        0,
        (context, animation) =>
            _buildItem(dequeuedNumber, animation, dequeuing: true),
        duration: const Duration(milliseconds: 500),
      );

      setState(() {
        _visualizationBorderColor = Colors.redAccent;
      });
    });
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildItem(int number, Animation<double> animation,
      {bool dequeuing = false}) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        axis: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: dequeuing ? Colors.red : Colors.blueAccent,
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
              style: const TextStyle(fontSize: 20, color: Colors.white),
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
        title: const Text('Queues', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
                      offset: Offset(0, 3)),
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
                        offset: Offset(0, 2)),
                  ],
                ),
                labelPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                tabs: const [
                  Tab(
                    child: Text('Simulate',
                        style: TextStyle(color: Colors.blue, fontSize: 16)),
                  ),
                  Tab(
                    child: Text('I\'ll Take a Shot',
                        style: TextStyle(color: Colors.grey, fontSize: 16)),
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
          const SizedBox(height: 20),
          TextField(
            controller: _inputController,
            decoration: InputDecoration(
              labelText: 'Input',
              labelStyle: const TextStyle(fontSize: 18, color: Colors.grey),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Queue Visualization:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: _visualizationBorderColor, width: 2),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(2, 2)),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 60.0), // Add space above the items
                child: Center(
                  child: AnimatedList(
                    key: _listKey,
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    initialItemCount: queue.length,
                    itemBuilder: (context, index, animation) {
                      return _buildItem(queue[index], animation);
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
                onPressed: enqueue,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Enqueue',
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              ),
              ElevatedButton.icon(
                onPressed: dequeue,
                icon: const Icon(Icons.remove, color: Colors.white),
                label: const Text('Dequeue',
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(
      const MaterialApp(home: QueuesPage(), debugShowCheckedModeBanner: false));
}
// Good