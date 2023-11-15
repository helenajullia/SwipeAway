class Booking {
  String id;
  String hotelName;
  DateTime startDate;
  DateTime endDate;

  Booking(
      {required this.id,
    required this.hotelName,
    required this.startDate,
    required this.endDate
   }
  );

  factory Booking.fromMap(Map<String, dynamic> data) {
    return Booking(
      id: data['id'],
      hotelName: data['hotelName'],
      startDate: DateTime.fromMillisecondsSinceEpoch(data['startDate']),
      endDate: DateTime.fromMillisecondsSinceEpoch(data['endDate']),
    );
  }
}
