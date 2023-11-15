import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../BookingModel.dart';

class ManageBookings extends StatefulWidget {
  @override
  _ManageBookingsState createState() => _ManageBookingsState();
}

class _ManageBookingsState extends State<ManageBookings> {

  Future<List<Booking>> fetchBookings() async {
    QuerySnapshot bookingSnapshot = await FirebaseFirestore.instance.collection('bookings').get();

    List<Booking> bookings = [];
    for (var doc in bookingSnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      // Assuming 'userId' is the field where the user's document ID is stored
      String userId = data['userId'];

      // Fetch the user document
      var userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      var userData = userSnapshot.data() as Map<String, dynamic>;
      String firstName = userData['firstName'];
      String lastName = userData['lastName'];

      // Create the booking with user information
      try {
        var booking = Booking.fromMap(data, firstName, lastName);
        bookings.add(booking);
      } catch (e) {
        print('Error parsing booking data: $e');
      }
    }
    return bookings;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Bookings', style: GoogleFonts.roboto()),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Booking>>(
        future: fetchBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Booking booking = snapshot.data![index];
                return Dismissible(
                  key: Key(booking.hotelId),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                  onDismissed: (direction) async {
                    await FirebaseFirestore.instance.collection('bookings').doc(booking.hotelId).delete();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${booking.hotelId} booking has been deleted"),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(booking.hotelId),
                    subtitle: Text('${booking.checkInDate} - ${booking.checkOutDate}'),
                  ),
                );
              },
            );
          } else {
            return Text('No bookings found');
          }
        },
      ),
    );
  }
}