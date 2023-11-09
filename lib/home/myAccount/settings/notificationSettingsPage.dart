import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'notificationController.dart';

class NotificationSettingsPage extends StatelessWidget {
  final NotificationController notificationController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Settings', style: GoogleFonts.roboto()),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
              margin: EdgeInsets.all(16),
              child: Obx(() => SwitchListTile(
                title: Text('Enable Notifications', style: GoogleFonts.roboto()),
                value: notificationController.areNotificationsEnabled.value,
                onChanged: (bool value) {
                  notificationController.toggleNotifications(value);
                },
              )),
            ),
          ],
        ),
      ),
    );
  }
}