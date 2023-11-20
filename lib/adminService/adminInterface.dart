

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swipe_away/adminService/adminDashboard/manageBookings.dart';
import 'package:swipe_away/adminService/adminDashboard/manageHotels.dart';
import 'package:swipe_away/adminService/adminDashboard/manageUsers.dart';

import '../authentication/login.dart';
import 'BookingModel.dart';
import 'HotelModel.dart';
import 'EventModel.dart';
import 'adminDashboard/manageEvents.dart';

class AdminInterface extends StatefulWidget {
  @override
  _AdminInterfaceState createState() => _AdminInterfaceState();
}

Future<List<Hotel>> fetchHotels() async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('hotels').get();
  return snapshot.docs.map((doc) => Hotel.fromMap(doc.data() as Map<String, dynamic>)).toList();
}

Future<List<Event>> fetchEvents() async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('events').get();
  return snapshot.docs.map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>)).toList();
}


class _AdminInterfaceState extends State<AdminInterface> {

  final _auth = FirebaseAuth.instance;

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('No users found');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return CircularProgressIndicator();
          default:
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var userDoc = snapshot.data!.docs[index];
                var userData = userDoc.data() as Map<String, dynamic>; // Cast the data to a Map

                // Debugging
                print('User Data: $userData');

                String firstName = userData.containsKey('firstName') ? userData['firstName'] : 'Unknown';
                String lastName = userData.containsKey('lastName') ? userData['lastName'] : 'Unknown';
                String userEmail = userData.containsKey('email') ? userData['email'] : 'No Email';

                return Dismissible(
                  key: Key(userDoc.id),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) async {
                    await FirebaseFirestore.instance.collection('users').doc(userDoc.id).delete();

                    // Show an AlertDialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("User Deleted"),
                          content: Text("The user has been successfully deleted."),
                          actions: <Widget>[
                            TextButton(
                              child: Text("OK"),
                              onPressed: () {
                                Navigator.of(context).pop(); // Dismiss the dialog
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },

                  child: ListTile(
                    title: Text(firstName+' '+lastName),
                    subtitle: Text(userEmail),
                  ),
                );
              },
            );
        }
      },
    );
  }



  Widget _buildSignOutButton() {
    return ListTile(
      leading: Icon(Icons.exit_to_app, color: Colors.red),
      title: Text('Sign out', style: GoogleFonts.roboto(color: Colors.red)),
      onTap: () async {
        await _auth.signOut();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      },
    );
  }

  Widget _buildHotelList() {
    return FutureBuilder<List<Hotel>>(
      future: fetchHotels(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var hotel = snapshot.data![index];
              return ListTile(
                leading: hotel.imageURLs.isNotEmpty
                    ? Image.network(hotel.imageURLs.first, width: 100, height: 100, fit: BoxFit.cover)
                    : SizedBox(width: 100, height: 100, child: Center(child: Icon(Icons.image_not_supported))),
                title: Text(hotel.name),
                subtitle: Text('${hotel.city}, ${hotel.county}'),
                onTap: () {
                  _showHotelDetails(context, hotel);
                },
              );
            },
          );
        } else {
          return Text('No hotels found');
        }
      },
    );
  }

  void _showHotelDetails(BuildContext context, Hotel hotel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(hotel.name),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('County: ${hotel.county}'),
                Text('City: ${hotel.city}'),
                Text('Single Rooms: ${hotel.singleRooms}'),
                Text('Double Rooms: ${hotel.doubleRooms}'),
                // Add more details as needed
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildEventList() {
    return FutureBuilder<List<Event>>(
      future: fetchEvents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var event = snapshot.data![index];
              return ListTile(
                leading: event.imageURLs.isNotEmpty
                    ? Image.network(event.imageURLs.first, width: 100, height: 100, fit: BoxFit.cover)
                    : SizedBox(width: 100, height: 100, child: Center(child: Icon(Icons.image_not_supported))),
                title: Text(event.name),
                subtitle: Text('${event.city}, ${event.county}'),
                onTap: () {
                  _showEventDetails(context, event);
                },
              );
            },
          );
        } else {
          return Text('No events found');
        }
      },
    );
  }

  void _showEventDetails(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(event.name),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('County: ${event.county}'),
                Text('City: ${event.city}'),
                Text('Single Rooms: ${event.singleRooms}'),
                Text('Double Rooms: ${event.doubleRooms}'),
                // Add more details as needed
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  Widget _buildFeedbackList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('feedback')
          .orderBy('timestamp', descending: true) // Orders feedback by timestamp, newest first
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('No feedback found');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return CircularProgressIndicator();
          default:
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var feedbackDoc = snapshot.data!.docs[index];
                var feedbackData = feedbackDoc.data() as Map<String, dynamic>;

                return ListTile(
                  title: Text(feedbackData['message']),
                  subtitle: Text("From: ${feedbackData['email']} - Issue: ${feedbackData['issue']}"),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.check,
                      // Provide a default value of false if feedbackData['solved'] is null
                      color: (feedbackData['solved'] as bool? ?? false) ? Colors.green : Colors.grey,
                    ),
                    onPressed: () async {
                      // Toggle the 'solved' status when the check icon is tapped
                      bool isSolved = feedbackData['solved'] ?? false;
                      await FirebaseFirestore.instance
                          .collection('feedback')
                          .doc(feedbackDoc.id)
                          .update({'solved': !isSolved});
                    },
                  ),
                );
              },
            );
        }
      },
    );
  }


  Widget _buildDismissibleHotelList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('hotels').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('No hotels found');
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var hotelDoc = snapshot.data!.docs[index];
              var hotelData = hotelDoc.data() as Map<String, dynamic>;
              Hotel hotel = Hotel.fromMap(hotelData);

              return Dismissible(
                key: Key(hotelDoc.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                ),
                onDismissed: (direction) async {
                  await FirebaseFirestore.instance.collection('hotels').doc(hotelDoc.id).delete();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${hotel.name} has been deleted"),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(hotel.name),
                  subtitle: Text('${hotel.county}, ${hotel.city}'),
                  leading: (hotel.imageURLs.isNotEmpty)
                      ? Image.network(hotel.imageURLs.first, width: 100, height: 100, fit: BoxFit.cover)
                      : null,
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildDismissibleEventList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('events').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('No events found');
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var eventDoc = snapshot.data!.docs[index];
              var eventData = eventDoc.data() as Map<String, dynamic>;
              Event event = Event.fromMap(eventData);

              return Dismissible(
                key: Key(eventDoc.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                ),
                onDismissed: (direction) async {
                  await FirebaseFirestore.instance.collection('events').doc(eventDoc.id).delete();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${event.name} has been deleted"),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(event.name),
                  subtitle: Text('${event.county}, ${event.city}'),
                  leading: (event.imageURLs.isNotEmpty)
                      ? Image.network(event.imageURLs.first, width: 100, height: 100, fit: BoxFit.cover)
                      : null,
                ),
              );
            },
          );
        }
      },
    );
  }

  void _showEditEventDialog(BuildContext context, Event event) {
    TextEditingController nameController = TextEditingController(text: event.name);
    TextEditingController cityController = TextEditingController(text: event.city);
    TextEditingController countyController = TextEditingController(text: event.county);
    TextEditingController singleRoomController = TextEditingController(text:event.singleRooms.toString());
    TextEditingController doubleRoomController = TextEditingController(text: event.doubleRooms.toString());
    TextEditingController pricePerSingleRoomPerNightController = TextEditingController(text: event.pricePerSingleRoomPerNight.toString());
    TextEditingController pricePerDoubleRoomPerNightController = TextEditingController(text: event.pricePerDoubleRoomPerNight.toString());
    TextEditingController descriptionController = TextEditingController(text: event.description);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Event'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Event Name'),
                ),
                TextField(
                  controller: cityController,
                  decoration: InputDecoration(labelText: 'City Name'),
                ),
                TextField(
                  controller: countyController,
                  decoration: InputDecoration(labelText: 'County Name'),
                ),
                TextField(
                  controller: singleRoomController,
                  decoration: InputDecoration(labelText: 'Number of single rooms'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: doubleRoomController,
                  decoration: InputDecoration(labelText: 'Number of double rooms'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: pricePerSingleRoomPerNightController,
                  decoration: InputDecoration(labelText: 'Price of single room'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: pricePerDoubleRoomPerNightController,
                  decoration: InputDecoration(labelText: 'Price of double room'),
                  keyboardType: TextInputType.number,

                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Save'),
              onPressed: () {
                try {
                  // Parse and validate inputs

                  String name = nameController.text;
                  String city =  cityController.text;
                  String county = countyController.text;
                  String description = descriptionController.text;
                  int doubleRooms = int.parse(doubleRoomController.text);
                  int singleRooms = int.parse(singleRoomController.text);
                  double priceDoubleRoom = double.parse(pricePerDoubleRoomPerNightController.text);
                  double priceSingleRoom = double.parse(pricePerSingleRoomPerNightController.text);

                  // Call the update function with validated and parsed inputs
                  updateEvent(
                      name,
                      city,
                      county,
                      description,
                      singleRooms,
                      doubleRooms,
                      priceDoubleRoom,
                      priceSingleRoom
                  );
                } catch (e) {
                  print("Error parsing input: $e");
                  // Optionally, show an error message to the user
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Input Error"),
                        content: Text("Please check your inputs and try again."),
                        actions: <Widget>[
                          TextButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
                Navigator.of(context).pop();  // Close the dialog
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> updateEvent(String name, String county,
      String city, String description, int doubleRooms, int singleRooms, double pricePerDoubleRoomPerNight, double pricePerSingleRoomPerNight
      ) async {
    try {
      QuerySnapshot eventSnapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('name', isEqualTo: name)
          .get();
      for (var eventDoc in eventSnapshot.docs) {
        String eventId = eventDoc.id;
        await FirebaseFirestore.instance
            .collection('events')
            .doc(eventId)
            .update({
          'name': name,
          'county': county,
          'city': city,
          'description': description,
          'doubleRooms': doubleRooms,
          'singleRooms': singleRooms,
          'pricePerDoubleRoomPerNight': pricePerDoubleRoomPerNight,
          'pricePerSingleRoomPerNight': pricePerSingleRoomPerNight,
        })
            .then((_) => print("Event updated successfully: $eventId"))
            .catchError((error) =>
            print("Failed to update event $eventId: $error"));
      }
    } catch (e) {
      print("Error updating event: $e");
    }
  }



  void _selectEventToUpdate(BuildContext context) async {
    var events = await fetchEvents();  // Fetch the list of events
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(events[index].name),
              onTap: () {
                Navigator.of(context).pop(); // Close the bottom sheet
                _showEditEventDialog(context, events[index]); // Call the edit dialog
              },
            );
          },
        );
      },
    );
  }


  Widget _buildDismissibleBookingList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, userSnapshot) {
        if (userSnapshot.hasError) {
          return Text('Error: ${userSnapshot.error}');
        } else if (!userSnapshot.hasData || userSnapshot.data!.docs.isEmpty) {
          return Text('No users found');
        } else {
          return ListView.builder(
            itemCount: userSnapshot.data!.docs.length,
            itemBuilder: (context, userIndex) {
              var userDoc = userSnapshot.data!.docs[userIndex];
              Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>; // Corrected line

              // Nested StreamBuilder for bookings of each user
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userDoc.id)
                    .collection('bookings')
                    .snapshots(),
                builder: (context, bookingSnapshot) {
                  if (bookingSnapshot.hasError) {
                    return Text('Error: ${bookingSnapshot.error}');
                  } else if (!bookingSnapshot.hasData || bookingSnapshot.data!.docs.isEmpty) {
                    return Container(); // Return an empty container if no bookings for this user
                  } else {
                    return Column(
                      children: bookingSnapshot.data!.docs.map((bookingDoc) {
                        var bookingData = bookingDoc.data() as Map<String, dynamic>;
                        Booking booking = Booking.fromMap(bookingData, bookingDoc.id,
                            userData['firstName'], userData['lastName'], userData['email']); // Corrected line

                        return Dismissible(
                          key: Key(bookingDoc.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 20.0),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                          ),
                          onDismissed: (direction) async {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(userDoc.id)
                                .collection('bookings')
                                .doc(bookingDoc.id)
                                .delete();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Booking deleted"),
                              ),
                            );
                          },
                          child: ListTile(
                            title: Text('${userData['firstName']} ${userData['lastName']}'),
                            subtitle: Text(
                                'Booking from ${booking.checkInDate} to ${booking.checkOutDate} - Status: ${booking.status}'),
                            leading: (booking.hotelImageURL.isNotEmpty)
                                ? Image.network(booking.hotelImageURL.first, width: 100, height: 100, fit: BoxFit.cover)
                                : null,
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              );
            },
          );
        }
      },
    );
  }

  
  void _showEditHotelDialog(BuildContext context, Hotel hotel) {
    TextEditingController nameController = TextEditingController(text: hotel.name);
    TextEditingController doubleRoomsController = TextEditingController(text: hotel.doubleRooms.toString());
    TextEditingController singleRoomsController = TextEditingController(text: hotel.singleRooms.toString());
    TextEditingController priceDoubleRoomController = TextEditingController(text: hotel.pricePerDoubleRoomPerNight.toString());
    TextEditingController priceSingleRoomController = TextEditingController(text: hotel.pricePerSingleRoomPerNight.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Hotel'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Hotel Name'),
                ),
                TextField(
                  controller: doubleRoomsController,
                  decoration: InputDecoration(labelText: 'Number of Double Rooms'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: singleRoomsController,
                  decoration: InputDecoration(labelText: 'Number of Single Rooms'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: priceDoubleRoomController,
                  decoration: InputDecoration(labelText: 'Price Per Double Room Per Night'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: priceSingleRoomController,
                  decoration: InputDecoration(labelText: 'Price Per Single Room Per Night'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Save'),
              onPressed: () {
                try {
                  // Parse and validate inputs
                  int doubleRooms = int.parse(doubleRoomsController.text);
                  int singleRooms = int.parse(singleRoomsController.text);
                  double priceDoubleRoom = double.parse(priceDoubleRoomController.text);
                  double priceSingleRoom = double.parse(priceSingleRoomController.text);

                  // Call the update function with validated and parsed inputs
                  updateHotel(
                      nameController.text,  // Use name from the controller
                      doubleRooms,
                      singleRooms,
                      priceDoubleRoom,
                      priceSingleRoom
                  );
                } catch (e) {
                  print("Error parsing input: $e");
                  // Optionally, show an error message to the user
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Input Error"),
                        content: Text("Please check your inputs and try again."),
                        actions: <Widget>[
                          TextButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
                Navigator.of(context).pop();  // Close the dialog
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> updateHotel(String hotelName, int doubleRooms, int singleRooms,
      double priceDoubleRoom, double priceSingleRoom) async {
    try {
      QuerySnapshot hotelsSnapshot = await FirebaseFirestore.instance
          .collection('hotels')
          .where('name', isEqualTo: hotelName)
          .get();

      for (var hotelDoc in hotelsSnapshot.docs) {
        String hotelId = hotelDoc.id;
        await FirebaseFirestore.instance
            .collection('hotels')
            .doc(hotelId)
            .update({
          'doubleRooms': doubleRooms,
          'singleRooms': singleRooms,
          'pricePerDoubleRoomPerNight': priceDoubleRoom,
          'pricePerSingleRoomPerNight': priceSingleRoom,
        })
            .then((_) => print("Hotel updated successfully: $hotelId"))
            .catchError((error) => print("Failed to update hotel $hotelId: $error"));
      }
    } catch (e) {
      print("Error updating hotels by name $hotelName: $e");
    }
  }





  void _selectHotelToUpdate(BuildContext context) async {
    var hotels = await fetchHotels();  // Fetch the list of hotels
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: hotels.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(hotels[index].name),
              onTap: () {
                Navigator.of(context).pop(); // Close the bottom sheet
                _showEditHotelDialog(context, hotels[index]); // Call the edit dialog
              },
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.output_sharp),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return _buildSignOutButton();
                },
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Text(
                'Admin Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            ListTile(
              title: Text('Handle Issues & Feedback', style: GoogleFonts.roboto()),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: Text('Issues & Feedback', style: GoogleFonts.roboto()),
                      backgroundColor: Colors.black, // Set the background color to black
                    ),
                    body: _buildFeedbackList(), // Call the feedback list builder here
                  ),
                ));
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          Opacity(
            opacity: 0.25,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/admin.png'),
                  // Replace with your image asset or network image
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.white,
                    child: ExpansionTile(
                      leading: Icon(Icons.people, color: Colors.black),
                      title: Text(
                        'Manage Users',
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                        ),
                      ),
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.visibility, color: Colors.black),
                          title: Text('View Users', style: GoogleFonts.roboto()),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ManageUsers(), // Replace ThemePage with your actual theme page widget
                            ));
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.delete, color: Colors.black),
                          title: Text('Delete Users', style: GoogleFonts.roboto()),
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return _buildUserList(); // Call the function here
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.white,
                    child: ExpansionTile(
                      leading: Icon(Icons.hotel, color: Colors.black),
                      title: Text('Manage Hotels', style: GoogleFonts.roboto()),
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.visibility, color: Colors.black),
                          title: Text('View Hotels', style: GoogleFonts.roboto()),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Scaffold(
                                appBar: AppBar(
                                  title: Text('Hotels'),
                                  backgroundColor: Colors.black,
                                ),
                                body: _buildHotelList(),
                              ),
                            ));
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.add, color: Colors.black),
                          title: Text('Add Hotels', style: GoogleFonts.roboto()),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => HotelService(), // Replace ThemePage with your actual theme page widget
                            )
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.delete, color: Colors.black),
                          title: Text('Delete Hotels', style: GoogleFonts.roboto()),
                           onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                          return _buildDismissibleHotelList();
                        },
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.update, color: Colors.black),
                    title: Text('Update Hotels', style: GoogleFonts.roboto()),
                    onTap: () {
                      _selectHotelToUpdate(context);
                    },
                  ),
                  ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.white,
                    child: ExpansionTile(
                      leading: Icon(Icons.luggage, color: Colors.black),
                      title: Text('Manage Bookings', style: GoogleFonts.roboto()),
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.visibility, color: Colors.black),
                          title: Text('View Bookings', style: GoogleFonts.roboto()),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ManageBookings(), // Replace ThemePage with your actual theme page widget
                            )
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.delete, color: Colors.black),
                          title: Text('Delete Bookings', style: GoogleFonts.roboto()),
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return _buildDismissibleBookingList();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.white,
                    child: ExpansionTile(
                      leading: Icon(Icons.event, color: Colors.black),
                      title: Text('Manage Events', style: GoogleFonts.roboto()),
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.visibility, color: Colors.black),
                          title: Text('View Events', style: GoogleFonts.roboto()),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Scaffold(
                                appBar: AppBar(
                                  title: Text('Events'),
                                  backgroundColor: Colors.black,
                                ),
                                body: _buildEventList(),
                              ),
                            ));
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.add, color: Colors.black),
                          title: Text('Add Events', style: GoogleFonts.roboto()),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EventService(), // Replace ThemePage with your actual theme page widget
                            ));
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.delete, color: Colors.black),
                          title: Text('Delete Events', style: GoogleFonts.roboto()),
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return _buildDismissibleEventList();
                              },
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.update, color: Colors.black),
                          title: Text('Update Events', style: GoogleFonts.roboto()),
                          onTap: () {
                            _selectEventToUpdate(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}