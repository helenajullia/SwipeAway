import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  String hotelId;
  DateTime checkInDate;
  DateTime checkOutDate;
  String status;
  String firstName;
  String lastName;

  Booking({
    required this.hotelId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.status,
    required this.firstName,
    required this.lastName,
  });

  factory Booking.fromMap(Map<String, dynamic> data, String firstName, String lastName) {
    return Booking(
      hotelId: data['hotelName'] as String? ?? 'Unknown',
      checkInDate: (data['checkInDate'] as Timestamp).toDate(),
      checkOutDate: (data['checkOutDate'] as Timestamp).toDate(),
      status: data['status'] as String? ?? 'Unknown',
      firstName: firstName,
      lastName: lastName,
    );
  }
}
