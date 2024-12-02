import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InsertDataScreen extends StatefulWidget {
  @override
  _InsertDataScreenState createState() => _InsertDataScreenState();
}

class _InsertDataScreenState extends State<InsertDataScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Variable to hold fetched users
  List<Map<String, dynamic>> users = [];
  String?
      selectedUserId; // Store the ID of the selected user for update or delete

  Future<void> addUser(String name, int age) async {
    try {
      print("Attempting to add user: name=$name, age=$age");
      DocumentReference result = await _firestore.collection('users').add({
        'name': name,
        'age': age,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print("User added successfully with ID: ${result.id}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User added successfully")),
      );
      fetchUsers(); // Refresh the users list after adding a user
    } catch (e) {
      print("Error adding user: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add user: $e")),
      );
    }
  }

  Future<void> fetchUsers() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').get();
      setState(() {
        users = snapshot.docs
            .map((doc) => {
                  'id': doc.id, // Save the document ID
                  ...doc.data() as Map<String, dynamic>
                })
            .toList();
      });
    } catch (e) {
      print("Error fetching users: $e");
    }
  }

  Future<void> updateUser(String userId, String name, int age) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'name': name,
        'age': age,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      print("User updated successfully");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User updated successfully")),
      );
      fetchUsers(); // Refresh the users list after updating
      setState(() {
        selectedUserId = null; // Reset selected user after update
      });
    } catch (e) {
      print("Error updating user: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update user: $e")),
      );
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
      print("User deleted successfully");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User deleted successfully")),
      );
      fetchUsers(); // Refresh the users list after deletion
      setState(() {
        selectedUserId = null; // Reset selected user after deletion
      });
    } catch (e) {
      print("Error deleting user: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete user: $e")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUsers(); // Fetch users when the screen is first loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firestore Example"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Name Input Field
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Age Input Field
            TextField(
              controller: ageController,
              decoration: InputDecoration(
                labelText: "Age",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),

            // Add User Button
            ElevatedButton(
              onPressed: () {
                String name = nameController.text.trim();
                int? age = int.tryParse(ageController.text.trim());
                if (name.isNotEmpty && age != null && age > 0) {
                  addUser(name, age);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please enter valid data")),
                  );
                }
              },
              child: Text("Add User"),
            ),
            SizedBox(height: 16),

            // Data Table displaying the list of users
            if (users.isNotEmpty) ...[
              Text(
                "User List:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 8),
              DataTable(
                columns: [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Age')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: users.map((user) {
                  return DataRow(cells: [
                    DataCell(Text(user['name'] ?? 'N/A')),
                    DataCell(Text(user['age'].toString())),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              setState(() {
                                selectedUserId = user['id']; // Select this user
                                nameController.text = user['name'];
                                ageController.text = user['age'].toString();
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              deleteUser(user['id']);
                            },
                          ),
                        ],
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ] else ...[
              Center(child: Text("No users found")),
            ],

            // Update and Delete buttons if a user is selected
            if (selectedUserId != null) ...[
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      String name = nameController.text.trim();
                      int? age = int.tryParse(ageController.text.trim());
                      if (name.isNotEmpty && age != null && age > 0) {
                        updateUser(selectedUserId!, name, age);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please enter valid data")),
                        );
                      }
                    },
                    child: Text("Update User"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      deleteUser(selectedUserId!);
                    },
                    child: Text("Delete User"),
                    // style: ElevatedButton.styleFrom(primary: Colors.red),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
