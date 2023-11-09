import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swipe_away/adminService/adminDashboard/manageUsers.dart';

import '../authentication/login.dart';

class AdminInterface extends StatefulWidget {
  @override
  _AdminInterfaceState createState() => _AdminInterfaceState();
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
              title: Text(
                'Handle Issues & Suggestions',
                style: GoogleFonts.roboto(
                    color: Colors.black), // Set the text color to black
              ),
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
                            // Handle view users
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.add, color: Colors.black),
                          title: Text('Add Hotels', style: GoogleFonts.roboto()),
                          onTap: () {
                            // Handle view users
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.delete, color: Colors.black),
                          title: Text('Delete Hotels', style: GoogleFonts.roboto()),
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
                      leading: Icon(Icons.luggage, color: Colors.black),
                      title: Text('Manage Bookings', style: GoogleFonts.roboto()),
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.visibility, color: Colors.black),
                          title: Text('View Bookings', style: GoogleFonts.roboto()),
                          onTap: () {
                            // Handle view users
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
                // ... more cards for other options
              ],
            ),
          ),
        ],
      ),
    );
  }
}
