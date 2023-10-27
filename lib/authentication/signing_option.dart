import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swipe_away/authentication/signUp.dart';


class ChooseSigningOption extends StatefulWidget {
  @override
  _ChooseSigningOptionState createState() => _ChooseSigningOptionState();
}

class _ChooseSigningOptionState extends State<ChooseSigningOption> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF171717),
      appBar: AppBar(
        backgroundColor: Color(0xFF454545),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.scale(
              scale: 2.5,
              child: Image.asset(
                'assets/icons/user_icon.png',
                color: Colors.blueGrey.shade100,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // Handle sign in button click
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(50, 50),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.8),
                    ),
                  ),
                  child: Text(
                    'Sign In',
                    style: GoogleFonts.kronaOne(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                ElevatedButton(
                  onPressed: () {
                    // Handle sign up button click
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUp()));
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(50, 50),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.08),
                    ),
                  ),
                  child: Text(
                    'Sign Up',
                    style: GoogleFonts.kronaOne(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}