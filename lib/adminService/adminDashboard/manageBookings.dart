import 'dart:math';

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


  Future<void> updateBookingStatusForAllUsers(String bookingId, String newStatus, Booking booking) async {
    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection('users').get();

    for (var userDoc in usersSnapshot.docs) {
      String email = userDoc.id;
      QuerySnapshot bookingsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .collection('bookings')
          .where(FieldPath.documentId, isEqualTo: bookingId)
          .get();

      for (var bookingDoc in bookingsSnapshot.docs) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(email)
            .collection('bookings')
            .doc(bookingId)
            .update({'status': newStatus})
            .then((_) async {
          if (newStatus == 'approved') {
            await updateHotelRoomAvailability();
          }
          print("Status updated for booking $bookingId of user $email");
        })
            .catchError((error) => print("Failed to update booking: $error"));
      }
    }
  }

  Future<void> updateHotelRoomAvailability() async {
    try {
      QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
      for (var userDoc in usersSnapshot.docs) {
        String email = userDoc.id;
        QuerySnapshot bookingsSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(email)
            .collection('bookings')
            .where('status', isEqualTo: 'approved')
            .get();

        for (var bookingDoc in bookingsSnapshot.docs) {
          Booking booking = Booking.fromMap(bookingDoc.data() as Map<String, dynamic>, bookingDoc.id, userDoc['firstName'] ?? 'Unknown', userDoc['lastName'] ?? 'Unknown', email);
          await updateRoomCount(booking);
        }
      }
    } catch (e) {
      print("An error occurred while updating room availability: $e");
    }
  }

  Future<void> updateRoomCount(Booking booking) async {
    try {
      DocumentSnapshot hotelSnapshot = await FirebaseFirestore.instance.collection('hotels').doc(booking.hotelId).get();
      if (hotelSnapshot.exists) {
        Map<String, dynamic> hotelData = hotelSnapshot.data() as Map<String, dynamic>;
        int singleRoomsAvailable = hotelData['singleRooms'];
        int doubleRoomsAvailable = hotelData['doubleRooms'];

        if (booking.singleRooms > 0) {
          singleRoomsAvailable = max(0, singleRoomsAvailable - booking.singleRooms);
        }
        if (booking.doubleRooms > 0) {
          doubleRoomsAvailable = max(0, doubleRoomsAvailable - booking.doubleRooms);
        }

        await FirebaseFirestore.instance.collection('hotels').doc(booking.hotelId).update({
          'singleRooms': singleRoomsAvailable,
          'doubleRooms': doubleRoomsAvailable,
        });
      }
    } catch (e) {
      print("An error occurred while updating a hotel's room count: $e");
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
                        updateBookingStatusForAllUsers(booking.docId, newValue,booking).then((_) {
                          setState(() {
                            booking.status = newValue;
                          });
                        }).catchError((error) {
                          // Handle any errors here
                          print("Error updating status: $error");
                        });
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
