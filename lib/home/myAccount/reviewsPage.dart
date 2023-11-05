  import 'package:flutter/material.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:flutter_rating_bar/flutter_rating_bar.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:google_fonts/google_fonts.dart';
  class ReviewPage extends StatefulWidget {
    @override
    _ReviewPageState createState() => _ReviewPageState();
  }

  class _ReviewPageState extends State<ReviewPage> {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance
    final TextEditingController _reviewController = TextEditingController();
    double _currentRating = 0;
    List<Review> reviewsList = []; // List to hold reviews

    @override
    void initState() {
      super.initState();
      _loadReviews();
    }

    Future<void> _loadReviews() async {
      final QuerySnapshot snapshot = await _firestore.collection('reviews').get();

      List<Review> fetchedReviews = [];
      for (var doc in snapshot.docs) {
        var reviewData = doc.data() as Map<String, dynamic>;
        Review review = Review.fromMap(reviewData);
        fetchedReviews.add(review);
      }

      setState(() {
        reviewsList = fetchedReviews;
      });
    }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Reviews',
          style: GoogleFonts.roboto(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Your Rating:',
                style: GoogleFonts.roboto(
                  fontSize: 18.0,
                ),
              ),
              SizedBox(height: 8.0),
              RatingBar.builder(
                itemSize: 40.0,
                initialRating: _currentRating,
                glowColor: Colors.amber,
                allowHalfRating: true,
                minRating: 0,
                direction: Axis.horizontal,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star_rate_rounded,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _currentRating = rating;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _reviewController,
                cursorColor: Colors.black,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Enter your review',
                  labelStyle: TextStyle(color: Colors.black, fontFamily: 'Roboto'),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton.icon(
                onPressed: _submitReview,
                icon: Icon(Icons.send, color: Colors.white),
                label: Text('Submit Review',
                    style: TextStyle(color: Colors.white,  fontFamily: 'Roboto')),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: reviewsList.length,
                  itemBuilder: (context, index) {
                    final review = reviewsList[index];
                    return ListTile(
                      title: Text('${review.firstName} ${review.lastName}'),
                      subtitle: Text(review.text),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          5,
                              (starIndex) =>  Icon(
                                starIndex < review.rating.floor() ? Icons.star_rate_rounded : Icons.star_border_rounded, // Changed to star_rate_rounded
                                color: starIndex < review.rating ? Colors.amber : Colors.grey,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }

    Future<UserDetails> _getUserDetails() async {
      // Assuming you are using the currently logged-in user's email to fetch their document
      User? user = _auth.currentUser;
      if (user != null && user.email != null) {
        var userDoc = await _firestore.collection('users').doc(user.email).get();
        // Make sure your user documents have a 'firstName' and 'lastName' field
        String firstName = userDoc.data()?['firstName'] ?? '';
        String lastName = userDoc.data()?['lastName'] ?? '';
        return UserDetails(firstName: firstName, lastName: lastName, email: user.email!); // Assuming email is always present
      } else {
        // Handle the case where the user is not logged in or there is no user
        throw Exception('No user logged in');
      }
    }

    void _submitReview() async {
      if (_reviewController.text.isNotEmpty && _currentRating != 0) {
        try {
          UserDetails userDetails = await _getUserDetails();

          Review newReview = Review(
            // We will need to add uid to UserDetails or fetch it another way
            firstName: userDetails.firstName,
            lastName: userDetails.lastName,
            rating: _currentRating,
            text: _reviewController.text, userId: '',
          );

          await _firestore.collection('reviews').add(newReview.toMap());
          _reviewController.clear();
          setState(() {
            _currentRating = 0;
          });

          // Show a snackbar message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Review submitted!'),
            ),
          );

          // Reload reviews to include the new one
          _loadReviews();
        } catch (e) {
          // Handle the error properly
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error submitting review: $e'),
            ),
          );
        }
      } else {
        // Show a snackbar message if review or rating wasn't entered
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter a review and rate.'),
          ),
        );
      }
    }
  }

    class UserDetails {
    final String firstName;
    final String lastName;
    final String email;

    UserDetails({
    required this.firstName,
    required this.lastName,
    required this.email,
    });
    }

// Rest of the Review class remains unchanged

    class Review {
    String userId;
    String firstName;
    String lastName;
    double rating;
    String text;

    Review({
      required this.userId,
      required this.firstName,
      required this.lastName,
      required this.rating,
      required this.text,
    });

    Map<String, dynamic> toMap() {
      return {
        'userId': userId,
        'firstName': firstName, // Include the firstName when saving to Firestore
        'lastName': lastName,   // Include the lastName when saving to Firestore
        'rating': rating,
        'text': text,
      };
    }


    factory Review.fromMap(Map<String, dynamic> map) {
      return Review(
        userId: map['userId'] ?? '',
        firstName: map['firstName'] ?? '[No First Name]',
        lastName: map['lastName'] ?? '[No Last Name]',
        rating: (map['rating'] ?? 0).toDouble(),
        text: map['text'] ?? '',
      );
    }
  }