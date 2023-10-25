import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChooseSigningOption extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFF171717),
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: screenSize.height * 0.00, // Adjust the top position of the "SwipeAway" text
            child: Container(
              width: screenSize.width,
              height: screenSize.height * 0.15,
              decoration: BoxDecoration(color: Color(0xFF454545)),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment(0.4, 0.6), // Adjust the values (-1.0 to 1.0) to control alignment
                        child: Text(
                          'SwipeAway',
                          style: GoogleFonts.kronaOne(
                            color: Colors.white,
                            fontSize: screenSize.width * 0.06,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: screenSize.width * 0.04,
                    top: screenSize.height * 0.055,
                    child: Image.asset(
                      'assets/icons/notifications_icon.png',
                      width: screenSize.width * 0.08,
                      height: screenSize.width * 0.08,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            left: screenSize.width * 0.1,
            top: screenSize.height * 0.32,
            child: Column(
              children: [
                Transform.scale(
                  scale: 2.5,
                  child: Image.asset(
                    'assets/icons/user_icon.png',
                    color: Colors.blueGrey.shade100,
                  ),
                ),
                SizedBox(height: screenSize.height * 0.1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        // Handle user button click
                      },
                      child: Container(
                        width: screenSize.width * 0.4,
                        height: screenSize.height * 0.08,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(screenSize.width * 0.08),
                        ),
                        child: Text(
                          'Sign In',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.kronaOne(
                            color: Colors.black,
                            fontSize: screenSize.width * 0.05,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: screenSize.width * 0.04),
                    InkWell(
                      onTap: () {
                        // Handle admin button click
                      },
                      child: Container(
                        width: screenSize.width * 0.4,
                        height: screenSize.height * 0.08,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(screenSize.width * 0.08),
                        ),
                        child: Text(
                          'Sign Up',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.kronaOne(
                            color: Colors.black,
                            fontSize: screenSize.width * 0.05,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: screenSize.width,
              height: screenSize.height * 0.1,
              decoration: BoxDecoration(color: Color(0xFF454545)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (final icon in [
                    'home_icon.png',
                    'saved_icon.png',
                    'bookings_icon.png',
                    'myAccount_icon.png',
                  ])
                    Column(
                      children: [
                        Image.asset(
                          'assets/icons/$icon',
                          width: screenSize.width * 0.08,
                          height: screenSize.width * 0.15,
                          color: Colors.black,
                        ),
                        Text(
                          '  ${_getLabelForIcon(icon)}   ',
                          style: GoogleFonts.kronaOne(
                            color: Colors.white,
                            fontSize: screenSize.width * 0.02,
                          ),
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

  String _getLabelForIcon(String iconName) {
    switch (iconName) {
      case 'home_icon.png':
        return 'Home';
      case 'saved_icon.png':
        return 'Saved';
      case 'bookings_icon.png':
        return 'Bookings';
      case 'myAccount_icon.png':
        return 'MyAccount';
      default:
        return '';
    }
  }
}