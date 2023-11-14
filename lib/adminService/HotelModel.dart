class Hotel {
  final String name;
  final String county;
  final String city;
  final int singleRooms;
  final int doubleRooms;
  final String description;
  final List<String> imageURLs;

  Hotel({
    required this.name,
    required this.county,
    required this.city,
    required this.singleRooms,
    required this.doubleRooms,
    required this.description,
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
      imageURLs: List<String>.from(data['imageURLs'] ?? []),
    );
  }
}
