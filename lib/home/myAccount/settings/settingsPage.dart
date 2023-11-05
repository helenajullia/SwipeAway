import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swipe_away/home/myAccount/settings/changePassword.dart';
import 'package:swipe_away/home/myAccount/settings/themePage.dart';
import 'package:swipe_away/home/myAccount/settings/walletPage.dart';

import 'notificationSettingsPage.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: GoogleFonts.roboto()),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            ListTile(
              title: Text('Theme', style: GoogleFonts.roboto()),
              leading: Icon(Icons.palette),
              onTap: () {
                // This will push the ThemePage onto the navigation stack
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ThemePage(), // Replace ThemePage with your actual theme page widget
                ));
              },
            ),
            ListTile(
              title: Text('Notification Settings', style: GoogleFonts.roboto()),
              leading: Icon(Icons.notifications),
              onTap: () {
                // This will push the ThemePage onto the navigation stack
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NotificationSettingsPage(), // Replace ThemePage with your actual theme page widget
                ));
              },
            ),
            ListTile(
              title: Text('Wallet', style: GoogleFonts.roboto()),
              leading: Icon(Icons.account_balance_wallet),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => WalletPage(),
                ));
              },
            ),
            ListTile(
              title: Text('Change Password', style: GoogleFonts.roboto()),
              leading: Icon(Icons.lock),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChangePassword(),
                ));
              },
            ),
            // ... Add other ListTile widgets for each setting as needed
          ],
        ).toList(),
      ),
    );
  }
}
