import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminInterface extends StatefulWidget {
  @override
  _AdminInterfaceState createState() => _AdminInterfaceState();
}

class _AdminInterfaceState extends State<AdminInterface> {
  int _selectedDestination = 0;

  void selectDestination(int index) {
    setState(() {
      _selectedDestination = index;
    });
    // Here, you could navigate to other pages or perform other actions based on the menu selection
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Admin Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
         actions: [
           IconButton(
            icon: Icon(Icons.settings),
             onPressed: () {
               // Navigate to settings page or show sign out option
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
              title: Text('Dashboard', style: GoogleFonts.roboto()),
              selected: _selectedDestination == 0,
              onTap: () => selectDestination(0),
            ),
            ListTile(
              title: Text('Manage Users', style: GoogleFonts.roboto()),
              selected: _selectedDestination == 1,
              onTap: () => selectDestination(1),
            ),
            ListTile(
              title: Text('Manage Hotels', style: GoogleFonts.roboto()),
              selected: _selectedDestination == 2,
              onTap: () => selectDestination(2),
            ),
            ListTile(
              title: Text('Manage Bookings', style: GoogleFonts.roboto()),
              selected: _selectedDestination == 3,
              onTap: () => selectDestination(3),
            ),
            // Add other ListTile widgets for more menu items...
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Add Widgets here for your admin interface
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.white,
                child: ListTile(
                  leading: Icon(Icons.people, color: Colors.black),
                  title: Text('Manage Users', style: GoogleFonts.roboto()),
                  onTap: () {
                    // Handle manage users
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.white,
                child: ListTile(
                  leading: Icon(Icons.hotel, color: Colors.black),
                  title: Text('Manage Hotels', style: GoogleFonts.roboto()),
                  onTap: () {
                    // Handle manage hotels
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.white,
                child: ListTile(
                  leading: Icon(Icons.luggage, color: Colors.black),
                  title: Text('Manage Bookings', style: GoogleFonts.roboto()),
                  onTap: () {
                    // Handle manage hotels
                  },
                ),
              ),
            ),
            // ... more cards for other options
          ],
        ),
      ),
    );
  }
}
