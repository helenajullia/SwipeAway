import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
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

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  String hashedPassword = "";

  // Function to hash the password
  void hashPassword(String password) {
    final bytes = utf8.encode(password); // Encode the password as bytes
    final digest = sha256.convert(bytes); // Create a SHA-256 hash
    setState(() {
      hashedPassword = digest.toString();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF171717),
      appBar: AppBar(
        backgroundColor: Color(0xFF454545),
        leading: IconButton(
          icon: Image.asset('assets/icons/left_arrow2.png'),
          onPressed: () {
            Navigator.of(context).pop();
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Your existing content here

            Center(
              child: Image.asset(
                'assets/icons/user_icon.png',
                scale: 0.5,
                color: Colors.blueGrey.shade100,
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.08,
                  ),
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
                // First Row of TextFields
                SizedBox(height: 35),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: firstNameController,
                          decoration: InputDecoration(
                            hintText: 'First Name',
                            filled: true,
                            fillColor: Color(0x9ED9D9D9),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          style: GoogleFonts.kronaOne(
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: lastNameController,
                          decoration: InputDecoration(
                            hintText: 'Last Name',
                            filled: true,
                            fillColor: Color(0x9ED9D9D9),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
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
                // Second Row of TextFields
                SizedBox(height: 20),
                Center(
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      filled: true,
                      fillColor: Color(0x9ED9D9D9),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    style: GoogleFonts.kronaOne(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                // Third Row of TextFields
                SizedBox(height: 20),
                Center(
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      filled: true,
                      fillColor: Color(0x9ED9D9D9),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    style: GoogleFonts.kronaOne(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      fontWeight: FontWeight.w400,
                    ),
                    obscureText: true,
                  ),
                ),
                // Fourth Row of TextFields
                SizedBox(height: 20),
                Center(
                  child: TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      hintText: 'Phone No',
                      filled: true,
                      fillColor: Color(0x9ED9D9D9),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    style: GoogleFonts.kronaOne(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      fontWeight: FontWeight.w400,
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
                      primary: Color(0xFFD56A1B),
                      padding:
                      EdgeInsets.symmetric(horizontal: 80, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
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
