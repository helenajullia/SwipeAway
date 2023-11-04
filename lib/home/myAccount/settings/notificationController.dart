import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class NotificationController extends GetxController {
  var areNotificationsEnabled = false.obs;

  void toggleNotifications(bool value) {
    areNotificationsEnabled.value = value;
    if (value) {
      // Code to enable notifications
    } else {
      // Code to disable notifications
    }
    update(); // Trigger a UI update in GetX
  }
}