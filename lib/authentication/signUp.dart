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
      backgroundColor: Color(0xFF171717),
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/icons/user_icon.png',
                    scale: 0.5,
                    color: Colors.blueGrey.shade100,
                  ),
                ),
                SizedBox(height: 10), // Move the "Sign Up" text down slightly
                Center(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.08),
                    ),
                    child: Text(
                      'Sign Up',
                        style: GoogleFonts.kronaOne(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width * 0.06,
                          fontWeight: FontWeight.w400,
                        ),
                    ),
                  ),
                ),
                // First Row of Buttons
                SizedBox(height: 35),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Handle button 1 click
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color(0x9ED9D9D9), // Set the button color
                          padding: EdgeInsets.symmetric(horizontal: 45, vertical: 8), // Adjust button size
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30), // Adjust the button's border radius
                          ),
                        ),
                        child: Text(
                          'First Name: ',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.kronaOne(
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(width: 10), // Add spacing between buttons
                      ElevatedButton(
                        onPressed: () {
                          // Handle button 1 click
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color(0x9ED9D9D9), // Set the button color
                          padding: EdgeInsets.symmetric(horizontal: 45, vertical: 8), // Adjust button size
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30), // Adjust the button's border radius
                          ),
                        ),
                        child: Text(
                          'Last Name: ',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.kronaOne(
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Second Row of Buttons
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle button 1 click
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0x9ED9D9D9), // Set the button color
                      padding: EdgeInsets.symmetric(horizontal: 160, vertical: 2), // Adjust button size
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Adjust the button's border radius
                      ),
                    ),
                    child: Text(
                      'Email:: ',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.kronaOne(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width * 0.03,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                // Third Row of Buttons
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle button 1 click
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0x9ED9D9D9), // Set the button color
                      padding: EdgeInsets.symmetric(horizontal: 145, vertical: 1), // Adjust button size
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Adjust the button's border radius
                      ),
                    ),
                    child: Text(
                      'Password: ',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.kronaOne(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width * 0.03,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                // Fourth Row of Buttons
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle button 1 click
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0x9ED9D9D9), // Set the button color
                      padding: EdgeInsets.symmetric(horizontal: 145, vertical: 1), // Adjust button size
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Adjust the button's border radius
                      ),
                    ),
                    child: Text(
                      'Phone No.: ',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.kronaOne(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width * 0.03,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle button 1 click
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFD56A1B), // Set the button color
                      padding: EdgeInsets.symmetric(horizontal: 80, vertical: 8), // Adjust button size
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Adjust the button's border radius
                      ),
                    ),
                    child: Text(
                      'Submit',
                      style: GoogleFonts.kronaOne(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width * 0.06,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
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
