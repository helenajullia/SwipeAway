import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'authentication/signing_option.dart';
import 'introScreen/intro_page.dart';
import 'dart:async';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseOptions);
  runApp(MyApp());
}


Future<void> initializeFirebase() async {
  try {
    await Firebase.initializeApp();
  } catch (e) {
    // Handle any Firebase initialization errors here.
    print("Firebase initialization error: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SwipeAway',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: IntroScreenWithDelay(), // Use IntroScreenWithDelay to control navigation
    );
  }
}

class IntroScreenWithDelay extends StatefulWidget {
  @override
  _IntroScreenWithDelayState createState() => _IntroScreenWithDelayState();
}

class _IntroScreenWithDelayState extends State<IntroScreenWithDelay> {
  bool showIntro = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          showIntro = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showIntro ? IntroScreen() : ChooseSigningOption(),
    );
  }
}
