import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserManagementScreen extends StatefulWidget {
  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController birthController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> users = [];
  String? selectedUserId;

  Future<void> fetchUsers() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('Account').get();
      setState(() {
        users = snapshot.docs
            .map((doc) => {
                  'id': doc.id, // Store the document ID
                  ...doc.data() as Map<String, dynamic>,
                })
            .toList();
      });
    } catch (e) {
      print("Error fetching users: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching users: $e")),
      );
    }
  }

  Future<void> updateUser(String userId, String username, String email,
      String password, String birth) async {
    try {
      await _firestore.collection('Account').doc(userId).update({
        'username': username,
        'email': email,
        'password': password,
        'birth': birth,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User updated successfully")),
      );
      fetchUsers();
      setState(() {
        selectedUserId = null; // Reset selected user
      });
    } catch (e) {
      print("Error updating user: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating user: $e")),
      );
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection('Account').doc(userId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User deleted successfully")),
      );
      fetchUsers();
    } catch (e) {
      print("Error deleting user: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting user: $e")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUsers(); // Fetch all users when the screen loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Management"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // User Input Fields
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: birthController,
              decoration: const InputDecoration(
                labelText: "Birth (YYYY-MM-DD)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Update Button
            if (selectedUserId != null)
              ElevatedButton(
                onPressed: () {
                  String username = nameController.text.trim();
                  String email = emailController.text.trim();
                  String password = passwordController.text.trim();
                  String birth = birthController.text.trim();
                  if (username.isNotEmpty &&
                      email.isNotEmpty &&
                      password.isNotEmpty &&
                      birth.isNotEmpty) {
                    updateUser(
                        selectedUserId!, username, email, password, birth);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please fill all fields")),
                    );
                  }
                },
                child: const Text("Update User"),
              ),

            const SizedBox(height: 16),

            // User List
            Expanded(
              child: users.isNotEmpty
                  ? ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return Card(
                          child: ListTile(
                            title: Text(user['username']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Email: ${user['email']}"),
                                Text("Birth: ${user['birth']}"),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    setState(() {
                                      selectedUserId = user['id'];
                                      nameController.text = user['username'];
                                      emailController.text = user['email'];
                                      passwordController.text =
                                          user['password'];
                                      birthController.text = user['birth'];
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    deleteUser(user['id']);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(child: Text("No users found")),
            ),
          ],
        ),
      ),
    );
  }
}
