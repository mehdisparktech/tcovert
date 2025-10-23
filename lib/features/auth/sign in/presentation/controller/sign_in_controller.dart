import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tcovert/features/home/presentation/screen/home_screen.dart';
import 'package:tcovert/utils/app_utils.dart';
import 'package:tcovert/utils/log/error_log.dart';
import '../../../../../services/api/api_service.dart';
import '../../../../../config/api/api_end_point.dart';
import '../../../../../services/storage/storage_keys.dart';
import '../../../../../services/storage/storage_services.dart';

class SignInController extends GetxController {
  /// Sign in Button Loading variable
  bool isLoading = false;

  /// email and password Controller here
  TextEditingController emailController = TextEditingController(
    text: kDebugMode ? 'abdullahalnoman1512@gmail.com' : '',
  );
  TextEditingController passwordController = TextEditingController(
    text: kDebugMode ? 'Abdullahalnoman1512@' : "",
  );

  /// Sign in Api call here

  Future<void> signInUser() async {
    try {
      isLoading = true;
      update();

      Map<String, String> body = {
        "email": emailController.text,
        "password": passwordController.text,
      };

      var response = await ApiService.post(
        ApiEndPoint.signIn,
        body: body,
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        var data = response.data;
        LocalStorage.setBool(LocalStorageKeys.isLogIn, true);
        LocalStorage.setString(LocalStorageKeys.token, data['data']['token']);
        await profileApiCall();
        emailController.clear();
        passwordController.clear();
      } else {
        Get.snackbar(response.statusCode.toString(), response.message);
      }
    } catch (e) {
      Utils.errorSnackBar(e.toString(), e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  /// Profile Api call here
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
}
