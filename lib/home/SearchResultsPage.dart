import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:card_swiper/card_swiper.dart';
import '../adminService/HotelCard.dart';
import '../adminService/HotelModel.dart';

class SearchResultsPage extends StatelessWidget {
  final List<Hotel> searchResults;
  final SwiperController swiperController = SwiperController();

  SearchResultsPage({Key? key, required this.searchResults}) : super(key: key);

  // Method to save the hotel to Firestore
  void saveHotel(Hotel hotel) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('savedHotels')
        .add({
      'name': hotel.name,
      'county' : hotel.county,
      'city' : hotel.city,
      'description' : hotel.description,
      'singleRooms' : hotel.singleRooms,
      'doubleRooms' : hotel.doubleRooms,
      'imageURLs' : hotel.imageURLs,
    });
  }
  void _onSwipedAway(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Save Hotel"),
        content: Text("Do you want to save '${searchResults[index-1].name}' to your list?"),
        actions: <Widget>[
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text("Save"),
            onPressed: () {
              saveHotel(searchResults[index-1]);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
        backgroundColor: Colors.black,
      ),
      body: searchResults.isNotEmpty
          ? Swiper(
        controller: swiperController,
        itemCount: searchResults.length,
        layout: SwiperLayout.STACK,
        itemWidth: MediaQuery.of(context).size.width,
        itemHeight: MediaQuery.of(context).size.height,
        itemBuilder: (BuildContext context, int index) {
          return HotelCard(
            hotel: searchResults[index], onSwipeLeft: (){}, onSwipeRight: (){},
            // Remove onSwipeLeft and onSwipeRight if they're not needed
          );
        },
        onIndexChanged: (index) => _onSwipedAway(context, index),
      )
          : Center(child: Text('No hotels found')),
    );
  }
}