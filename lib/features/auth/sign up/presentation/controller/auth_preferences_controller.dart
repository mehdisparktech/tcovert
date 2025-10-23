import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tcovert/config/api/api_end_point.dart';
import 'package:tcovert/features/auth/sign%20up/data/model/auth_preferences_model.dart';
import 'package:tcovert/features/home/presentation/screen/home_screen.dart';
import 'package:tcovert/services/api/api_service.dart';
import 'package:tcovert/services/storage/storage_keys.dart';
import 'package:tcovert/services/storage/storage_services.dart';
import 'package:tcovert/utils/app_utils.dart';
import 'package:tcovert/utils/log/error_log.dart';

class AuthPreferencesController extends GetxController {
  bool isLoading = false;
  bool isLoadingVerify = false;
  RxBool locationServiceEnabled = true.obs;
  RxBool accessCalendarEnabled = true.obs;
  RxBool accessContactsEnabled = true.obs;
  RxBool allowNotificationEnabled = true.obs;
  RxList<PhotoOfInterest> photoOfInterest = <PhotoOfInterest>[].obs;
  RxSet<int> selectedPreferences = <int>{}.obs;
  RxList<String> selectedPhotoOfInterest = <String>[].obs;
  AuthPreferencesModel? authPreferencesModel;

  @override
  void onInit() {
    super.onInit();
    _loadSavedPermissions();
    getAuthPreferences();
    update();
  }

  /// Load saved permissions from local storage
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

  /// Get auth preferences
  void getAuthPreferences() async {
    try {
      isLoading = true;
      update();
      var response = await ApiService.get(
        ApiEndPoint.authPreferences,
        header: {'Authorization': 'Bearer ${LocalStorage.token}'},
      );
      if (response.statusCode == 200) {
        authPreferencesModel = AuthPreferencesModel.fromJson(response.data);
        photoOfInterest.clear();
        if (authPreferencesModel!.data.isNotEmpty) {
          for (var element in authPreferencesModel!.data) {
            photoOfInterest.add(element);
          }
        }
      } else {
        Utils.errorSnackBar(response.statusCode.toString(), response.message);
      }
    } catch (e) {
      Utils.errorSnackBar(e.toString(), e.toString());
    } finally {
      isLoading = false;
      update();
    }
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

  /// Toggle preference selection
  void togglePreferenceSelection(int index, String number) {
    if (selectedPreferences.contains(index)) {
      selectedPreferences.remove(index);
      selectedPhotoOfInterest.remove(number);
    } else {
      selectedPhotoOfInterest.add(number);
      selectedPreferences.add(index);
    }
    update();
  }

  /// Check if preference is selected
  bool isPreferenceSelected(int index) {
    return selectedPreferences.contains(index);
  }

  /// Save preferences
  Future<void> savePreferences() async {
    try {
      isLoadingVerify = true;
      update();
      var response = await ApiService.patch(
        ApiEndPoint.user,
        body: {'preferences': selectedPhotoOfInterest},
        header: {'Authorization': 'Bearer ${LocalStorage.token}'},
      );
      if (response.statusCode == 200) {
        profileApiCall();
      } else {
        Utils.errorSnackBar(response.statusCode.toString(), response.message);
      }
    } catch (e) {
      Utils.errorSnackBar(e.toString(), e.toString());
    } finally {
      isLoadingVerify = false;
      update();
    }
  }

  Future<void> profileApiCall() async {
    try {
      var profileResponse = await ApiService.get(
        ApiEndPoint.profile,
        header: {"Authorization": "Bearer ${LocalStorage.token}"},
      );
      if (profileResponse.statusCode == 200) {
        var profileData = profileResponse.data;
        LocalStorage.userId = profileData['data']['_id'];
        LocalStorage.myRole = profileData['data']['role'];
        LocalStorage.status = profileData['data']['status'];
        LocalStorage.verified = profileData['data']['verified'];
        LocalStorage.myImage = profileData['data']['profileImage'];
        LocalStorage.myName = profileData['data']['name'];
        LocalStorage.myEmail = profileData['data']['email'];
        LocalStorage.setString(LocalStorageKeys.myRole, LocalStorage.myRole);
        LocalStorage.setString(LocalStorageKeys.status, LocalStorage.status);
        LocalStorage.setBoolValue(
          LocalStorageKeys.verified,
          LocalStorage.verified,
        );
        LocalStorage.setString(LocalStorageKeys.myImage, LocalStorage.myImage);
        LocalStorage.setString(LocalStorageKeys.myName, LocalStorage.myName);
        LocalStorage.setString(LocalStorageKeys.myEmail, LocalStorage.myEmail);
        Get.offAll(() => const HomeScreen());
      } else {
        Utils.errorSnackBar(
          profileResponse.statusCode.toString(),
          profileResponse.message,
        );
        errorLog(profileResponse.message, source: "Profile Api Call");
      }
    } catch (e) {
      Utils.errorSnackBar(e.toString(), e.toString());
      errorLog(e.toString(), source: "Profile Api Call");
    }
  }

  @override
  void dispose() {
    photoOfInterest.clear();
    super.dispose();
  }
}
