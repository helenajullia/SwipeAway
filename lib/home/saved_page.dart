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
    String userId = FirebaseAuth.instance.currentUser!.uid; // Get the current user's UID
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('savedHotels')
          .get();
      var fetchedHotels = snapshot.docs.map((doc) => Hotel.fromMap(doc.data() as Map<String, dynamic>)).toList();
      setState(() {
        savedHotels = fetchedHotels;
      });
    } catch (e) {
      print('Error fetching saved hotels: $e');
      // Handle the error appropriately
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
            ? Center(child: CircularProgressIndicator()) // Show loading indicator while data is being fetched
            : ListView.builder(
          itemCount: savedHotels.length,
          itemBuilder: (context, index) {
            return HotelCard(
              hotel: savedHotels[index],
              onSwipeLeft: () {/* Logic if needed */},
              onSwipeRight: () {/* Logic if needed */},
            );
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
