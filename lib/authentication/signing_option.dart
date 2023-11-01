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
      backgroundColor: Color(0xFFFFFFF),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: GoogleFonts.abyssinicaSil(
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                      style: GoogleFonts.abyssinicaSil(
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
                      style: GoogleFonts.abyssinicaSil(
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
      ),
    );
  }
}
