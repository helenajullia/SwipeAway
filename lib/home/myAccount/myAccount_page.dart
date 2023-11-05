import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swipe_away/home/myAccount/reviewsPage.dart';
import 'package:swipe_away/home/myAccount/settings/settingsPage.dart';
import 'package:swipe_away/home/saved_page.dart';
import 'package:swipe_away/home/search_page.dart';
import '../../authentication/login.dart';
import 'helpFeedbackPage.dart';

class MyAccountPage extends StatefulWidget {
  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class UserDetails {
  String firstName; // Only first name
  String email;

  UserDetails({required this.firstName, required this.email});
}

class _MyAccountPageState extends State<MyAccountPage> {
  int _currentIndex = 2; // Assuming index 2 is for the account page
  UserDetails _userDetails = UserDetails(firstName: '', email: '');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _getUserDetails().then((details) {
      setState(() {
        _userDetails = details;
      });
    });
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
          title: Text('My Account', style: GoogleFonts.roboto()),
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => _onWillPop(),
          ),
          elevation: 0,
        ),
      body: ListView(
        children: <Widget>[
          _buildAvatar(_userDetails),
          _buildListItem(Icons.rate_review_rounded, 'Reviews'),
          _buildListItem(Icons.settings, 'Settings'),
          _buildListItem(Icons.help, 'Help & feedback'),
          _buildSignOutButton(),
        ],
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
      ),
    );
  }

  String getInitials(String name) {
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }



  Future<UserDetails> _getUserDetails() async {
    // Assuming you are using the currently logged-in user's email to fetch their document
    User? user = _auth.currentUser;
    if (user != null) {
      var userDoc = await _firestore.collection('users').doc(user.email).get();
      // Make sure your user documents have a 'firstName' field
      String firstName = userDoc.data()?['firstName'] ?? '';
      String email = user.email!; // Using the non-null assertion operator as we know the user is logged in
      return UserDetails(firstName: firstName, email: email);
    } else {
      // Handle the case where the user is not logged in or there is no user
      throw Exception('No user logged in');
    }
  }

  // String getInitials(String name) {
  //   return name.isNotEmpty ? name[0].toUpperCase() : '?';
  // }

  Widget _buildAvatar(UserDetails userDetails) {
    if(userDetails.firstName.isEmpty){// Function to extract initial from the first name
      return Center(child: CircularProgressIndicator());}
    // Removed UserAccountsDrawerHeader and replaced with custom Container
    return Container(
      color: Colors.black,
      width: double.infinity, // as wide as the parent
      height: 200.0, // fixed height for the container
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center children vertically
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 40,
            child: Text(
              userDetails.firstName.isNotEmpty ? getInitials(userDetails.firstName) : "?",
              style: TextStyle(fontSize: 40.0, color: Colors.black),
            ),
          ),
          SizedBox(height: 16), // Provides space between the avatar and the text
          Text(
            'Hi, ${userDetails.firstName}!👋🏻',
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 24.0, // Adjust the font size as needed
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignOutButton() {
    return ListTile(
      leading: Icon(Icons.exit_to_app, color: Colors.red),
      title: Text('Sign out', style: GoogleFonts.roboto(color: Colors.red)),
      onTap: () async {
        // Sign out from FirebaseAuth
        await _auth.signOut();
        // Redirect to the login page
        Navigator.of(context).pushReplacement( // Use pushReplacement to prevent coming back to the account page after signing out
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      },
    );
  }

  Widget _buildListItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: GoogleFonts.roboto(color: Colors.black)),
      onTap: () {
        switch (title) {
          case 'Help & feedback':
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HelpFeedbackPage(userEmail: _userDetails.email),
            ));
            break;
          case 'Settings':
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SettingsPage(),
            ));
            break;
          case 'Reviews':
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ReviewPage(),
            ));

        // Add other cases for different list items if needed
        }
      },
    );
  }



  Widget buildBottomNavigationBar() {
    return BottomNavigationBar(
      //backgroundColor: Colors.white,
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

    // Use a switch statement to handle the navigation
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SearchPage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SavedPage()),
        );
        break;
    // No need for a case 2 because we are already on the MyAccountPage
    }
  }
}
