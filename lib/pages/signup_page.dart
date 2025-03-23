import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/mongo_service.dart';
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String errorMessage = "";

  Future<void> _signup() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String hashedPassword = MongoService.hashPassword(password);

    var existingUser = await MongoService.userCollection.findOne({
      "email": email,
    });
    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      if (existingUser != null) {
        Fluttertoast.showToast(msg: "User already exists!");
        return;
      }
      // Hash password before storing it
      String hashedPassword = MongoService.hashPassword(password);
      await MongoService.userCollection.insertOne({
        "name": name,
        "email": email,
        "password": hashedPassword,
      });
      Fluttertoast.showToast(msg: "Signup successful!");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      Fluttertoast.showToast(msg: "Please enter email and password");
      setState(() {
        errorMessage = "Please fill all fields!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Signup',
          style: TextStyle(color: Color.fromARGB(255, 47, 61, 68)),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 191, 234, 231),
                Color.fromARGB(255, 148, 185, 255),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
            ),
            SizedBox(height: 10),
            Text(errorMessage, style: TextStyle(color: Colors.red)),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 191, 234, 231),
                      Color.fromARGB(255, 148, 185, 255),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25)),
              child: ElevatedButton(
                onPressed: () => _signup(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent, // Change button color
                  shadowColor: Colors.transparent, // Remove default shadow
                  padding: EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12), // Button padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                ),
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
