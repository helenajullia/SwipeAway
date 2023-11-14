import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'HotelModel.dart';

class HotelCard extends StatelessWidget {
  final Hotel hotel;
  final Function onSwipeLeft;
  final Function onSwipeRight;

  HotelCard({
    required this.hotel,
    required this.onSwipeLeft,
    required this.onSwipeRight,
  });

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.velocity.pixelsPerSecond.dx > 0) {
          // Swiped Right
          onSwipeRight();
        } else if (details.velocity.pixelsPerSecond.dx < 0) {
          // Swiped Left
          onSwipeLeft();
        }
      },
      child: Card(
        elevation: 4.0,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (hotel.imageURLs.isNotEmpty)
                Image.network(
                  hotel.imageURLs.first,
                  fit: BoxFit.cover,
                  height: screenSize.height * 0.65,
                  width: screenSize.width,
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
      ),
    );
  }
}
