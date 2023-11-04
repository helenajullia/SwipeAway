import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationSettingsPage extends StatelessWidget {
  // This would be your controller where the notification logic is handled
  final NotificationController notificationController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Settings', style: GoogleFonts.roboto()),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0), // Add padding at the top
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Aligns to the top
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Enable notifications to stay up to date with the latest news and updates.',
                style: GoogleFonts.roboto(),
                textAlign: TextAlign.center,
              ),
            ),
            Card(
              margin: EdgeInsets.all(16), // Add some margin around the card
              child: SwitchListTile(
                title: Text('Enable Notifications', style: GoogleFonts.roboto()),
                value: notificationController.areNotificationsEnabled.value,
                onChanged: (bool value) {
                  notificationController.toggleNotifications(value);
                },
              ),
            ),
            // ... other items can be added here
          ],
        ),
      ),
    );
  }
}

class NotificationController extends GetxController {
  var areNotificationsEnabled = false.obs;

  void toggleNotifications(bool value) {
    areNotificationsEnabled.value = value;
    // Here you would have the logic to actually enable/disable notifications
  }
}
