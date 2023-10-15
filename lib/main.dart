import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'introScreen/intro_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

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
      home: IntroScreen(),
    );
  }
}
