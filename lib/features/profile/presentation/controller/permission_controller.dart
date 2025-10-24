import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tcovert/services/storage/storage_keys.dart';
import 'package:tcovert/services/storage/storage_services.dart';
import 'package:tcovert/utils/app_utils.dart';

class PermissionController extends GetxController {
  // Observable variables for each permission
  var locationServiceEnabled = true.obs;
  var accessCalendarEnabled = true.obs;
  var accessContactsEnabled = true.obs;
  var allowNotificationEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedPermissions();
    update();
  }

  Future<void> _loadSavedPermissions() async {
    locationServiceEnabled.value = await LocalStorage.getBool(
      LocalStorageKeys.locationServiceEnabled,
    );
    accessCalendarEnabled.value = await LocalStorage.getBool(
      LocalStorageKeys.accessCalendarEnabled,
    );
    accessContactsEnabled.value = await LocalStorage.getBool(
      LocalStorageKeys.accessContactsEnabled,
    );
    allowNotificationEnabled.value = await LocalStorage.getBool(
      LocalStorageKeys.allowNotificationEnabled,
    );
  }

  /// Save permission status to local storage
  Future<void> _savePermissionStatus(String key, bool value) async {
    await LocalStorage.setBool(key, value);
  }

  /// Toggle location service
  Future<void> toggleLocationService() async {
    if (!locationServiceEnabled.value) {
      // Request permission
      final status = await Permission.location.request();
      if (status.isGranted) {
        locationServiceEnabled.value = true;
        await _savePermissionStatus(
          LocalStorageKeys.locationServiceEnabled,
          true,
        );
      } else if (status.isDenied) {
        Utils.errorSnackBar(
          "Permission Denied",
          "Location permission is required",
        );
      } else if (status.isPermanentlyDenied) {
        Utils.errorSnackBar(
          "Permission Denied",
          "Please enable location permission from settings",
        );
        await openAppSettings();
      }
    } else {
      // Disable permission
      locationServiceEnabled.value = false;
      await _savePermissionStatus(
        LocalStorageKeys.locationServiceEnabled,
        false,
      );
    }
    update();
  }

  /// Toggle access calendar
  Future<void> toggleAccessCalendar() async {
    if (!accessCalendarEnabled.value) {
      // Request permission
      final status = await Permission.calendarFullAccess.request();
      if (status.isGranted) {
        accessCalendarEnabled.value = true;
        await _savePermissionStatus(
          LocalStorageKeys.accessCalendarEnabled,
          true,
        );
      } else if (status.isDenied) {
        Utils.errorSnackBar(
          "Permission Denied",
          "Calendar permission is required",
        );
      } else if (status.isPermanentlyDenied) {
        Utils.errorSnackBar(
          "Permission Denied",
          "Please enable calendar permission from settings",
        );
        await openAppSettings();
      }
    } else {
      // Disable permission
      accessCalendarEnabled.value = false;
      await _savePermissionStatus(
        LocalStorageKeys.accessCalendarEnabled,
        false,
      );
    }
    update();
  }

  /// Toggle access contacts
  Future<void> toggleAccessContacts() async {
    if (!accessContactsEnabled.value) {
      // Request permission
      final status = await Permission.contacts.request();
      if (status.isGranted) {
        accessContactsEnabled.value = true;
        await _savePermissionStatus(
          LocalStorageKeys.accessContactsEnabled,
          true,
        );
      } else if (status.isDenied) {
        Utils.errorSnackBar(
          "Permission Denied",
          "Contacts permission is required",
        );
      } else if (status.isPermanentlyDenied) {
        Utils.errorSnackBar(
          "Permission Denied",
          "Please enable contacts permission from settings",
        );
        await openAppSettings();
      }
    } else {
      // Disable permission
      accessContactsEnabled.value = false;
      await _savePermissionStatus(
        LocalStorageKeys.accessContactsEnabled,
        false,
      );
    }
    update();
  }

  /// Toggle allow notification
  Future<void> toggleAllowNotification() async {
    if (!allowNotificationEnabled.value) {
      // Request permission
      final status = await Permission.notification.request();
      if (status.isGranted) {
        allowNotificationEnabled.value = true;
        await _savePermissionStatus(
          LocalStorageKeys.allowNotificationEnabled,
          true,
        );
      } else if (status.isDenied) {
        Utils.errorSnackBar(
          "Permission Denied",
          "Notification permission is required",
        );
      } else if (status.isPermanentlyDenied) {
        Utils.errorSnackBar(
          "Permission Denied",
          "Please enable notification permission from settings",
        );
        await openAppSettings();
      }
    } else {
      // Disable permission
      allowNotificationEnabled.value = false;
      await _savePermissionStatus(
        LocalStorageKeys.allowNotificationEnabled,
        false,
      );
    }
    update();
  }

  // Save changes method
  void saveChanges() {
    Get.snackbar(
      'Success',
      'Permission settings saved successfully!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
