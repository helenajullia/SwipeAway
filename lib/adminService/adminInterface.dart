import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swipe_away/adminService/adminDashboard/manageUsers.dart';

import '../authentication/login.dart';

class AdminInterface extends StatefulWidget {
  @override
  _AdminInterfaceState createState() => _AdminInterfaceState();
}

class _AdminInterfaceState extends State<AdminInterface> {
  // Authentication instance
  final _auth = FirebaseAuth.instance;

  // Other state and methods...

  Widget _buildSignOutButton() {
    return ListTile(
      leading: Icon(Icons.exit_to_app, color: Colors.red),
      title: Text('Sign out', style: GoogleFonts.roboto(color: Colors.red)),
      onTap: () async {
        // Sign out from FirebaseAuth
        await _auth.signOut();
        // Redirect to the login page
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
              // Assuming you want to show the sign out as a drawer or popup menu item
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
              //selected: _selectedDestination == 0,
              //onTap: () => selectDestination(0),
            ),

            // Add other ListTile widgets for more menu items...
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          // Background image with opacity
          Opacity(
            opacity: 0.25, // Adjust the opacity as needed
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
          // Your scrollable content on top of the background image
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Add Widgets here for your admin interface
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
