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
            hotel: searchResults[index],
            // You don't necessarily need these if the Swiper handles the swiping
             onSwipeLeft: () => saveHotel(searchResults[index]),
             onSwipeRight: () => {},
          );
        },
        onIndexChanged: (index) {
          // This is triggered when the card is swiped away
          // Here, you could call saveHotel if you need to save the swiped away hotel
        },
      )
          : Center(
        child: Text('No hotels found'),
      ),
    );
  }
}
