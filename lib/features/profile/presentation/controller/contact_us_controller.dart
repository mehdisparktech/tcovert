import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcovert/config/api/api_end_point.dart';
import 'package:tcovert/services/api/api_service.dart';
import 'package:tcovert/utils/app_utils.dart';
import '../../data/model/contact_us_request_model.dart';
import '../../data/model/contact_us_response_model.dart';

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
  ContactUsResponseModel? contactUsResponseModel;

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
    if (!formKey.currentState!.validate()) {
      return;
    }

    // Call API
    final success = await submitContactUs(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      subject: subjectController.text.trim(),
      message: messageController.text.trim(),
    );

    if (success) {
      // Clear form on success
      clearForm();
    }
  }

  /// Submit Contact Us
  Future<bool> submitContactUs({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    try {
      isLoading.value = true;

      // Create request model
      ContactUsRequestModel requestModel = ContactUsRequestModel(
        name: name,
        email: email,
        subject: subject,
        message: message,
      );

      // Make API call
      var response = await ApiService.post(
        ApiEndPoint.contactUs,
        body: requestModel.toJson(),
      );

      if (response.isSuccess) {
        contactUsResponseModel = ContactUsResponseModel.fromJson(response.data);
        Utils.successSnackBar('Success', response.message);
        return true;
      } else {
        Utils.errorSnackBar('Error', response.message);
        return false;
      }
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
      return false;
    } finally {
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
