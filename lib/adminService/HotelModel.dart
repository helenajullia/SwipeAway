class Hotel {
  final String name;
  final String county;
  final String city;
  final int singleRooms;
  final int doubleRooms;
  final String description;
  final int pricePerSingleRoomPerNight;
  final int pricePerDoubleRoomPerNight;
  final List<String> imageURLs;

  Hotel({
    required this.name,
    required this.county,
    required this.city,
    required this.singleRooms,
    required this.doubleRooms,
    required this.description,
    required this.pricePerDoubleRoomPerNight,
    required this.pricePerSingleRoomPerNight,
    required this.imageURLs,
  });

  factory Hotel.fromMap(Map<String, dynamic> data) {
    return Hotel(
      name: data['name'],
      county: data['county'],
      city: data['city'],
      singleRooms: data['singleRooms'],
      doubleRooms: data['doubleRooms'],
      description: data['description'],
      pricePerSingleRoomPerNight: data['pricePerSingleRoomPerNight'] is int ? data['pricePerSingleRoomPerNight'] : int.tryParse(data['pricePerSingleRoomPerNight'].toString()) ?? 0,
      pricePerDoubleRoomPerNight: data['pricePerDoubleRoomPerNight'] is int ? data['pricePerDoubleRoomPerNight'] : int.tryParse(data['pricePerDoubleRoomPerNight'].toString()) ?? 0,
      imageURLs: List<String>.from(data['imageURLs'] ?? []),
    );
  }
}