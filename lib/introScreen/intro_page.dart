import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  double _fontSize = 40.0;
  bool _grow = true;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    Future.delayed(Duration(milliseconds: 3000), () {
      if (mounted) {
        setState(() {
          _fontSize = _grow ? 40.0 : 37.0; // Adjust the difference in font sizes
          _grow = !_grow;
          _startAnimation();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double targetHeight = screenHeight * 0.40;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Align(
        alignment: Alignment(0, -1),
        child: Column(
          children: [
            SizedBox(height: targetHeight),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 20.0, end: _fontSize),
              duration: Duration(milliseconds: 2000), // Increase duration for slower animation
              builder: (context, fontSize, child) {
                return Text(
                  'SwipeAway',
                  style: GoogleFonts.kronaOne(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 30.0),
            Text(
              '-your guide to Romanian accommodations-',
              style: GoogleFonts.abhayaLibre(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}