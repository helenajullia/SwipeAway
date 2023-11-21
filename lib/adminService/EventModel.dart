import 'Item.dart';

class Event extends Item {
  final String name;
  final String county;
  final String city;
  final int singleRooms;
  final int doubleRooms;
  final String description;
  final double pricePerSingleRoomPerNight;
  final double pricePerDoubleRoomPerNight;
  final List<String> imageURLs;

  Event({
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

  factory Event.fromMap(Map<String, dynamic> data) {
    return Event(
      name: data['name'] as String? ?? 'Unknown Name',
      county: data['county'] as String? ?? 'Unknown County',
      city: data['city'] as String? ?? 'Unknown City',
      singleRooms: data['singleRooms'] as int? ?? 0,
      doubleRooms: data['doubleRooms'] as int? ?? 0,
      description: data['description'] as String? ?? 'No Description',
      pricePerSingleRoomPerNight: (data['pricePerSingleRoomPerNight'] as num?)?.toDouble() ?? 0.0,
      pricePerDoubleRoomPerNight: (data['pricePerDoubleRoomPerNight'] as num?)?.toDouble() ?? 0.0,
      imageURLs: List<String>.from(data['imageURLs'] ?? []),
    );
  }
}