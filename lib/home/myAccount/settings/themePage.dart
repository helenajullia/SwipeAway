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
      body: Center(
        child: SwitchListTile(
          title: Text('Dark Mode',style: GoogleFonts.roboto(),),
          value: themeController.isDarkModeEnabled.value,
          onChanged: (bool value) {
            themeController.toggleTheme(value);
            //Navigator.pop(context); // Close the ThemePage after changing the theme
          },
        ),
      ),
    );
  }
}
