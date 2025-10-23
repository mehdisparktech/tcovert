import 'package:get/get.dart';
import 'package:tcovert/config/api/api_end_point.dart';
import 'package:tcovert/services/api/api_service.dart';
import 'package:tcovert/utils/app_utils.dart';

class PreferencesController extends GetxController {
  // Observable variables for each preference
  var familyEnabled = true.obs;
  var natureEnabled = false.obs;
  var socialEnabled = true.obs;
  var friendsEnabled = true.obs;
  var travelEnabled = false.obs;
  var restaurantsEnabled = true.obs;
  RxBool isLoading = false.obs;
  // Toggle methods for each preference
  void toggleFamily() => familyEnabled.value = !familyEnabled.value;
  void toggleNature() => natureEnabled.value = !natureEnabled.value;
  void toggleSocial() => socialEnabled.value = !socialEnabled.value;
  void toggleFriends() => friendsEnabled.value = !friendsEnabled.value;
  void toggleTravel() => travelEnabled.value = !travelEnabled.value;
  void toggleRestaurants() =>
      restaurantsEnabled.value = !restaurantsEnabled.value;

  // Save changes method
  Future<void> saveChanges() async {
    try {
      isLoading.value = true;
      Map<String, dynamic> body = {
        "family": familyEnabled.value.toString(),
        "nature": natureEnabled.value.toString(),
        "social": socialEnabled.value.toString(),
        "friends": friendsEnabled.value.toString(),
        "travel": travelEnabled.value.toString(),
        "restaurants": restaurantsEnabled.value.toString(),
      };
      var response = await ApiService.post(ApiEndPoint.preferences, body: body);
      if (response.statusCode == 200) {
        Utils.successSnackBar(response.statusCode.toString(), response.message);
      } else {
        Utils.errorSnackBar(response.statusCode.toString(), response.message);
      }
    } catch (e) {
      Utils.errorSnackBar(e.toString(), e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
