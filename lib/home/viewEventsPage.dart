

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:swipe_away/adminService/EventCard.dart';

import '../adminService/EventModel.dart';
import '../adminService/HotelCard.dart';
import '../adminService/HotelModel.dart';

class ViewEventsPage extends StatefulWidget {
  final List<Event> searchEventResults;

  ViewEventsPage({Key? key, required this.searchEventResults}) : super(key: key);

  @override
  _ViewEventsPageState createState() => _ViewEventsPageState();
}

class _ViewEventsPageState extends State<ViewEventsPage> {
  final SwiperController swiperController = SwiperController();
  List<Event>? searchEventResults; // Declare the list here

  @override
  void initState() {
    super.initState();
    fetchEvents(); // Fetch the events when the state is initialized
  }

  Future<void> fetchEvents() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('events').get();
    List<Event> events = snapshot.docs.map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>)).toList();
    setState(() {
      searchEventResults = events; // Update the state with the fetched events
    });
  }

  // Method to save the hotel to Firestore
  void saveEvent(Event event) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('events')
        .add({
      'name': event.name,
      'county': event.county,
      'city': event.city,
      'description': event.description,
      'singleRooms': event.singleRooms,
      'doubleRooms': event.doubleRooms,
      'imageURLs': event.imageURLs,
      'pricePerSingleRoomPerNight' : event.pricePerSingleRoomPerNight,
      'pricePerDoubleRoomPerNight' : event.pricePerDoubleRoomPerNight,
    });
  }

  void _onSwipeUp(int index) {
    // Make sure to check if the index is within the bounds of the list
    if (index < 0 || index >= searchEventResults!.length) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Save Event"),
        content: Text("Do you want to save '${searchEventResults![index].name}' to your list?"),
        actions: <Widget>[
          TextButton(
            child: Text("No"),
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss the dialog
              swiperController.next(); // Move to the next event
            },
          ),
          TextButton(
            child: Text("Save"),
            onPressed: () {
              saveEvent(searchEventResults![index]); // Save using the event from the state list
              Navigator.of(context).pop(); // Dismiss the dialog
              swiperController.next(); // Move to the next event
            },
          ),
        ],
      ),
    ).then((_) {
      // This ensures that if the dialog is dismissed by tapping outside of it,
      // it will still move to the next event.
      swiperController.next();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Event> events = widget.searchEventResults;
    // Use searchEventResults from the state to build the Swiper
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Results'),
        backgroundColor: Colors.black,
      ),
      body: searchEventResults != null && searchEventResults!.isNotEmpty
          ? Swiper(
        controller: swiperController,
        itemCount: searchEventResults!.length,
        layout: SwiperLayout.STACK,
        itemWidth: MediaQuery.of(context).size.width,
        itemHeight: MediaQuery.of(context).size.height,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onVerticalDragEnd: (details) {
              if (details.primaryVelocity! < 0) {
                _onSwipeUp(index);
              }
            },
            child: EventCard(
              event: searchEventResults![index],
              onSwipeLeft: () {},
              onSwipeRight: () {},
            ),
          );
        },
      )
          : Center(child: Text('No events found')),
    );
  }
}
