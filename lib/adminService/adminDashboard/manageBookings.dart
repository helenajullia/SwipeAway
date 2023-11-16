import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../BookingModel.dart';

class ManageBookings extends StatefulWidget {
  @override
  _ManageBookingsState createState() => _ManageBookingsState();
}

class _ManageBookingsState extends State<ManageBookings> {
  List<Booking> bookings = [];

  @override
  void initState() {
    super.initState();
    fetchAllBookings();
  }

  Future<void> updateBookingStatus(String email, String docId, String newStatus) async {
    if (email == 'Unknown') {
      print('Invalid email address, cannot update booking status.');
      return;
    }
    try {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .collection('bookings')
          .doc(docId);

      await docRef.update({'status': newStatus});
    } catch (e) {
      print('An error occurred while updating booking status: $e');
    }
  }



  fetchAllBookings() async {
    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection(
        'users').get();
    for (var userDoc in usersSnapshot.docs) {
      String email = userDoc.id;
      QuerySnapshot bookingsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .collection('bookings')
          .get();

      for (var bookingDoc in bookingsSnapshot.docs) {
        String docId = bookingDoc.id;
        Map<String, dynamic> bookingData = bookingDoc.data() as Map<
            String,
            dynamic>;
        Map<String, dynamic>? userData = userDoc.data() as Map<String,
            dynamic>?;

        String firstName = userData != null && userData['firstName'] != null
            ? userData['firstName'] as String
            : 'Unknown';
        String lastName = userData != null && userData['lastName'] != null
            ? userData['lastName'] as String
            : 'Unknown';

        bookings.add(Booking.fromMap(bookingData, docId, firstName, lastName,email));
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("View Bookings"),
      ),
      body: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          Booking booking = bookings[index];
          return Card(
            child: Column(
              children: [
                ListTile(
                  title: Text("${booking.firstName} ${booking.lastName}"),
                  subtitle: Text(
                      "${booking.hotelId}\nStatus: ${booking.status}"),
                  trailing: DropdownButton<String>(
                    value: (booking.status != 'approved' && booking.status != 'canceled') ? null : booking.status,
                    items: ['approved', 'canceled']
                        .map((String value) =>
                        DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                        .toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          booking.status = newValue;
                        });
                        updateBookingStatus(booking.email, booking.docId, newValue); // Use the correct identifiers
                      }
                    },
                    hint: Text('Select Status'),

          ),
                ),
                if (booking.hotelImageURL.isNotEmpty)
                  Container(
                    height: 200, // Adjust height as needed
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: booking.hotelImageURL.length,
                      itemBuilder: (context, imageIndex) {
                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Image.network(
                            booking.hotelImageURL[imageIndex],
                            // Display each picture
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.error),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
