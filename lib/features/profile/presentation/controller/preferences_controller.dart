import 'package:get/get.dart';

class PreferencesController extends GetxController {
  // Observable variables for each preference
  var familyEnabled = true.obs;
  var natureEnabled = false.obs;
  var socialEnabled = true.obs;
  var friendsEnabled = true.obs;
  var travelEnabled = false.obs;
  var restaurantsEnabled = true.obs;

  // Toggle methods for each preference
  void toggleFamily() => familyEnabled.value = !familyEnabled.value;
  void toggleNature() => natureEnabled.value = !natureEnabled.value;
  void toggleSocial() => socialEnabled.value = !socialEnabled.value;
  void toggleFriends() => friendsEnabled.value = !friendsEnabled.value;
  void toggleTravel() => travelEnabled.value = !travelEnabled.value;
  void toggleRestaurants() => restaurantsEnabled.value = !restaurantsEnabled.value;

  // Save changes method
  void saveChanges() {
    // TODO: Implement save logic (API call, local storage, etc.)
    Get.snackbar(
      'Success',
      'Preferences saved successfully!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}