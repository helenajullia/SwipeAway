import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:card_swiper/card_swiper.dart';
import '../adminService/HotelCard.dart';
import '../adminService/HotelModel.dart';

class SearchResultsPage extends StatefulWidget {
  final List<Hotel> searchResults;

  SearchResultsPage({Key? key, required this.searchResults}) : super(key: key);

  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final SwiperController swiperController = SwiperController();

  // Method to save the hotel to Firestore
  void saveHotel(Hotel hotel) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('savedHotels')
        .add({
      'name': hotel.name,
      'county': hotel.county,
      'city': hotel.city,
      'description': hotel.description,
      'singleRooms': hotel.singleRooms,
      'doubleRooms': hotel.doubleRooms,
      'imageURLs': hotel.imageURLs,
    });
  }

  void _onSwipeUp(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Save Hotel"),
        content: Text("Do you want to save '${widget.searchResults[index].name}' to your list?"),
        actions: <Widget>[
          TextButton(
            child: Text("No"),
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss the dialog
              swiperController.next(); // Move to the next hotel
            },
          ),
          TextButton(
            child: Text("Save"),
            onPressed: () {
              saveHotel(widget.searchResults[index]);
              Navigator.of(context).pop(); // Dismiss the dialog
              swiperController.next(); // Move to the next hotel
            },
          ),
        ],
      ),
    ).then((_) {
      // This ensures that if the dialog is dismissed by tapping outside of it,
      // it will still move to the next hotel.
      swiperController.next();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
        backgroundColor: Colors.black,
      ),
      body: widget.searchResults.isNotEmpty
          ? Swiper(
        controller: swiperController,
        itemCount: widget.searchResults.length,
        layout: SwiperLayout.STACK,
        itemWidth: MediaQuery.of(context).size.width,
        itemHeight: MediaQuery.of(context).size.height,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onVerticalDragEnd: (details) {
              if (details.primaryVelocity! < 0) { // Swiped Up
                _onSwipeUp(index);
              }
            },
            child: HotelCard(
              hotel: widget.searchResults[index],
              onSwipeLeft: () {}, // Do nothing when swiped left
              onSwipeRight: () {}, // Do nothing when swiped right
            ),
          );
        },
      )
          : Center(child: Text('No hotels found')),
    );
  }
}
