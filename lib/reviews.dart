import 'package:flutter/material.dart';
import '../services/mongo_service.dart';

class Reviews extends StatefulWidget {
  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<Reviews> {
  List<Map<String, dynamic>> reviews = [];
  bool isLoading = true; // Add a loading flag

  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    await MongoService.connect();
    List<Map<String, dynamic>> fetchedReviews = await MongoService.getReviews();

    setState(() {
      // Filter out users who haven't given a review
      reviews = fetchedReviews
          .where((review) =>
              review['review'] != null && review['review'].trim().isNotEmpty)
          .toList();

      isLoading = false; // Hide loading indicator after fetching data
    });
  }

  void showReviewDialog() {
    TextEditingController reviewController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              const Color.fromARGB(255, 241, 246, 249), // Light blue background
          title: Text(
            "Give a Review",
            style:
                TextStyle(color: Colors.black), // Set text color for visibility
          ),
          content: TextField(
            controller: reviewController,
            decoration: InputDecoration(
              hintText: "Enter your review",
              hintStyle:
                  TextStyle(color: Colors.grey[700]), // Adjust hint color
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.blueGrey, // Light blue text color
              ),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                String reviewText = reviewController.text.trim();
                if (reviewText.isNotEmpty) {
                  await MongoService.addReview(reviewText);
                  fetchReviews(); // Refresh the reviews
                }
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.blueGrey, // Light blue text color
              ),
              child: Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
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
            "User Reviews",
            style: TextStyle(
              color: Color.fromARGB(255, 47, 61, 68),
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator()) // Show loader while fetching
          : reviews.isEmpty
              ? Center(
                  child: Text("No reviews given",
                      style: TextStyle(fontSize: 18, color: Colors.black)))
              : ListView.builder(
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    var review = reviews[index];
                    return ListTile(
                      title: Text(
                        review['name'] ?? 'Unknown User',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      subtitle: Text(
                        review['review'] ?? 'No review available',
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: showReviewDialog,
        child: Icon(Icons.add_comment),
        tooltip: "Give a Review",
        backgroundColor:
            Color.fromARGB(255, 191, 234, 231), // Optional: Adjust FAB color
      ),
    );
  }
}
