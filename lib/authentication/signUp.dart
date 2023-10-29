import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  int _currentPageIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF454545),
        leading: IconButton(
          icon: Image.asset('assets/icons/left_arrow2.png'), // Replace the icon with a left arrow
          onPressed: () {
            Navigator.of(context).pop(); // Add navigation action here
          },
        ),
        centerTitle: true,
        title: Text(
          'SwipeAway',
          style: GoogleFonts.kronaOne(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.width * 0.06,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/icons/notifications_icon.png',
              color: Colors.black,
            ),
            onPressed: () {
              // Handle notifications icon tap
            },
          ),
        ],
      ),
      body: Center(
        child: _getPageContent(_currentPageIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF454545),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/home_icon.png',
              width: MediaQuery.of(context).size.width * 0.08,
              height: MediaQuery.of(context).size.width * 0.15,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/saved_icon.png',
              width: MediaQuery.of(context).size.width * 0.08,
              height: MediaQuery.of(context).size.width * 0.15,
            ),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/bookings_icon.png',
              width: MediaQuery.of(context).size.width * 0.08,
              height: MediaQuery.of(context).size.width * 0.15,
            ),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/myAccount_icon.png',
              width: MediaQuery.of(context).size.width * 0.08,
              height: MediaQuery.of(context).size.width * 0.15,
            ),
            label: 'My Account',
          ),
        ],
        currentIndex: _currentPageIndex,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _getPageContent(int index) {
    switch (index) {
      case 0:
        return Text('Home Page Content');
      case 1:
        return Text('Saved Page Content');
      case 2:
        return Text('Bookings Page Content');
      case 3:
        return Text('My Account Page Content');
      default:
        return Text('Invalid Page');
    }
  }
}
