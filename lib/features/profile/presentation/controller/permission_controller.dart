import 'package:get/get.dart';

class PermissionController extends GetxController {
  // Observable variables for each permission
  var locationServiceEnabled = true.obs;
  var accessCalendarEnabled = true.obs;
  var accessContactsEnabled = true.obs;
  var allowNotificationEnabled = true.obs;

  // Toggle methods for each permission
  void toggleLocationService() => locationServiceEnabled.value = !locationServiceEnabled.value;
  void toggleAccessCalendar() => accessCalendarEnabled.value = !accessCalendarEnabled.value;
  void toggleAccessContacts() => accessContactsEnabled.value = !accessContactsEnabled.value;
  void toggleAllowNotification() => allowNotificationEnabled.value = !allowNotificationEnabled.value;

  // Save changes method
  void saveChanges() {
    // TODO: Implement save logic (API call, local storage, etc.)
    Get.snackbar(
      'Success',
      'Permission settings saved successfully!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}