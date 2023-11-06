import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../main.dart';

class ThemePage extends StatelessWidget {
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Theme', style: GoogleFonts.roboto()),
        backgroundColor: Colors.black,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SwitchListTile(
            title: Text(
              'Dark Mode',
              style: GoogleFonts.roboto(),
            ),
            value: themeController.isDarkModeEnabled.value,
            onChanged: (bool value) {
              themeController.toggleTheme(value);
            },
          ),

        ],
      ),
    );
  }
}
