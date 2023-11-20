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
import 'package:google_fonts/google_fonts.dart';

class SavedPage extends StatefulWidget {
  @override
  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  int _currentIndex = 1;
  List<Hotel> savedHotels = [];
  List<Event> savedEvents = [];
  List<Hotel> filteredHotels = [];
  List<Event> filteredEvents = [];
  String? selectedCounty;
  String eventSearchKeyword = '';
  List<String> customListNames = [];
  Map<String, String> listNameToIdMap = {};
  // Define a state variable to hold the fetched hotels from all lists.
  Map<String, List<Hotel>> hotelsByList = {};
  TextEditingController countyController = TextEditingController();
  TextEditingController eventSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchSavedHotelsAndEvents();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchAllHotelsFromCustomLists();
    });
  }

  // This method will be called to fetch hotels from all custom lists
  void fetchAllHotelsFromCustomLists() async {
    // Loop through all list IDs and fetch the hotels for each one
    for (var listName in customListNames) {
      String? listId = listNameToIdMap[listName];
      if (listId != null) {
        List<Hotel> hotels = await fetchHotelsFromList(listId);
        setState(() {
          // Update the hotelsByList map with the new list of hotels
          hotelsByList[listId] = hotels;
        });
      }
    }
  }

  // Implement getListIds to return all list IDs
  List<String> getListIds() {
    // You would fetch the list IDs dynamically from Firestore or another source.
    // For now, let's assume you're fetching them from the existing listNameToIdMap.
    return listNameToIdMap.values.toList();
  }


  List<String> getListNames() {
    return customListNames;
  }

  String? getListIdByName(String listName) {
    return listNameToIdMap[listName];
  }

  Future<bool> _onWillPop() async {
    setState(() {
      _currentIndex = 0;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SearchPage()),
    );
    return false;
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
    String? selectedListId = await _promptSelectList(context);

    if (selectedListId==null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No list selected. Hotel not saved.")),
      );
      return;
    }

    var existingEvent = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('savedEvents')
        .where('eventId', isEqualTo: event.name)
        .limit(1)
        .get();

    if (existingEvent.docs.isEmpty) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('savedEvents')
          .add(event.toMap());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Event saved successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Event already saved")),
      );
    }
  }

  void saveHotel(Hotel hotel) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String? selectedListId = await _promptSelectList(context);

    if (selectedListId!=null && selectedListId.isNotEmpty) {
      // User did not select a list or canceled the operation.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No list selected. Hotel not saved.")),
      );
      return;
    }

    var existingHotel = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('customLists')
        .doc(selectedListId)
        .collection('items')
        .where('name', isEqualTo: hotel.name)
        .limit(1)
        .get();

    if (existingHotel.docs.isEmpty) {
      // If the hotel is not already in the list, save it.
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('customLists')
          .doc(selectedListId)
          .collection('items')
          .add(hotel.toMap());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hotel saved successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hotel already exists in the selected list.")),
      );
    }
  }

  void _createNewList(BuildContext context) {
    TextEditingController listNameController = TextEditingController();

    showDialog(
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
                String userId = FirebaseAuth.instance.currentUser!.uid;
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .collection('customLists')
                    .add({'name': listName});

                // Refetch the lists to update the UI
                fetchSavedHotelsAndEvents();

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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

  void fetchSavedHotelsAndEvents() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        var hotelSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('savedHotels')
            .get();
        var fetchedHotels = hotelSnapshot.docs.map((doc) => Hotel.fromMap(doc.data() as Map<String, dynamic>)).toList();

        var eventSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('savedEvents')
            .get();
        var fetchedEvents = eventSnapshot.docs.map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>)).toList();

        setState(() {
          savedHotels = fetchedHotels;
          filteredHotels = List.from(savedHotels);
          savedEvents = fetchedEvents;
          filteredEvents = List.from(savedEvents);
        });

        var customListsSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('customLists')
            .get();

        customListNames.clear();
        listNameToIdMap.clear();

        for (var doc in customListsSnapshot.docs) {
          String listName = doc.data()['name'] as String;
          customListNames.add(listName);
          listNameToIdMap[listName] = doc.id; // Store the list name to ID mapping
        }

      } catch (e) {
        print('Error fetching saved items: $e');

      }
    }
  }

  Future<List<Hotel>> fetchHotelsFromList(String listId) async {
    try {
      // Ensure the user ID is valid.
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (userId.isEmpty) {
        throw Exception("User not logged in");
      }

      // Fetch the hotel data from the specified list.
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('customLists')
          .doc(listId)
          .collection('items')
          .get();

      // Convert the query snapshot into a list of Hotels.
      List<Hotel> hotels = snapshot.docs
          .map((doc) => Hotel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      return hotels;
    } catch (e) {
      // Handle any errors that occur during the fetch operation.
      print(e); // Consider logging the error or using a more sophisticated error handling strategy.
      return []; // Return an empty list on error.
    }
  }

  Future<void> deleteCustomList(String listId) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('customLists')
        .doc(listId)
        .delete();
    // Optionally, refresh your state or UI after deletion.
  }

  Future<void> deleteHotelFromList(String hotelName, String listId) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    // Find the hotel by name and then delete it
    var querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('customLists')
        .doc(listId)
        .collection('items')
        .where('name', isEqualTo: hotelName)
        .get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
    // Optionally, refresh your state or UI after deletion.
  }

  Future<void> deleteHotel(String hotelName) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    // Find the hotel by name and then delete it
    var querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('savedHotels')
        .where('name', isEqualTo: hotelName)
        .get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
    // Optionally, refresh your state or UI after deletion.
  }
  Future<void> deleteEvent(String eventName) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    // Find the event by name and then delete it
    var querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('savedEvents')
        .where('name', isEqualTo: eventName)
        .get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
    // Optionally, refresh your state or UI after deletion.
  }

  Widget buildExpansionTileList(String title, String listId) {
    return Dismissible(
      key: Key(listId),
      background: Container(color: Colors.red, alignment: Alignment.centerLeft, padding: EdgeInsets.only(left: 20), child: Icon(Icons.delete, color: Colors.white)),
      secondaryBackground: Container(color: Colors.red, alignment: Alignment.centerRight, padding: EdgeInsets.only(right: 20), child: Icon(Icons.delete, color: Colors.white)),
      onDismissed: (direction) {
        // Add your logic to delete the entire list here
        deleteCustomList(listId);
        // Optionally show a snackbar or refresh the UI
      },
      child: ExpansionTile(
        title: Text(title, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white12,
        children: [
          FutureBuilder<List<Hotel>>(
            future: fetchHotelsFromList(listId),
            builder: (BuildContext context, AsyncSnapshot<List<Hotel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                List<Hotel> hotels = snapshot.data!;
                return Column(
                  children: hotels.map((hotel) => Dismissible(
                    key: Key(hotel.name),
                    background: Container(color: Colors.red, alignment: Alignment.centerLeft, padding: EdgeInsets.only(left: 20), child: Icon(Icons.delete, color: Colors.white)),
                    secondaryBackground: Container(color: Colors.red, alignment: Alignment.centerRight, padding: EdgeInsets.only(right: 20), child: Icon(Icons.delete, color: Colors.white)),
                    onDismissed: (direction) {
                      // Add your logic to delete the individual hotel here
                      deleteHotelFromList(hotel.name, listId);
                      // Optionally show a snackbar or refresh the UI
                    },
                    child: HotelCard(
                      hotel: hotel,
                      onSwipeLeft: () {}, // You can implement swipe left action if needed
                      onSwipeRight: () {}, // You can implement swipe right action if needed
                    ),
                  )).toList(),
                );
              } else {
                return Center(child: Text('No hotels found in this list'));
              }
            },
          ),
        ],
      ),
    );
  }


  Widget buildExpansionTile(String title, List<dynamic> items) {
    return ExpansionTile(
      title: Text(title, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
      backgroundColor: Colors.white12,
      children: items.map((item) {
        return Dismissible(
          key: Key(item is Hotel ? item.name : item.name), // Use the 'name' as the unique identifier
          background: Container(color: Colors.red, alignment: Alignment.centerLeft, padding: EdgeInsets.only(left: 20), child: Icon(Icons.delete, color: Colors.white)),
          secondaryBackground: Container(color: Colors.red, alignment: Alignment.centerRight, padding: EdgeInsets.only(right: 20), child: Icon(Icons.delete, color: Colors.white)),
          onDismissed: (direction) {
            // Logic to delete the individual item
            if (item is Hotel) {
              deleteHotel(item.name);
            } else if (item is Event) {
              deleteEvent(item.name);
            }
            // Optionally show a snackbar or refresh the UI
          },
          child: item is Hotel
              ? HotelCard(hotel: item, onSwipeLeft: () {}, onSwipeRight: () {})
              : EventCard(event: item, onSwipeLeft: () {}, onSwipeRight: () {}),
        );
      }).toList(),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Items', style: GoogleFonts.roboto()),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => _onWillPop(),
        ),
        elevation: 0,
      ),
      body: AnimationLimiter(
        child: ListView(
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 375),
            childAnimationBuilder: (widget) =>
                SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),
            children: [
              buildExpansionTile('Hotels', filteredHotels),

              buildExpansionTile('Events', filteredEvents),

              ...customListNames.map((listName) {
                String? listId = getListIdByName(listName);
                if (listId != null) {
                  return buildExpansionTileList(listName, listId);
                } else {
                  return ListTile(
                    title: Text('Error: List ID not found for $listName'),
                  );
                }
              }).toList(),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _createNewList(context),
        child: Icon(Icons.add, color: Colors.white),
        // Set the color of the icon here
        backgroundColor: Colors.black,
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }



  Widget buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Saved'),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account'),
      ],
      currentIndex: _currentIndex,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey.shade600,
      onTap: onTabTapped,
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SearchPage()),
        );
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyAccountPage()),
        );
        break;
    }
  }
}