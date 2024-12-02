import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class InsertDataScreen extends StatefulWidget {
  @override
  _InsertDataScreenState createState() => _InsertDataScreenState();
}

class _InsertDataScreenState extends State<InsertDataScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  // Ensure Firebase is initialized
  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    try {
      await Firebase.initializeApp();
      print("Firebase initialized successfully");
    } catch (e) {
      print("Error initializing Firebase: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error initializing Firebase: $e")),
      );
    }
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser(String name, int age) async {
    try {
      print("Attempting to add user: name=$name, age=$age");
      await _firestore.collection('users').add({
        'name': name,
        'age': age,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print("User added successfully");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User added successfully")),
      );
    } catch (e) {
      print("Error adding user: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add user: $e")),
      );
    }
  }

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Error fetching users: $e");
      return [];
    }
  }

  Future<void> showUsers() async {
    List<Map<String, dynamic>> users = await fetchUsers();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Users List"),
          content: users.isEmpty
              ? Text("No users found.")
              : SingleChildScrollView(
                  child: Column(
                    children: users.map((user) {
                      return ListTile(
                        title: Text("Name: ${user['name']}"),
                        subtitle: Text("Age: ${user['age']}"),
                      );
                    }).toList(),
                  ),
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
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
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: ageController,
              decoration: InputDecoration(
                labelText: "Age",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    String name = nameController.text;
                    int age = int.tryParse(ageController.text) ?? 0;

                    if (name.isNotEmpty && age > 0) {
                      addUser(name, age);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please enter valid data")),
                      );
                    }
                  },
                  child: Text("Add User"),
                ),
                ElevatedButton(
                  onPressed: showUsers,
                  child: Text("Show Users"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
