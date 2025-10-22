import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../component/text/common_text.dart';
import '../../../../component/text_field/common_text_field.dart';
import '../../../../component/button/common_button.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/extensions/extension.dart';
import '../controller/contact_us_controller.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ContactUsController controller = Get.put(ContactUsController());
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
          text: "Contact Us",
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Business Profile Request Section
              _buildBusinessProfileSection(controller),
              32.height,

              // Name Field
              _buildInputField(
                label: "Name",
                controller: controller.nameController,
                hintText: "Your Name",
                validator: controller.validateField("Name"),
              ),
              20.height,

              // Email Field
              _buildInputField(
                label: "Email",
                controller: controller.emailController,
                hintText: "example@mail.com",
                keyboardType: TextInputType.emailAddress,
                validator: controller.validateField("Email"),
              ),
              20.height,

              // Subject Field
              _buildInputField(
                label: "Subject",
                controller: controller.subjectController,
                hintText: "Subject",
                validator: controller.validateField("Subject"),
              ),
              20.height,

              // Message Field
              _buildInputField(
                label: "Message",
                controller: controller.messageController,
                hintText: "Message",
                maxLines: 6,
                textInputAction: TextInputAction.done,
                validator: controller.validateField("Message"),
              ),
              40.height,

              // Send Button
              Obx(
                () => CommonButton(
                  titleText: "Send",
                  titleColor: AppColors.white,
                  buttonColor: AppColors.secondary,
                  borderColor: AppColors.secondary,
                  buttonHeight: 50,
                  buttonRadius: 8,
                  titleSize: 16,
                  titleWeight: FontWeight.w600,
                  isLoading: controller.isLoading.value,
                  onTap: controller.handleSendMessage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBusinessProfileSection(ContactUsController controller) {
    return Obx(
      () => GestureDetector(
        onTap: controller.toggleBusinessProfileExpansion,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: AppColors.white10,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppColors.transparent),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CommonText(
                text: "Request for Business Profile",
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.textFiledColor,
                textAlign: TextAlign.left,
              ),
              Icon(
                controller.isBusinessProfileExpanded.value
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: AppColors.textFiledColor,
                size: 20.sp,
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
    int maxLines = 1,
    TextInputAction textInputAction = TextInputAction.next,
    FormFieldValidator<String>? validator,
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
          maxLines: maxLines,
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
          paddingVertical: maxLines > 1 ? 16 : 14,
          validator: validator as FormFieldValidator?,
        ),
      ],
    );
  }
}
