import 'package:flutter/material.dart';
import '../services/mongo_service.dart';
import '../pages/login_page.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatelessWidget {
  final Map<String, dynamic> user;

  ProfilePage({required this.user});

  void _logout(BuildContext context) async {
    await MongoService.clearUserSession();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  String formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return "Never Scanned";
    try {
      DateTime dateTime = DateTime.parse(dateTimeStr);
      return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    } catch (e) {
      return "Invalid Date";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Profile',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${user['name']}", style: TextStyle(fontSize: 17)),
            SizedBox(height: 10),
            Text("Email: ${user['email']}", style: TextStyle(fontSize: 17)),
            SizedBox(height: 10),
            Text(
              "Last Scanned: ${formatDateTime(user['last_scanned'])}",
              style: TextStyle(fontSize: 17),
            ),
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
                onPressed: () => _logout(context),
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
                  "Logout",
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
