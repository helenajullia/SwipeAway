import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:swipe_away/authentication/choosing_authOption.dart';
import 'authentication/login.dart';
import 'home/myAccount/settings/notificationController.dart';
import 'home/myAccount/settings/notificationSettingsPage.dart';
//import 'home/myAccount/settings/notificationSettingsPage.dart';
import 'home/myAccount/settings/themePage.dart';
import 'introScreen/intro_page.dart';
import 'dart:async';
import 'firebase_options.dart';
import 'package:swipe_away/home/myAccount/settings/themePage.dart'; // Make sure to create this file with light and dark theme data
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseOptions);

  // Check if the app is running on Web
  if (kIsWeb) {
    // Initialize the Facebook JavaScript SDK
    await FacebookAuth.i.webAndDesktopInitialize(
      appId: "1394647538103458", // Replace with your actual Facebook App ID
      cookie: true,
      xfbml: true,
      version: "v15.0",
    );
  }

  runApp(MyApp());
  Get.lazyPut(() => NotificationController());
}

class ThemeController extends GetxController {
  var isDarkModeEnabled = false.obs;

  void toggleTheme(bool isOn) {
    isDarkModeEnabled.value = isOn;
  }
}

class MyApp extends StatelessWidget {
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
      title: 'SwipeAway',
      theme: themeController.isDarkModeEnabled.value ? ThemeData.dark() : ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: IntroScreenWithDelay(),
    ));
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
    return showIntro ? IntroScreen() : ChoosingAuthOption();
  }
}
