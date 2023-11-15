import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';

class BookingsPage extends StatefulWidget {
  @override
  _BookingsPageState createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  final int _perPage = 10;
  DocumentSnapshot? _lastDocument;
  bool _isLoadingMore = false;
  List<DocumentSnapshot> _bookings = [];

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  _loadBookings() async {
    String? userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userEmail != null) {
      var query = FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .collection('bookings')
          .orderBy('checkInDate', descending: true)
          .limit(_perPage);

      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      var snapshot = await query.get();
      if (snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;
      }

      setState(() {
        _bookings.addAll(snapshot.docs);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String? userEmail = FirebaseAuth.instance.currentUser?.email;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Bookings', style: TextStyle(color: Colors.white)),
      ),

      body: userEmail == null
          ? Center(child: Text('You are not logged in'))
          : _buildBookingList(),
    );
  }

  Widget _buildLoadMoreButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Center(
        child: OutlinedButton(
          onPressed: () {
            setState(() {
              _isLoadingMore = true;
            });
            _loadBookings().then((_) {
              setState(() {
                _isLoadingMore = false;
              });
            });
          },
          child: Text('Load More'),
        ),
      ),
    );
  }

  Widget _buildBookingList() {
    return ListView.builder(
      itemCount: _bookings.length + 1,
      itemBuilder: (context, index) {
        if (index < _bookings.length) {
          return _buildBookingCard(_bookings[index]);
        } else if (_isLoadingMore) {
          return Center(child: CircularProgressIndicator());
        } else {
          return _buildLoadMoreButton();
        }
      },
    );
  }

  Widget _buildBookingCard(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    List<String> imageUrls = List<String>.from(
        data['hotelImageURL'] as List<dynamic>);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(data['hotelId'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              subtitle: Text(
                'Check-in: ${DateFormat('yyyy-MM-dd').format(
                    data['checkInDate'].toDate())}\n'
                    'Check-out: ${DateFormat('yyyy-MM-dd').format(
                    data['checkOutDate'].toDate())}\n'
                    'Total Cost: ${data['tripCost']} RON\n'
                    'Status: ${data['status']}',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            if (imageUrls.isNotEmpty)
              CarouselSlider(
                options: CarouselOptions(
                  height: 200.0,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  viewportFraction: 0.8,
                ),
                items: imageUrls.map((url) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                        ),
                        child: Image.network(url, fit: BoxFit.cover),
                      );
                    },
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
