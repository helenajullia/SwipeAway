class Hotel {
  final String name;
  final String county;
  final String city;
  final int singleRooms;
  final int doubleRooms;
  final String description;
  final double pricePerSingleRoomPerNight;
  final double pricePerDoubleRoomPerNight;
  final List<String> imageURLs;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'county': county,
      'city': city,
      'singleRooms': singleRooms,
      'doubleRooms': doubleRooms,
      'description': description,
      'pricePerSingleRoomPerNight': pricePerSingleRoomPerNight,
      'pricePerDoubleRoomPerNight': pricePerDoubleRoomPerNight,
      'imageURLs': imageURLs,
    };
  }

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
      pricePerSingleRoomPerNight: data['pricePerSingleRoomPerNight'] ,
      pricePerDoubleRoomPerNight: data['pricePerDoubleRoomPerNight'] ,
      imageURLs: List<String>.from(data['imageURLs'] ?? []),
    );
  }
}