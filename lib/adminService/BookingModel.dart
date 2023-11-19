import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  String hotelId;
  DateTime checkInDate;
  DateTime checkOutDate;
  String status;
  String firstName;
  String lastName;
  String docId;
  String email;
  int singleRooms;
  int doubleRooms;
  List<String> hotelImageURL;

  Booking({
    required this.hotelId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.status,
    required this.firstName,
    required this.lastName,
    required this.docId,
    required this.email,
    required this.singleRooms,
    required this.doubleRooms,
    required this.hotelImageURL,
  });

  factory Booking.fromMap(Map<String, dynamic> data,String docId, String firstName, String lastName, String email) {
    // Safely extract hotelImageURLs
    List<String> imageUrls = [];
    if (data['hotelImageURL'] != null && data['hotelImageURL'] is List) {
      imageUrls = List<String>.from(data['hotelImageURL'] as List);
    }

    return Booking(
      hotelId: data['hotelId'] as String? ?? 'Unknown',
      checkInDate: (data['checkInDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      checkOutDate: (data['checkOutDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: data['status'] as String? ?? 'Unknown',
      firstName: firstName,
      lastName: lastName,
      docId: docId,
      email: data['email'] as String? ?? 'Unknown',
      singleRooms: (data['singleRooms']),
      doubleRooms: (data['doubleRooms']),
      hotelImageURL: imageUrls, // Using the safely extracted list
    );
  }
}
