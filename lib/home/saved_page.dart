import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    fetchSavedHotels();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (_currentIndex == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SearchPage()),
      );
    } else if (_currentIndex == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyAccountPage()),
      );
    }
  }

  Future<void> fetchSavedHotels() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        var snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('savedHotels')
            .get();

        // Using a Map to ensure uniqueness of hotels based on a unique identifier
        Map<String, Hotel> hotelsMap = {};

        for (var doc in snapshot.docs) {
          var hotel = Hotel.fromMap(doc.data() as Map<String, dynamic>);
          // Assuming each hotel has a unique 'id' or use any unique property
          hotelsMap[hotel.name] = hotel;
        }

        setState(() {
          savedHotels = hotelsMap.values.toList();
        });
      } catch (e) {
        print('Error fetching saved hotels: $e');
        // Handle the error appropriately
      }
    } else {
      // Handle the case where currentUser is null
    }
  }
  Future<bool> _onWillPop() async {
    setState(() {
      _currentIndex = 0;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SearchPage()),
    );
    return false; // Prevents the default back button behavior
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Saved', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.black),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () => _onWillPop(),
          ),
        ),
        body: savedHotels.isEmpty
            ? Center(child: Text('No saved hotels found')) // Handle empty data
            : ListView.builder(
          itemCount: savedHotels.length,
          itemBuilder: (context, index) {
            Hotel? hotel = savedHotels[index];
            if (hotel != null) {
              return HotelCard(
                hotel: hotel,
                onSwipeLeft: () {/* Logic if needed */},
                onSwipeRight: () {/* Logic if needed */},
              );
            } else {
              return Text("Hotel data is not available.");
            }
          },
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
      ),
    );
  }
}
