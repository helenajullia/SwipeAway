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
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  List<Hotel> hotelsInList = [];

  void saveHotel(Hotel hotel, String listId) async {

    var hotelCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('customLists')
        .doc(listId)
        .collection('items');

    var existingHotel = await hotelCollection
        .where('name', isEqualTo: hotel.name)
        .limit(1)
        .get();

    if (existingHotel.docs.isEmpty) {
      await hotelCollection.add(hotel.toMap());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hotel saved successfully.')),
      );
      refreshHotelList(listId); // Refresh the list to show the newly added hotel
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('This hotel is already in the list.')),
      );
    }
  }

  Future<List<dynamic>> fetchItemsForList(String listId) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('customLists')
        .doc(listId) // Use listId instead of listName
        .collection('items')
        .get();

    // Map the documents to your data models, e.g., Hotel or Event
    List<dynamic> items = snapshot.docs.map((doc) => Hotel.fromMap(doc.data() as Map<String, dynamic>)).toList();

    return items;
  }

// Function to fetch hotels from a list
  Future<List<Hotel>> fetchHotelsFromList(String listId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('customLists')
        .doc(listId)
        .collection('items')
        .get();

    // Cast each document data to `Map<String, dynamic>` before passing it to `Hotel.fromMap`
    return snapshot.docs
        .map((doc) => Hotel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

// Call this function after you save a hotel and want to refresh the list
  void refreshHotelList(String listId) async {
    List<Hotel> hotels = await fetchHotelsFromList(listId);
    // Update your state and UI with the fetched hotels
    setState(() {
      // Assuming you have a state variable that holds the list of hotels
      this.hotelsInList = hotels;
    });
  }

  // Method to prompt the user to select or add a list


  // Method to create a new list and return its ID
  Future<String?> _createNewList(BuildContext context) async {
    TextEditingController listNameController = TextEditingController();

    String? newListId = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create New List'),
          content: TextField(
            controller: listNameController,
            decoration: InputDecoration(hintText: "List Name"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Create'),
              onPressed: () async {
                String listName = listNameController.text;
                if (listName.isNotEmpty) {
                  DocumentReference newList = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .collection('customLists')
                      .add({'name': listName});
                  Navigator.of(context).pop(newList.id);
                }
              },
            ),
          ],
        );
      },
    );
    return newListId; // This should be the ID of the newly created list
  }

  // This method is invoked when the user decides to save a hotel.
  void _onSaveHotel(Hotel hotel) async {
    String? selectedListId = await _promptSelectList(context);
    if (selectedListId != null && selectedListId.isNotEmpty) {
      // Proceed with saving the hotel to the selected list
      saveHotel(hotel, selectedListId);
    }
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
              // Here you should pass the listId as well. Assuming you have it available.
              _onSaveHotel(widget.searchResults[index]);
              Navigator.of(context).pop();
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

  Future<String?> _promptSelectList(BuildContext context) async {
    String? selectedListId;
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Fetch the list names from Firestore
    QuerySnapshot listSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('customLists')
        .get();

    List<Map<String, String>> listNames = listSnapshot.docs
        .map((doc) {
      var data = doc.data() as Map<String, dynamic>?; // The data can be null, hence the '?'
      // Use null-aware operators to handle possible null values
      var name = data?['name'];
      if (name is String) {
        return {
          'id': doc.id, // This is the document ID
          'name': name,
        };
      }
      return null; // Return null if the document's data is null or 'name' is not a string
    })
        .where((item) => item != null) // Remove nulls
        .cast<Map<String, String>>() // Cast the non-null items to the correct type
        .toList();


    // Show the dialog
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select a List'),
          content: SingleChildScrollView(
            child: Column(
              children: listNames.map((item) {
                return ListTile(
                  title: Text(item['name'] as String),
                  onTap: () {
                    selectedListId = item['id']; // This should be the actual document ID
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Create New List'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog before opening a new one
                _createNewList(context);
              },
            ),
          ],
        );
      },
    );

    return selectedListId; // Return the selected list ID
  }
}
