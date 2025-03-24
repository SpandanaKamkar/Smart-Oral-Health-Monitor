import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'youtube_video_page.dart';
import 'faq_page.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import '../services/mongo_service.dart';
import '../profile_page.dart';
import '../pages/login_page.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

Map<String, dynamic>? user;

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    String? userEmail = await MongoService.getUserSession();
    if (userEmail != null) {
      Map<String, dynamic>? fetchedUser =
          await MongoService.getUserData(userEmail);
      setState(() {
        user = fetchedUser;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dental Disease Detection',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ImageUploader(),
    );
  }
}

class ImageUploader extends StatefulWidget {
  @override
  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  String? _predictedDisease; // Store the predicted disease name
  File? _selectedImage;
  Uint8List? _processedImage;
  bool _showAnalysis = false; // Controls when the processed image is displayed
  List<String> _remedyLinks = []; // Store remedy links

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    print("Picked image from gallery");

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _processedImage = null;
        _predictedDisease = null;
        _showAnalysis = false;
      });
      print("✅ Image selected: ${_selectedImage!.path}");
    } else {
      print("❌ No image selected");
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) {
      print("❌ No image selected!");
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.1.40:5000/detect'), // Ensure Flask is running
    );

    request.files
        .add(await http.MultipartFile.fromPath('file', _selectedImage!.path));

    print("📤 Uploading image...");
    var response = await request.send();

    if (response.statusCode == 200) {
      // Read response as JSON
      var responseBody = await response.stream.bytesToString();
      print("📥 Server Response: $responseBody");

      var jsonResponse = jsonDecode(responseBody);
      if (jsonResponse.containsKey("processed_image_url") &&
          jsonResponse.containsKey("predicted_disease") &&
          jsonResponse.containsKey("remedy_links")) {
        setState(() {
          _predictedDisease = jsonResponse["predicted_disease"];
          _remedyLinks = List<String>.from(jsonResponse["remedy_links"]);
        });
        // String diseaseLabel = jsonResponse["predicted_disease"];
        String processedImageUrl = jsonResponse["processed_image_url"];
        // List<String> remedyLinks = List<String>.from(jsonResponse["remedy_links"]);
        print("🔹 Disease Detected: $_predictedDisease");
        print("🔹 Processed Image URL: $processedImageUrl");
        print("🔹 Remedy Links: $_remedyLinks");

        // Fetch processed image from Flask
        var imageResponse = await http.get(Uri.parse(processedImageUrl));

        if (imageResponse.statusCode == 200) {
          String? userEmail = await MongoService.getUserSession();
          print("email: $userEmail");
          DateTime now = DateTime.now(); // Get current timestamp
          print("date/time: $now");

          // Update last scanned timestamp in the database
          await MongoService.userCollection.updateOne(
            {"email": userEmail}, // Find user by email
            {
              "\$set": {
                "last_scanned":
                    now.toIso8601String(), // Store timestamp in ISO format
              }
            },
          );
          setState(() {
            _processedImage = imageResponse.bodyBytes;
            _showAnalysis = true;
            print("✅ Processed image received and stored.");
          });
        } else {
          print(
              "❌ Failed to load processed image: ${imageResponse.statusCode}");
        }
      } else {
        print("❌ JSON Response is missing required fields.");
      }
    } else {
      print("❌ Failed to upload image: ${response.statusCode}");
    }
  }

  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print("❌ Could not launch $url");
    }
  }

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
          actions: [
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                if (user != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(user: user!),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("User data not loaded yet!")),
                  );
                }
              },
            ),
          ],
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
          // Sliding Drawer Menu
          backgroundColor: Colors.white,
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
                  style: TextStyle(
                      fontSize: 24, color: Color.fromARGB(255, 47, 61, 68)),
                ),
              ),
              Builder(
                builder: (context) => ListTile(
                  leading: Icon(Icons.video_call),
                  title: Text('Video tutorial'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => YouTubeVideoPage()),
                    );
                  },
                ),
              ),
              ListTile(
                leading: Icon(Icons.contact_phone_outlined),
                title: Text('Connect with dentist'),
                onTap: () => Navigator.pop(context),
              ),
              Builder(
                builder: (context) => ListTile(
                  leading: Icon(Icons.question_answer),
                  title: Text('FAQs'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FAQPage()),
                    );
                  },
                ),
              ),
              ListTile(
                leading: Icon(Icons.reviews),
                title: Text('User reviews'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, ${user != null ? user!['name'] : 'Guest'}!\nDid you check your oral health today?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                  color: Colors.blueGrey,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'Use Smart Oral Health Monitor to maintain oral health at home',
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
                      borderRadius: BorderRadius.circular(20),
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
                      borderRadius: BorderRadius.circular(20),
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
                                'Upload the pictures by clicking the button below',
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
                                width: 80,
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
                      borderRadius: BorderRadius.circular(20),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                        onPressed: _pickImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.transparent, // Change button color
                          shadowColor:
                              Colors.transparent, // Remove default shadow
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12), // Button padding
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20), // Rounded corners
                          ),
                        ),
                        child: Text(
                          "Upload Images",
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    _selectedImage != null
                        ? Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () async {
                                  if (_selectedImage == null) return;
                                  setState(() {
                                    _showAnalysis =
                                        false; // Hide previous results before uploading new image
                                  });
                                  await _uploadImage();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 183, 223, 246),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: Text(
                                  "Show Analysis",
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              // Display analysis results ONLY when _showAnalysis == true
                              if (_showAnalysis) ...[
                                _processedImage != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.memory(
                                          _processedImage!,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Container(),
                                SizedBox(height: 20),
                                _predictedDisease != null
                                    ? Center(
                                        child: Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    "Indicates presence of..\n",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.blueGrey,
                                                ),
                                              ),
                                              TextSpan(
                                                text: _predictedDisease,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16,
                                                  color: Colors.blueGrey,
                                                ),
                                              ),
                                            ],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    : Container(),
                                SizedBox(height: 20),
                                Text("Preventive steps that you can take:",
                                    style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                for (var link in _remedyLinks)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: GestureDetector(
                                      onTap: () => _launchURL(link),
                                      child: Text(
                                        link,
                                        style: TextStyle(
                                            color: Colors.blue,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    ),
                                  ),
                              ],
                            ],
                          )
                        : Text(
                            "No image uploaded",
                            style:
                                TextStyle(fontSize: 16, color: Colors.blueGrey),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
