import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'HotelModel.dart';

class HotelCard extends StatelessWidget {
  final Hotel hotel;
  HotelCard({required this.hotel});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Display the first image if available
            if (hotel.imageURLs.isNotEmpty)
              Image.network(
                hotel.imageURLs.first,
                fit: BoxFit.cover,
                height: 200.0,
                width: double.infinity,
              ),
            SizedBox(height: 8.0),
            Text(
              hotel.name,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text("County: ${hotel.county}"),
            Text("City: ${hotel.city}"),
            Text("Single Rooms: ${hotel.singleRooms}"),
            Text("Double Rooms: ${hotel.doubleRooms}"),
            SizedBox(height: 8.0),
            Text(
              hotel.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            // Add other elements as needed
          ],
        ),
      ),
    );
  }
}
