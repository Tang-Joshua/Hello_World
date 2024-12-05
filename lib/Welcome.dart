import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Homepage'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image at the top
            Image.network(
              'https://via.placeholder.com/150', // Replace with your image URL
              width: 150,
              height: 150,
            ),

            SizedBox(height: 20),

            // Title in the middle
            Text(
              'Welcome to Our App!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            // Description below the title
            Text(
              'This is a sample description of the app, explaining its purpose and features.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 30),

            // Login Button
            ElevatedButton(
              onPressed: () {
                // Handle login logic
              },
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                // primary: Colors.blue,
              ),
            ),

            SizedBox(height: 10),

            // Register Button
            ElevatedButton(
              onPressed: () {
                // Handle register logic
              },
              child: Text('Register'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                // primary: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
