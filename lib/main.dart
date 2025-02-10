import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Smart Oral Health Monitor',
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
        drawer: Drawer(
          // **Sliding Drawer Menu**
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 162, 230, 229),
                      Color.fromARGB(255, 162, 202, 245),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(fontSize: 24, color: Colors.blueGrey),
                ),
              ),
              ListTile(
                leading: Icon(Icons.video_call),
                title: Text('Video tutorial'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: Icon(Icons.contact_phone_outlined),
                title: Text('Connect with dentist'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: Icon(Icons.question_answer),
                title: Text('FAQs'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: Icon(Icons.reviews),
                title: Text('User reviews'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Did you check your oral health today?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                  color: Colors.blueGrey,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'Use our AI-powered tool to monitor and maintain oral health at home',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w200,
                  color: const Color.fromARGB(255, 37, 37, 37),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 35),
              Text(
                'Follow the steps to get started..',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w400,
                  color: Colors.blueGrey,
                ),
                textAlign: TextAlign.center,
              ),
              Center(
                child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      border: Border.all(
                          color: const Color.fromARGB(119, 158, 158, 158),
                          width: 2),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '01',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w900,
                            color: Colors.blueGrey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 200,
                              child: Text(
                                'Click pictures from various angles using the TC Wifi mobile app',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                  color: const Color.fromARGB(255, 37, 37, 37),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(width: 20),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'assets/images/scan.png',
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
              ),
              Center(
                child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      border: Border.all(
                          color: const Color.fromARGB(119, 158, 158, 158),
                          width: 2),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '02',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w900,
                            color: Colors.blueGrey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 200,
                              child: Text(
                                'Upload the pictures by clicking the button below and watch AI’s magic',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                  color: const Color.fromARGB(255, 37, 37, 37),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(width: 20),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'assets/images/upload.png',
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
              ),
              Center(
                child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      border: Border.all(
                          color: const Color.fromARGB(119, 158, 158, 158),
                          width: 2),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '03',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w900,
                            color: Colors.blueGrey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 200,
                              child: Text(
                                'Review the detailed report and connect with the dentist if needed',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                  color: const Color.fromARGB(255, 37, 37, 37),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(width: 20),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'assets/images/connect.png',
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    //Action on button press
                  },
                  child: Text("Upload images"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
