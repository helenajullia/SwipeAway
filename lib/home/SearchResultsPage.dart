import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../adminService/HotelCard.dart';
import '../adminService/HotelModel.dart';

class SearchResultsPage extends StatelessWidget {
  final List<Hotel> searchResults;

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          return HotelCard(
            hotel: searchResults[index],
            onSwipeLeft: () {
              saveHotel(searchResults[index]);
            },
            onSwipeRight: () {
              // Logic for swiping right (if any)
            },
          );
        },
      ),
    );
  }
}
