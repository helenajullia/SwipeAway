import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../adminService/EventModel.dart';
import 'myAccount/settings/bookingsPage.dart';

class BookingDetailsPageEvent extends StatefulWidget {
  final Event event;

  BookingDetailsPageEvent({required this.event});

  @override
  _BookingDetailsPageStateEvent createState() => _BookingDetailsPageStateEvent();
}

class _BookingDetailsPageStateEvent extends State<BookingDetailsPageEvent> {
  DateTime? checkInDate;
  DateTime? checkOutDate;
  int singleRooms = 0;
  int doubleRooms = 0;

  double calculateTotalCost() {
    if (checkInDate == null || checkOutDate == null) {
      return 0.0;
    }

    int numberOfNights = checkOutDate!.difference(checkInDate!).inDays;
    return (singleRooms * widget.event.pricePerSingleRoomPerNight +
        doubleRooms * widget.event.pricePerDoubleRoomPerNight) *
        numberOfNights.toInt();
  }

  void _showTotalCostDialog() {
    double totalCost = calculateTotalCost();
    if (totalCost > 0) {
      _showDialog('Total Trip Cost', 'The total cost for your trip is: ${totalCost.toStringAsFixed(2)} RON');
    } else {
      _showDialog('Missing Information', 'Please select both check-in and check-out dates.');
    }
  }


  Future<void> _bookEvent() async {
    double totalCost = calculateTotalCost();

    // Retrieve the current user's ID
    String? userId = FirebaseAuth.instance.currentUser!.email;

    final booking = {
      'hotelId': widget.event.name,
      'checkInDate': checkInDate,
      'checkOutDate': checkOutDate,
      'singleRooms': singleRooms,
      'doubleRooms': doubleRooms,
      'status': 'pending',
      'eventImageURL' : widget.event.imageURLs,
      'tripCost': totalCost,
    };

    // Add the booking to the user's sub-collection of bookings
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('bookings')
        .add(booking);
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: Text('Book'),
            onPressed: () async {
              await _bookEvent();
              Navigator.of(context).pop(); // Close the dialog
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => BookingsPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Booking Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            DateSelector(
              title: 'Check-in Date',
              selectedDate: checkInDate,
              onSelectDate: (DateTime date) {
                setState(() {
                  checkInDate = date;
                  if (checkOutDate != null && checkOutDate!.isBefore(checkInDate!)) {
                    checkOutDate = null; // Reset checkOutDate if it's before the new checkInDate
                  }
                });
              },
            ),
            DateSelector(
              title: 'Check-out Date',
              selectedDate: checkOutDate,
              firstSelectableDate: checkInDate?.add(Duration(days: 1)), // This should be the day after checkInDate
              onSelectDate: (DateTime date) {
                setState(() {
                  checkOutDate = date;
                });
              },
            ),


            RoomSelector(
              title: 'Single Rooms',
              count: singleRooms,
              onIncrement: () {
                setState(() {
                  if (singleRooms < 6) singleRooms++;
                });
              },
              onDecrement: () {
                setState(() {
                  if (singleRooms > 0) singleRooms--;
                });
              },
            ),
            RoomSelector(
              title: 'Double Rooms',
              count: doubleRooms,
              onIncrement: () {
                setState(() {
                  if (doubleRooms < 6) doubleRooms++;
                });
              },
              onDecrement: () {
                setState(() {
                  if (doubleRooms > 0) doubleRooms--;
                });
              },
            ),
            ElevatedButton(
              onPressed: _showTotalCostDialog,
              child: Text('Calculate Trip'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.black,
              ),
            ),// Add the rest of your UI components here
          ],
        ),
      ),
    );
  }
}

class DateSelector extends StatelessWidget {
  final String title;
  final DateTime? selectedDate;
  final DateTime? firstSelectableDate;
  final ValueChanged<DateTime> onSelectDate;

  DateSelector({
    required this.title,
    required this.selectedDate,
    this.firstSelectableDate,
    required this.onSelectDate,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(
        selectedDate == null
            ? 'Select Date'
            : DateFormat('yyyy-MM-dd').format(selectedDate!),
      ),
      trailing: Icon(Icons.calendar_today),
      onTap: () async {
        final DateTime? picked = await showCustomDatePicker(context, selectedDate, firstSelectableDate);
        if (picked != null && picked != selectedDate) {
          onSelectDate(picked);
        }
      },
    );
  }

  Future<DateTime?> showCustomDatePicker(BuildContext context, DateTime? selectedDate, DateTime? firstSelectableDate) {
    // Ensure firstSelectableDate is not before today's date
    DateTime firstDate = firstSelectableDate ?? DateTime.now();
    if (firstDate.isBefore(DateTime.now())) {
      firstDate = DateTime.now();
    }

    return showDatePicker(
      context: context,
      initialDate: selectedDate ?? firstDate,
      firstDate: firstDate,
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.black,
            secondaryHeaderColor: Colors.black,
            colorScheme: ColorScheme.light(primary: Colors.black),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
  }

}

class RoomSelector extends StatelessWidget {
  final String title;
  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  RoomSelector({
    required this.title,
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black.withOpacity(0.7),
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove_circle_outline),
                color: count > 0 ? Colors.black : Colors.grey,
                onPressed: count > 0 ? onDecrement : null,
              ),
              Text(
                '$count',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: Icon(Icons.add_circle_outline),
                color: Colors.black,
                onPressed: onIncrement,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ConfirmBookingButton extends StatelessWidget {
  final VoidCallback onConfirm;

  ConfirmBookingButton({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onConfirm,
        child: Text(
          'Confirm Booking',
          style: TextStyle(fontSize: 20),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.black),
          padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(vertical: 15),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
    );
  }
}

class BookingConfirmationDialog extends StatelessWidget {
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final int singleRooms;
  final int doubleRooms;

  BookingConfirmationDialog({
    required this.checkInDate,
    required this.checkOutDate,
    required this.singleRooms,
    required this.doubleRooms,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Confirm Your Booking'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Check-in Date: ${DateFormat('yyyy-MM-dd').format(checkInDate!)}'),
            Text('Check-out Date: ${DateFormat('yyyy-MM-dd').format(checkOutDate!)}'),
            Text('Single Rooms: $singleRooms'),
            Text('Double Rooms: $doubleRooms'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Confirm'),
          onPressed: () {
            // Handle booking confirmation logic here
          },
        ),
      ],
    );
  }
}
