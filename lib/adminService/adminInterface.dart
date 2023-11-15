

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swipe_away/adminService/adminDashboard/manageBookings.dart';
import 'package:swipe_away/adminService/adminDashboard/manageHotels.dart';
import 'package:swipe_away/adminService/adminDashboard/manageUsers.dart';

import '../authentication/login.dart';
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
                            // Handle delete users
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