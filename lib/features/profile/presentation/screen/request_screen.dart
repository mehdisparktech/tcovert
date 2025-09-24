import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../component/text/common_text.dart';
import '../../../../component/text_field/common_text_field.dart';
import '../../../../component/button/common_button.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/extensions/extension.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const CommonText(
          text: "Request",
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              40.height,

              // Name Field
              _buildInputField(
                label: "Name",
                controller: nameController,
                hintText: "Jhon Lora",
              ),
              20.height,

              // Email Field
              _buildInputField(
                label: "Email",
                controller: emailController,
                hintText: "www.jhonlura@mail.com",
                keyboardType: TextInputType.emailAddress,
              ),
              20.height,

              // URL Field
              _buildInputField(
                label: "URL",
                controller: urlController,
                hintText: "https://www.example.com/restaurant-demo",
                keyboardType: TextInputType.url,
              ),
              40.height,

              // Send Button
              CommonButton(
                titleText: "Send",
                titleColor: AppColors.white,
                buttonColor: AppColors.secondary,
                borderColor: AppColors.secondary,
                buttonHeight: 50,
                buttonRadius: 8,
                titleSize: 16,
                titleWeight: FontWeight.w600,
                isLoading: isLoading,
                onTap: _handleSendRequest,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          text: label,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.white,
          textAlign: TextAlign.left,
          bottom: 8,
        ),
        CommonTextField(
          controller: controller,
          hintText: hintText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          fillColor: AppColors.white10,
          hintTextColor: AppColors.textFiledColor,
          textColor: AppColors.white,
          borderColor: AppColors.transparent,
          borderRadius: 10,
          paddingHorizontal: 16,
          paddingVertical: 14,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '$label is required';
            }
            if (label == 'Email' && !GetUtils.isEmail(value)) {
              return 'Please enter a valid email';
            }
            if (label == 'URL' && !GetUtils.isURL(value)) {
              return 'Please enter a valid URL';
            }
            return null;
          },
        ),
      ],
    );
  }

  void _handleSendRequest() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        isLoading = false;
      });

      // Show success message
      Get.snackbar(
        "Success",
        "Your request has been sent successfully!",
        backgroundColor: AppColors.secondary,
        colorText: AppColors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );

      // Clear form
      nameController.clear();
      emailController.clear();
      urlController.clear();
    }
  }
}