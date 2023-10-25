import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChooseUserOrAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF171717),
      body: Stack(
        children: [
          // Title at the top
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              width: 390,
              height: 120,
              decoration: BoxDecoration(color: Color(0xFF454545)),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'SwipeAway',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.kronaOne(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          height: 5,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 16,
                    top: 45,
                    child: Image.asset(
                      'assets/icons/notifications_icon.png', // Replace with the path to your existing icon
                      width: 30, // Adjust the width as needed
                      height: 30, // Adjust the height as needed
                      color: Colors.black, // Adjust the color as needed
                    ),
                  ),
                ],
              ),
            ),
          ),




          // User and Admin Buttons (Centered, Side by Side)
          Positioned(
            left: 30,
            top: 250,
            child: Column(
              children: [
                // Icon above the buttons
                Transform.scale(
                  scale: 3.0, // Increase the scale value to make the icon larger
                  child: Image.asset(
                    'assets/icons/myAccount_icon.png',
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 80), // Adjust the space between the icon and buttons
                // User and Admin Buttons (Centered, Side by Side)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        // Handle user button click
                      },
                      child: Container(
                        width: 160,
                        height: 60,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          'User',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.kronaOne(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    InkWell(
                      onTap: () {
                        // Handle admin button click
                      },
                      child: Container(
                        width: 160,
                        height: 60,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          'Admin',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.kronaOne(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),


          // Navigation (Moved to the bottom)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: 390,
              height: 100, // You can adjust the height
              decoration: BoxDecoration(color: Color(0xFF454545)),
              child: Column(
                children: [
                  SizedBox(height: 20), // Adjust the height as needed
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Wrap each Column with Align to align the content at the bottom
                      Column(
                        children: [
                          Image.asset(
                            'assets/icons/home_icon.png',
                            width: 30,
                            height: 30,
                            color: Colors.black,
                          ),
                          Text(
                            '  Home   ',
                            style: GoogleFonts.kronaOne(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Image.asset(
                            'assets/icons/saved_icon.png',
                            width: 30,
                            height: 30,
                            color: Colors.black,
                          ),
                          Text(
                            'Saved   ',
                            style: GoogleFonts.kronaOne(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Image.asset(
                            'assets/icons/bookings_icon.png',
                            width: 30,
                            height: 30,
                            color: Colors.black,
                          ),
                          Text(
                            'Bookings   ',
                            style: GoogleFonts.kronaOne(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Image.asset(
                            'assets/icons/myAccount_icon.png',
                            width: 30,
                            height: 30,
                            color: Colors.black,
                          ),
                          Text(
                            'MyAccount',
                            style: GoogleFonts.kronaOne(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}