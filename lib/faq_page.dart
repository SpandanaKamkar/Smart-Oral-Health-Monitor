import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {
      "question": "What is the Smart Oral Health Monitor?",
      "answer":
          "The Smart Oral Health Monitor is a device that helps you track and improve your oral hygiene by analyzing your teeth, gums and overall oral health."
    },
    {
      "question": "How does the Smart Oral Health Monitor work?",
      "answer":
          "The device uses advanced sensors and AI technology to scan your mouth and provide real-time insights through the companion mobile app."
    },
    {
      "question": "What does the app analyze in my oral health?",
      "answer":
          "The app checks for plaque build up, cavities, tooth discolouration, mouth ulcers and gum problems."
    },
    {
      "question": "How do I set up my Smart Oral Health Monitor?",
      "answer":
          "Simply charge the device, download the app and follow the on-screen instructions to pair it via Bluetooth."
    },
    {
      "question": "How do I connect the device to my phone?",
      "answer":
          "Turn on Bluetooth on your phone, open the app, and select ‘Pair Device’ in the settings menu."
    },
    {
      "question": "How often should I use the device?",
      "answer":
          "For best results, use the device at least once a day before or after brushing."
    },
    {
      "question": "Can multiple users use the same device?",
      "answer":
          "Yes, but each user should create a separate profile in the app for accurate tracking."
    },
    {
      "question": "Does the device work for children?",
      "answer":
          "Yes, it is safe for children, but parental supervision is recommended."
    },
    {
      "question": "Can I share my results with my dentist?",
      "answer":
          "Yes, you can generate a detailed report in the app and share it via email or PDF."
    },
    {
      "question": "Does the app provide personalized oral care tips?",
      "answer":
          "Yes, based on your results, the app suggests customized oral care routines and product recommendations."
    },
    {
      "question": "How long does the battery last?",
      "answer": "A full charge lasts approximately 4 hours with regular use."
    },
    {
      "question": "How do I clean the device?",
      "answer":
          "Use a soft cloth with mild disinfectant or water to clean the surface. Avoid submerging it in water."
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
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
          title: Text(
            "FAQs",
            style: TextStyle(
              color: Color.fromARGB(255, 47, 61, 68),
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: faqs.length,
          itemBuilder: (context, index) {
            return Card(
              color: const Color.fromARGB(255, 247, 246, 246),
              elevation: 2,
              margin: EdgeInsets.symmetric(vertical: 5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: ExpansionTile(
                tilePadding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                childrenPadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                title: Text(
                  faqs[index]["question"]!,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                ),
                children: [
                  Text(
                    faqs[index]["answer"]!,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
