// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:camera/camera.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';



// enum NodePlacement { Left, Right }

// int? firstInput; // Global variable to store the first inputted value

// class TreeNode {
//   String? originalValue; // Store the original input value
//   String? editableValue; // Store the value that can be edited
//   int value; // Numeric equivalent used for sorting and operations
//   TreeNode? left;
//   TreeNode? right;
//   int index; // Unique index for each node
//   bool isCorrectlyPositioned = true; // Track if node is correctly positioned
//   String? rootValue; // Field to store the root node value
//   Color? color;

//   TreeNode(this.originalValue, this.value, this.index, {this.rootValue})
//       : editableValue = originalValue; 
      
  
  
//   TreeNode? findParent(int index) {
//     if ((left != null && left!.index == index) || (right != null && right!.index == index)) {
//       return this; // If either left or right child has the given index, return this node as the parent
//     }
//     // Recursively search in the left subtree
//     if (left != null) {
//       TreeNode? leftParent = left!.findParent(index);
//       if (leftParent != null) {
//         return leftParent;
//       }
//     }
//     // Recursively search in the right subtree
//     if (right != null) {
//       TreeNode? rightParent = right!.findParent(index);
//       if (rightParent != null) {
//         return rightParent;
//       }
//     }
//     return null; // Return null if the node with the given index is not found in the subtree rooted at this node
//   }


//   // Method to remove a child node with a given index
//   void removeChild(int index) {
//     if (left?.index == index) {
//       left = null;
//     } else if (right?.index == index) {
//       right = null;
//     } else {
//       // Handle error: Child with the given index not found
//     }
//   }

//   // Method to add a child node
//   void addChild(TreeNode child) {
//     if (left == null) {
//       left = child;
//     } else if (right == null) {
//       right = child;
//     } else {
//       // Handle error: Both children are already occupied
//     }
//   }

//   // Method to perform an in-order traversal and flatten the tree into a list
//   List<TreeNode> flattenInOrder() {
//   List<TreeNode> result = [];
//   if (left != null) {
//     result.addAll(left!.flattenInOrder());
//   }
//   result.add(this);
//   if (right != null) {
//     result.addAll(right!.flattenInOrder());
//   }
//   return result;
// }
// // Initialize editableValue with originalValue
// }



// class BinarySearchPage extends StatefulWidget {
//   const BinarySearchPage({Key? key}) : super(key: key);

//   @override
//   _BinarySearchPageState createState() => _BinarySearchPageState();
// }

// class TreePainter extends CustomPainter {
//   final TreeNode? root;

//   static const double nodeSize = 30.0;
//   static const double levelSpacing = 60.0;

//   TreePainter(this.root);

//   @override
//   void paint(Canvas canvas, Size size) {
//     if (root != null) {
//       _paintNode(canvas, root!, size.width / 2, 0, size.width);
//     }
//   }

//   void _paintNode(Canvas canvas, TreeNode node, double x, double y, double width) {
//     // Draw node
//     Paint fillPaint = Paint();
//     fillPaint.color = node.color ?? Color.fromARGB(255, 86, 209, 254);
//     canvas.drawCircle(Offset(x, y), nodeSize / 2, fillPaint);
//     canvas.drawCircle(Offset(x, y), nodeSize / 2, Paint()..style = PaintingStyle.stroke ..color = Colors.black);
//     TextSpan span = TextSpan(style: TextStyle(color: Colors.black), text: node.originalValue);
//     TextPainter tp = TextPainter(text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
//     tp.layout();
//     tp.paint(canvas, Offset(x - tp.width / 2, y - tp.height / 2));

//     // Draw edges
//     if (node.left != null) {
//       double childX = x - width / 4;
//       double childY = y + levelSpacing;
//       canvas.drawLine(Offset(x, y + nodeSize / 2), Offset(childX, childY - nodeSize / 2), Paint()..color = Colors.black);
//       _paintNode(canvas, node.left!, childX, childY, width / 2);
//     }
//     if (node.right != null) {
//       double childX = x + width / 4;
//       double childY = y + levelSpacing;
//       canvas.drawLine(Offset(x, y + nodeSize / 2), Offset(childX, childY - nodeSize / 2), Paint()..color = Colors.black);
//       _paintNode(canvas, node.right!, childX, childY, width / 2);
//     }
//   }

//   @override
//   bool shouldRepaint(covariant TreePainter oldDelegate) {
//     return true; // You could add a more complex condition based on your needs
//   }
// }




// class _BinarySearchPageState extends State<BinarySearchPage> with WidgetsBindingObserver  {

//   TreeNode? _root;
//   TextEditingController _numberController = TextEditingController();
//   List<int> _nodeValues = []; // New list to store node values
//    // Variable to store the first inputted value
//   List<TreeNode> _nodes = []; // Define _nodes list to store nodes of the binary search tree

  
//   CameraController? _cameraController;
//   bool _isCameraInitialized = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//     WidgetsBinding.instance.addObserver(this);  // Listen to app lifecycle changes
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);  // Stop listening to lifecycle changes
//     _cameraController?.dispose();
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (!mounted) return;
//     if (state == AppLifecycleState.inactive) {
//       _cameraController?.dispose();
//     } else if (state == AppLifecycleState.resumed) {
//       if (_cameraController != null) {
//         _initializeCamera();
//       }
//     }
//   }
  
//   void _initializeCamera() async {
//     final cameras = await availableCameras();
//     final firstCamera = cameras.first;
//     _cameraController = CameraController(firstCamera, ResolutionPreset.high);
    
//     try {
//       await _cameraController!.initialize();
//       if (!mounted) return;
//       setState(() {
//         _isCameraInitialized = true;
//       });
//     } catch (e) {
//       print("Camera initialization error: $e");
//     }
//   }




//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Binary Search Algorithm'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               controller: _numberController,
//               keyboardType: TextInputType.text,
//               inputFormatters: [
//                 FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Allow only numbers
//               ],
//               decoration: InputDecoration(
//                 labelText: 'Enter values (Numbers Only)',
//               ),
//             ),
//             SizedBox(height: 10), // Add spacing between the TextField and buttons
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center, // Align the buttons to the center
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     if (_root == null) {
//                       insertNodeAsRoot();
//                       _numberController.clear(); // Clear input after inserting root
//                     } else {
//                       showInsertModal();
//                     }
//                   },
//                   child: Text('Insert'),
//                 ),
//                 SizedBox(width: 22),
//                 ElevatedButton(
//                   onPressed: () {
//                     showEditNodeModal();
//                   },
//                   child: Text('Edit /  Delete'),
//                 ), 
//                 SizedBox(width: 22),// Space between Insert and Clear Tree buttons
//                 ElevatedButton(
//                   onPressed: () {
//                     clearTree();
//                   },
//                   child: Text('Clear Tree'),
//                 ),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                       showCamera();
//                   },
//                   child: Text('Import Through Image'),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Given: $_nodeValues',
//               style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold, // Making the text bold
//                         fontSize: 16, // Increasing the font size
//                       ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 30),
//             Expanded(
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.vertical,
//                 child: Container(
//                   margin: EdgeInsets.only(top: 25),
//                   child: _root != null
//                       ? CustomPaint(
//                           size: Size(300, 300),
//                           painter: TreePainter(_root!),
//                         )
//                       : Center(
//                           child: Text('No tree built yet'),
//                         ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     checkTree();
//                   },
//                   child: Text('Check'),
//                 ),
//                 Visibility(
//                   visible: !_isTreeSorted || _isAnyNodeIncorrect,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       sortTree();
//                     },
//                     child: Text('Sort'),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16),
//             Text(
//               !_isAnyNodeIncorrect ? 'Binary Tree is in correct format' : 'Binary Tree is not sorted',
//               style: TextStyle(color: !_isAnyNodeIncorrect? Colors.green : Colors.red,
//                                 fontWeight: FontWeight.bold,
//               fontSize: 16,),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

// void showCamera() {
//   if (!_isCameraInitialized) {
//     print('Camera is not initialized.');
//     return;
//   }

//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('Capture Text'),
//         content: Container(
//           width: double.maxFinite,  // Takes the full width of the dialog
//           height: 300,  // Adjust height to fit your needs
//           child: CameraPreview(_cameraController!),
//         ),
//         actions: <Widget>[
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 child: Text('Images'),
//               ),
//               TextButton(
//                 onPressed: () async {
//                   try {
//                     // Ensure the camera is focused before capturing the image.
//                     await _cameraController!.setFocusMode(FocusMode.auto);
//                     await Future.delayed(Duration(seconds: 2)); // Wait for focus to settle.
//                     _captureAndRecognizeText();
//                   } catch (e) {
//                     print("Error focusing camera: $e");
//                   }
//                   Navigator.of(context).pop();  // Close the dialog after capturing the text
//                 },
//                 child: Text('Capture Text'),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 child: Text('Cancel'),
//               ),
//             ],
//           ),
//         ],
//       );
//     },
//   );
// }



// void _showPositionDialog() {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('Select Position'),
//         content: DropdownButtonFormField<NodePlacement>(
//           value: NodePlacement.Left, // Default value
//           items: [
//             DropdownMenuItem(
//               value: NodePlacement.Left,
//               child: Text('Left'),
//             ),
//             DropdownMenuItem(
//               value: NodePlacement.Right,
//               child: Text('Right'),
//             ),
//           ],
//           onChanged: (value) {
//             // Handle user selection
//             Navigator.of(context).pop(value); // Close the dialog and pass back the selected value
//           },
//         ),
//       );
//     },
//   ).then((selectedPosition) {
//     if (selectedPosition != null) {
//       // Insert node based on the selected position
//       _insertNodeAfterRoot(selectedPosition);
//     }
//   });
// }




// void _insertNodeAfterRoot(NodePlacement position) {
//   final input = _numberController.text.trim();
//   if (input.isNotEmpty) {
//     int? value = int.tryParse(input);
//     if (value != null) {
//       int newIndex = _root!.index * 2 + (position == NodePlacement.Left ? 1 : 2); // Calculate the new index for the node
//       TreeNode newNode = TreeNode(input, value, newIndex, rootValue: _root!.originalValue);
//       if (position == NodePlacement.Left) {
//         _root!.left = newNode;
//       } else {
//         _root!.right = newNode;
//       }
//       setState(() {});
//     } else {
//       // Handle error: input is not a valid integer
//     }
//   }
// }



// void showEditNodeModal() {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('Select Node to Edit'),
//         content: DropdownButtonFormField<TreeNode>(
//           value: null,
//           items: getSelectableNodes()
//               .map((node) => DropdownMenuItem(
//                     value: node,
//                     child: Text('Node: ${node.originalValue}'),
//                   ))
//               .toList(),
//           onChanged: (selectedNode) {
//             if (selectedNode != null) {
//               Navigator.pop(context); // Close the first modal
//               showEditModal(selectedNode);
//             }
//           },
//         ),
//       );
//     },
//   );
// }

// void showEditModal(TreeNode node) {
//   String? newValue = node.editableValue;

//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return StatefulBuilder(
//         builder: (context, setState) {
//           return AlertDialog(
//             title: Text('Edit Node: ${node.originalValue}'),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 SizedBox(height: 10),
//                 TextField(
//                   onChanged: (value) {
//                     newValue = value; // Directly update local variable
//                   },
//                   controller: TextEditingController(text: newValue ?? ''), // Handle null with empty string default
//                   decoration: InputDecoration(
//                     labelText: 'New Value',
//                   ),
//                 ),
//               ],
//             ),
//             actions: [
//               ElevatedButton(
//                 onPressed: () {
//                   // Ensure newValue is not null and has changed before updating
//                   if (newValue != null && newValue != node.editableValue) {
//                     setState(() {
//                       int? parsedValue = int.tryParse(newValue!); // Safely parse the integer value from newValue
//                       if (parsedValue != null) {
//                         // Call updateNodeByIndex to update the node in the tree
//                         updateNodeByIndex(_root, node.index, parsedValue);
//                         // Update the corresponding entry in the node values list
//                         if (node.index < _nodeValues.length) {
//                           _nodeValues[node.index] = parsedValue;
//                         }
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                           content: Text("Failed to parse the new value: $newValue"),
//                           backgroundColor: Colors.red,
//                         ));
//                       }
//                     });
//                   }
//                   Navigator.pop(context); // Close the edit modal
//                 },
//                 child: Text('Save'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     // Remove the selected node from its parent's children list
//                     TreeNode? parent = _root?.findParent(node.index);
//                     if (parent != null) {
//                       parent.removeChild(node.index);
//                     } else {
//                       // If the selected node is the root and has children, set a new root
//                       _root = (node.left != null || node.right != null) ? (node.left ?? node.right) : null;
//                     }

//                     // Remove the selected node from the node values list
//                     _nodeValues.remove(node.value);

//                     // Update node values list without rearranging
//                     _nodeValues = _nodeValues.where((value) => value != node.value).toList();
//                   });
//                   _updateTree();
//                   Navigator.pop(context); // Close the edit modal
//                 },
//                 child: Text('Delete')
//               )


//             ],
//           );
//         },
//       );
//     },
//   );
// }


// void _updateTree() {
//   setState(() {});
// }


// void updateNodeByIndex(TreeNode? node, int index, int newValue) {
//   if (node == null) return;
//   if (node.index == index) {
//     node.originalValue = newValue.toString();
//     node.editableValue = newValue.toString();
//     node.value = newValue;  // Ensure to update the node's value as well
//     setState(() {});  // Trigger a rebuild to refresh the UI
//     return;
//   }
//   updateNodeByIndex(node.left, index, newValue);
//   updateNodeByIndex(node.right, index, newValue);
// }









// int? _convertToInteger(String value) {
//   // Convert letters to their corresponding values
//   if (RegExp(r'^[a-z]+$').hasMatch(value)) {
//     return value.codeUnitAt(0) - 'a'.codeUnitAt(0) + 1;
//   } else {
//     return int.tryParse(value);
//   }
// }

// bool _isValidInput(String value) {
//   // Check if the value is a valid number
//   return RegExp(r'^[0-9]*$').hasMatch(value);
// }











//   bool _isTreeSorted = true; // Variable to track if the tree is sorted
//   bool _isAnyNodeIncorrect = false;

// void checkTree() {
//   // Construct the correct binary search tree
//   TreeNode? correctTreeRoot = constructCorrectTree();

//   // Compare the user-made tree with the correct tree and update node colors
//   compareAndColorNodes(_root, correctTreeRoot);

//   bool anyNodeIncorrect = checkIfAnyNodeIncorrect(_root);

//   setState(() {
//     // Check if the user-made tree is sorted
//     _isTreeSorted = _checkTreeSorted(_root);
//     _isAnyNodeIncorrect = anyNodeIncorrect;
//   });
// }

// bool checkIfAnyNodeIncorrect(TreeNode? node) {
//   if (node == null) return false;

//   // Check if the current node is marked as incorrect
//   if (node.color == Colors.red) {
//     return true; // If marked as incorrect, return true
//   }

//   // Recursively check left and right subtrees
//   return checkIfAnyNodeIncorrect(node.left) || checkIfAnyNodeIncorrect(node.right);
// }

// TreeNode? constructCorrectTree() {
//   TreeNode? correctRoot;

//   // Iterate through _nodeValues to construct the correct binary search tree
//   for (int value in _nodeValues) {
//     if (correctRoot == null) {
//       // If the correct root is null, create it with the first value
//       correctRoot = TreeNode(value.toString(), value, 0);
//     } else {
//       // Otherwise, insert the value into the correct tree
//       insertValueIntoCorrectTree(correctRoot, value);
//     }
//   }

//   return correctRoot;
// }

// void insertValueIntoCorrectTree(TreeNode node, int value) {
//   if (value >= node.value) {
//     if (node.right == null) {
//       // If the right child is null, insert the new node here
//       node.right = TreeNode(value.toString(), value, node.index * 2 + 2);
//     } else {
//       // If the right child exists, recursively traverse the right subtree
//       insertValueIntoCorrectTree(node.right!, value);
//     }
//   } else {
//     if (node.left == null) {
//       // If the left child is null, insert the new node here
//       node.left = TreeNode(value.toString(), value, node.index * 2 + 1);
//     } else {
//       // If the left child exists, recursively traverse the left subtree
//       insertValueIntoCorrectTree(node.left!, value);
//     }
//   }
// }

// void compareAndColorNodes(TreeNode? userTree, TreeNode? correctTree) {
//   if (userTree == null) return;

//   if (correctTree == null) {
//     // If there's no corresponding correct node, mark the user node as incorrect
    
//     userTree.color = Colors.red;
//     // Recursively color incorrect children
//     colorIncorrectChildren(userTree.left, null);
//     colorIncorrectChildren(userTree.right, null);
//     return;
//   }

//   // Compare the values of the current nodes and update colors accordingly
//   if (userTree.value == correctTree.value) {
//     // If the values match, set the color to green
//     userTree.color = Colors.green;
//   } else {
//     // If the values don't match, set the color to red

//     userTree.color = Colors.red;
//   }

//   // Recursively compare and color nodes in the left and right subtrees
//   compareAndColorNodes(userTree.left, correctTree.left);
//   compareAndColorNodes(userTree.right, correctTree.right);

//   // Check if the user-made node is correctly positioned but its children are not
//   if (userTree.isCorrectlyPositioned && !correctTree.isCorrectlyPositioned) {
//     // Color the incorrect children nodes
//     colorIncorrectChildren(userTree, correctTree);
//   }
// }


// void colorIncorrectChildren(TreeNode? userNode, TreeNode? correctNode) {
//   if (userNode == null) return;

//   // If there's no corresponding correct node and the user node exists, mark it as incorrect
//   if (correctNode == null) {
//     userNode.color = Colors.red;
//     return;
//   }

//   if (userNode.right != null && correctNode.right == null) {
//     userNode.right!.color = Colors.red;
//   } else if (userNode.right != null && correctNode.right != null) {
//     // Recursively check and color the right subtree
//     compareAndColorNodes(userNode.right, correctNode.right);
//   }
//   // Color the left child if it's present in user tree but not in correct tree
//   if (userNode.left != null && correctNode.left == null) {
//     userNode.left!.color = Colors.red;
//   } else if (userNode.left != null && correctNode.left != null) {
//     // Recursively check and color the left subtree
//     compareAndColorNodes(userNode.left, correctNode.left);
//   }

  
// }





// bool _checkTreeSorted(TreeNode? node) {
//   if (node == null) return true;

//   bool leftSorted = node.left == null || (node.left!.value <= node.value && _checkTreeSorted(node.left));
//   bool rightSorted = node.right == null || (node.right!.value >= node.value && _checkTreeSorted(node.right));

//   // Update node's position correctness based on sorting correctness
//   node.isCorrectlyPositioned = leftSorted && rightSorted;

//   return leftSorted && rightSorted;
// }









// void sortTree() {
//   _isTreeSorted = true;
//   if (_nodeValues.isNotEmpty) {
//     // Clear existing tree
//     _root = null;

//     // Construct the binary search tree
//     for (int i = 0; i < _nodeValues.length; i++) {
//       _insertNode(_root, _nodeValues[i]); // Call _insertNode directly
//     }

//     // Set the state to trigger a redraw with the updated tree
//     setState(() {});
//   }
// }

// void _insertNode(TreeNode? node, int value) {
//   if (node == null) {
//     // If the node is null, create a new node as the root
//     _root = TreeNode(value.toString(), value, 0);
//   } else {
//     // Traverse the tree recursively to find the correct position for insertion
//     _insertNodeRecursive(node, value);
//   }
// }

// void _insertNodeRecursive(TreeNode node, int value) {
//   if (value >= node.value) { // Changed the condition to include equality
//     // If the value is greater than or equal to the current node's value,
//     // and the right child is null, insert the new node here
//     if (node.right == null) {
//       node.right = TreeNode(value.toString(), value, node.index * 2 + 2);
//     } else {
//       // Otherwise, recursively traverse the right subtree
//       _insertNodeRecursive(node.right!, value);
//     }
//   } else {
//     // If the value is less than the current node's value,
//     // and the left child is null, insert the new node here
//     if (node.left == null) {
//       node.left = TreeNode(value.toString(), value, node.index * 2 + 1);
//     } else {
//       // Otherwise, recursively traverse the left subtree
//       _insertNodeRecursive(node.left!, value);
//     }
//   }
// }













// void _inOrderTraversal(TreeNode node) {
//   if (node.left != null) {
//     _inOrderTraversal(node.left!);
//   }
//   // Include all nodes, including the root node
//   _nodes.add(node);
//   if (node.right != null) {
//     _inOrderTraversal(node.right!);
//   }
// }




// void _insertNodeHelper(TreeNode node, int value) {
//   // Compare the value with the first input if available, otherwise use the root node's value
//   int comparisonValue = firstInput ?? node.value;
  
//   if (value >= comparisonValue) {
//     if (node.right == null) {
//       // If the right child is null, insert the new node here
//       int newIndex = node.index * 2 + 2; // Calculate the new index for the right child
//       node.right = TreeNode(value.toString(), value, newIndex, rootValue: node.rootValue);
//     } else {
//       // If the right child exists, recursively traverse the right subtree
//       _insertNodeHelper(node.right!, value);
//     }
//   } else {
//     if (node.left == null) {
//       // If the left child is null, insert the new node here
//       int newIndex = node.index * 2 + 1; // Calculate the new index for the left child
//       node.left = TreeNode(value.toString(), value, newIndex, rootValue: node.rootValue);
//     } else {
//       // If the left child exists, recursively traverse the left subtree
//       _insertNodeHelper(node.left!, value);
//     }
//   }
// }




// void _insertNodeRight(TreeNode node, int value) {
//   if (node.right == null) {
//     // If the right child is null, insert the new node here
//     node.right = TreeNode(value.toString(), value, node.index * 2 + 2, rootValue: node.rootValue);
//   } else {
//     // If the right child exists, recursively traverse the right subtree
//     _insertNodeHelper(node.right!, value);
//   }
// }

// void _insertNodeLeft(TreeNode node, int value) {
//   if (node.left == null) {
//     // If the left child is null, insert the new node here
//     node.left = TreeNode(value.toString(), value, node.index * 2 + 1, rootValue: node.rootValue);
//   } else {
//     // If the left child exists, recursively traverse the left subtree
//     _insertNodeHelper(node.left!, value);
//   }
// }

// void clearTree() {
//   setState(() {
//     _root = null;
//     _isTreeSorted = true; // Reset tree sorting status
//     _nodeValues.clear(); // Clear the node values list
//   });
// }


// void main() {
//   runApp(MaterialApp(
//     home: BinarySearchPage(),
//   ));
// }

// void insertNodeAsRoot() {
//   final input = _numberController.text.trim();
  
//   if (input.isNotEmpty) {
//     int? value = int.tryParse(input);
//     if (value != null) {
//       _nodeValues.add(value); // Add the parsed integer value to _nodeValues
//       if (firstInput == null) {
//         firstInput = value; // Set the first input if not already set
//       }
//       if (_root == null || _root!.value == firstInput) {
//         _root = TreeNode(input, value, 0, rootValue: input); // Set the index to 0
//       } else {
//         // Handle error: root node cannot be changed
//       }
//       setState(() {});
//     } else {
//       // Handle error: input is not a valid integer
//     }
//   }
// }



// void showInsertModal() {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('Select Node and Position'),
//         content: SingleChildScrollView(
//           child: ListBody(
//             children: getSelectableNodes()
//                 .map((node) => ListTile(
//                       title: Text('Node Value: ${node.originalValue}'),
//                       onTap: () => showPositionDialog(node),
//                     ))
//                 .toList(),
//           ),
//         ),
//       );
//     },
//   );
// }

// List<TreeNode> getSelectableNodes() {
//   List<TreeNode> nodes = [];
//   void traverse(TreeNode? node) {
//     if (node == null) return;
//     int childCount = 0;
//     if (node.left != null) childCount++;
//     if (node.right != null) childCount++;
//     if (childCount < 2) nodes.add(node);
//     traverse(node.left);
//     traverse(node.right);
//   }
//   traverse(_root);
//   return nodes;
// }

// void showPositionDialog(TreeNode node) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('Select Position for Node Value: ${_numberController.text}'),
//         content: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: <Widget>[
//             if (node.left == null)
//               ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     int? value = int.tryParse(_numberController.text);
//                     if (value != null) {
//                       _nodeValues.add(value); // Append the input value to _nodeValues
//                       node.left = TreeNode(_numberController.text, value, node.index * 2 + 1, rootValue: _root!.originalValue);
//                       _numberController.clear(); // Clear input after inserting node
//                     } else {
//                       // Handle error: input is not a valid integer
//                     }
//                   });
//                   Navigator.pop(context); // Close the position modal
//                   Navigator.pop(context); // Close the insert modal
//                 },
//                 child: Text('Left'),
//               ),
//             if (node.right == null)
//               ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     int? value = int.tryParse(_numberController.text);
//                     if (value != null) {
//                       _nodeValues.add(value); // Append the input value to _nodeValues
//                       node.right = TreeNode(_numberController.text, value, node.index * 2 + 2, rootValue: _root!.originalValue);
//                       _numberController.clear(); // Clear input after inserting node
//                     } else {
//                       // Handle error: input is not a valid integer
//                     }
//                   });
//                   Navigator.pop(context); // Close the position modal
//                   Navigator.pop(context); // Close the insert modal
//                 },
//                 child: Text('Right'),
//               ),
//           ],
//         ),
//       );
//     },
//   );
// }

// void _captureAndRecognizeText() async {
//   if (!_isCameraInitialized) return;

//   final image = await _cameraController!.takePicture();
//   final inputImage = InputImage.fromFilePath(image.path);
//   final textRecognizer = GoogleMlKit.vision.textRecognizer();
//   final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

//   textRecognizer.close();

//   if (recognizedText.text.isEmpty) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text('Empty Text Recognition'),
//         content: Text('Please take a clearer image/photo.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text('OK'),
//           ),
//         ],
//       ),
//     );
//     return;
//   }

//   List<Widget> textWidgets = [];
//   textWidgets.add(Text('Given:', style: TextStyle(fontWeight: FontWeight.bold)));  // Given label

//   int lineCount = 1;  // Start counting from 1 for line labels

//   // Iterate over each block and line
//   bool isFirstLine = true;
//   for (var block in recognizedText.blocks) {
//     for (var line in block.lines) {
//       if (isFirstLine) {
//         // First line after 'Given:' is always editable and prefixed with '-'
//         textWidgets.add(TextField(
//           controller: TextEditingController(text: line.text),
//           decoration: InputDecoration(prefixText: "- "),
//         ));
//         isFirstLine = false;
//       } else {
//         // Add non-editable line label
//         textWidgets.add(Text('Line $lineCount:', style: TextStyle(fontWeight: FontWeight.bold)));
//         lineCount++;
//         // Add editable text field for the line
//         textWidgets.add(TextField(
//           controller: TextEditingController(text: line.text),
//           decoration: InputDecoration(prefixText: "- "),
//         ));
//       }
//     }
//   }

//   // Show dialog with the structured text
//   showDialog(
//     context: context,
//     builder: (_) => AlertDialog(
//       title: Text('Extracted Text'),
//       content: SingleChildScrollView(
//         child: ListBody(children: textWidgets),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(),
//           child: Text('Cancel'),
//         ),
//         TextButton(
//           onPressed: () {
//             // Here you would handle saving the edited text
//             Navigator.of(context).pop();
//           },
//           child: Text('Save'),
//         ),
//       ],
//     ),
//   );
// }




// }