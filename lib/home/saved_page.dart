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

        // setState(() {
        //   savedHotels = fetchedHotels;
        //   filteredHotels = List.from(savedHotels);
        // });



        var eventSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('savedEvents')
            .get();
        var fetchedEvents = eventSnapshot.docs.map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>)).toList();



        var customListsSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('customLists')
            .get();

        customListNames.clear();
        listNameToIdMap.clear();




        setState(() {
          savedHotels = fetchedHotels;
          filteredHotels = List.from(savedHotels);
          savedEvents = fetchedEvents;
          filteredEvents = List.from(savedEvents);
          for (var doc in customListsSnapshot.docs) {
            String listName = doc.data()['name'] as String;
            customListNames.add(listName);
            listNameToIdMap[listName] = doc.id; // Store the list name to ID mapping
          }
        });

      } catch (e) {
        print('Error fetching saved items: $e');

      }
    }
  }

  Future<List<Hotel>> fetchHotelsFromList(String listId) async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (userId.isEmpty) {
        throw Exception("User not logged in");
      }

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('customLists')
          .doc(listId)
          .collection('items')
          .get();

      // print("Fetched data for list $listId: ${snapshot.docs.map((doc) => doc.data()).toList()}");

      List<Hotel> hotels = snapshot.docs
          .map((doc) => Hotel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      print("fetched them");

      return hotels;

    } catch (e) {
      print('Error fetching hotels from list $listId: $e');
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

  // Future<void> deletePredefinedList(String listId) async {
  //   String userId = FirebaseAuth.instance.currentUser!.uid;
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .collection('savedHotels')
  //       .doc(listId)
  //       .delete();
  //   // Optionally, refresh your state or UI after deletion.
  // }

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
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) async {
        await deleteCustomList(listId);
        // Refresh the UI by removing the list from the state maps and calling setState
        setState(() {
          hotelsByList.remove(listId);
          customListNames.removeWhere((name) => listNameToIdMap[name] == listId);
          listNameToIdMap.removeWhere((name, id) => id == listId);
        });
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
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                List<Hotel> hotels = snapshot.data!;
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: hotels.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(hotels[index].name),
                      background: Container(color: Colors.red, alignment: Alignment.centerLeft, padding: EdgeInsets.only(left: 20), child: Icon(Icons.delete, color: Colors.white)),
                      secondaryBackground: Container(color: Colors.red, alignment: Alignment.centerRight, padding: EdgeInsets.only(right: 20), child: Icon(Icons.delete, color: Colors.white)),
                      onDismissed: (direction) async {
                        await deleteHotelFromList(hotels[index].name, listId);
                        // Remove the dismissed item from the list model
                        hotels.removeAt(index);
                        // Then show a snackbar.
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${hotels[index].name} deleted")));
                        // Optionally, refresh the list to fetch the updated data
                        // You might need to adjust this if your state management is different
                        setState(() {});
                      },
                      child: HotelCard(
                        hotel: hotels[index],
                        onSwipeLeft: () {},
                        onSwipeRight: () {},
                      ),
                    );
                  },
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
      children: <Widget>[
        ListView.builder(
          physics: NeverScrollableScrollPhysics(), // to disable ListView's scrolling
          shrinkWrap: true, // to make ListView to take space as per its children
          itemCount: items.length,
          itemBuilder: (context, index) {
            var item = items[index];
            return Dismissible(
              key: Key(item.name), // Use the 'name' as the unique identifier
              background: Container(color: Colors.red, alignment: Alignment.centerLeft, padding: EdgeInsets.only(left: 20), child: Icon(Icons.delete, color: Colors.white)),
              secondaryBackground: Container(color: Colors.red, alignment: Alignment.centerRight, padding: EdgeInsets.only(right: 20), child: Icon(Icons.delete, color: Colors.white)),
              onDismissed: (direction) {
                // Logic to delete the individual item
                if (item is Hotel) {
                  deleteHotel(item.name);
                  setState(() {
                    items.removeAt(index); // Update the list after item is dismissed
                  });
                } else if (item is Event) {
                  deleteEvent(item.name);
                }
                // Optionally show a snackbar or refresh the UI
              },
              child: item is Hotel
                  ? HotelCard(hotel: item, onSwipeLeft: () {}, onSwipeRight: () {})
                  : EventCard(event: item, onSwipeLeft: () {}, onSwipeRight: () {}),
            );
          },
        ),
      ],
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
              buildExpansionTile('Events', filteredEvents),
              buildExpansionTile('Hotels', filteredHotels),
              // buildExpansionTile('Hotels', savedHotels),
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