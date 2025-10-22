import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcovert/config/api/api_end_point.dart';
import 'package:tcovert/services/api/api_service.dart';
import 'package:tcovert/utils/app_utils.dart';

class ContactUsController extends GetxController {
  // Text editing controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  // Form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxBool isBusinessProfileExpanded = false.obs;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    subjectController.dispose();
    messageController.dispose();
    super.onClose();
  }

  // Toggle business profile expansion
  void toggleBusinessProfileExpansion() {
    isBusinessProfileExpanded.value = !isBusinessProfileExpanded.value;
  }

  // Handle send message
  Future<void> handleSendMessage() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      Map<String, String> body = {
        "name": nameController.text,
        "email": emailController.text,
        "subject": subjectController.text,
        "message": messageController.text,
      };
      var response = await ApiService.post(ApiEndPoint.contactUs, body: body);

      if (response.statusCode == 200) {
        var data = response.data;
        clearForm();
        nameController.text = data['data']['name'];
        emailController.text = data['data']['email'];
        subjectController.text = data['data']['subject'];
        messageController.text = data['data']['message'];
        Utils.successSnackBar(response.statusCode.toString(), data['message']);
      } else {
        Utils.errorSnackBar(response.statusCode.toString(), response.message);
      }
      isLoading.value = false;
    }
  }

  // Clear all form fields
  void clearForm() {
    nameController.clear();
    emailController.clear();
    subjectController.clear();
    messageController.clear();
  }

  // Form validation
  FormFieldValidator<String> validateField(String fieldName) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return '$fieldName is required';
      }
      if (fieldName == 'Email' && !GetUtils.isEmail(value)) {
        return 'Please enter a valid email';
      }
      return null;
    };
  }
}
