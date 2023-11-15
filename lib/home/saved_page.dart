import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:swipe_away/adminService/EventCard.dart';
import 'package:swipe_away/adminService/EventModel.dart';
import '../adminService/HotelCard.dart';
import '../adminService/HotelModel.dart';
import 'search_page.dart';
import 'myAccount/myAccount_page.dart';

class SavedPage extends StatefulWidget {
  @override
  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  int _currentIndex = 1; // Assuming SavedPage is at index 1
  List<Hotel> savedHotels = [];
  List<Event> savedEvents = [];
  List<Hotel> filteredHotels = [];
  List<Event> filteredEvents = [];
  String? selectedCounty;
  String eventSearchKeyword = '';

  TextEditingController countyController = TextEditingController();
  TextEditingController eventSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Immediately fetch all saved hotels and events on init.
    fetchSavedHotelsAndEvents();
  }

  // This function is called inside initState to fetch saved hotels and events.
  void fetchSavedHotelsAndEvents() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        // Fetch saved hotels
        var hotelSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('savedHotels')
            .get();
        var fetchedHotels = hotelSnapshot.docs.map((doc) => Hotel.fromMap(doc.data() as Map<String, dynamic>)).toList();

        // Fetch saved events
        var eventSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('savedEvents')
            .get();
        var fetchedEvents = eventSnapshot.docs.map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>)).toList();

        // Update the state with fetched hotels and events.
        setState(() {
          savedHotels = fetchedHotels;
          filteredHotels = List.from(savedHotels); // Show all initially
          savedEvents = fetchedEvents;
          filteredEvents = List.from(savedEvents); // Show all initially
        });
      } catch (e) {
        print('Error fetching saved items: $e');
        // Handle the error appropriately
      }
    } else {
      // Handle the case where currentUser is null
    }
  }

  void applyHotelFilter() {
    setState(() {
      filteredHotels = (selectedCounty?.isEmpty ?? true)
          ? savedHotels
          : savedHotels.where((hotel) => hotel.county == selectedCounty).toList();
    });
  }

  void applyEventFilter() {
    setState(() {
      filteredEvents = (eventSearchKeyword.isEmpty ?? true)
          ? savedEvents
          : savedEvents.where((event) => event.name.contains(eventSearchKeyword)).toList();
    });
  }

  void saveEvent(Event event) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    var existingEvent = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('events')
        .where('name', isEqualTo: event.name)
        .limit(1)
        .get();

    // Check if the event already exists
    if (existingEvent.docs.isEmpty) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('events')
          .add(event.toMap()); // Assuming Event class has a toMap() method
    } else {
      // Event already exists, show a message or handle accordingly
    }
  }

  void saveHotel(Hotel hotel) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    var existingHotel = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('savedHotels')
        .where('name', isEqualTo: hotel.name)
        .limit(1)
        .get();

    // Check if the hotel already exists
    if (existingHotel.docs.isEmpty) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('savedHotels')
          .add(hotel.toMap()); // Assuming Hotel class has a toMap() method
    } else {
      // Hotel already exists, show a message or handle accordingly
    }
  }

  void _onItemTapped(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
      switch (index) {
        case 0:
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => SearchPage()),
            ModalRoute.withName('/'), // Assuming '/' is your SearchPage route
          );
          break;
        case 2:
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MyAccountPage()),
            ModalRoute.withName('/'), // Assuming '/' is your MyAccountPage route
          );
          break;
      // No default case needed as we don't navigate when the current index is tapped
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Items', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black, // Stylish app bar color
        actions: [
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {
              // Implement sorting functionality
            },
          ),
        ],
      ),
      body: AnimationLimiter( // Wrap your ListView with AnimationLimiter
        child: ListView(
          children: AnimationConfiguration.toStaggeredList( // Add animation to your list items
            duration: const Duration(milliseconds: 375),
            childAnimationBuilder: (widget) => SlideAnimation(
              horizontalOffset: 50.0,
              child: FadeInAnimation(
                child: widget,
              ),
            ),
            children: [
              buildExpansionTile(' Hotels', filteredHotels),
              buildExpansionTile(' Events', filteredEvents),
            ],
          ),
        ),
      ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Saved'),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account'),
          ],
          currentIndex: _currentIndex,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey.shade600,
          onTap: _onItemTapped,
        ),
    );
  }

  
}

Widget buildExpansionTile(String title, List<dynamic> items) {
  return ExpansionTile(
    title: Text(title, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
    backgroundColor: Colors.white12, // Add a slight white overlay to the ExpansionTile
    children: items.map((item) => item is Hotel
        ? HotelCard(hotel: item, onSwipeLeft: () {}, onSwipeRight: () {})
        : EventCard(event: item, onSwipeLeft: () {}, onSwipeRight: () {})
    ).toList(),
  );
}
