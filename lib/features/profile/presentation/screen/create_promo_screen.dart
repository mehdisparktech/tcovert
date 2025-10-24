import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../component/text/common_text.dart';
import '../../../../component/text_field/common_text_field.dart';
import '../../../../component/button/common_button.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/extensions/extension.dart';
import '../controller/create_promo_controller.dart';

class CreatePromoScreen extends StatelessWidget {
  CreatePromoScreen({super.key});

  final CreatePromoController controller = Get.put(CreatePromoController());

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
          text: "Create Promo",
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
              // Promo Title Field
              _buildInputField(
                label: "Promo Title",
                textController: controller.promoTitleController,
              ),
              24.height,

              // Discount Field
              _buildInputField(
                label: "Discount (%)",
                textController: controller.discountController,
                keyboardType: TextInputType.number,
              ),
              24.height,

              // Description Field
              _buildInputField(
                label: "Description",
                textController: controller.descriptionController,
                maxLines: 4,
              ),
              24.height,

              // Start Date Field
              _buildInputField(
                label: "Start date",
                textController: controller.startDateController,
                isDateField: true,
              ),
              24.height,

              // End Date Field
              _buildInputField(
                label: "End date",
                textController: controller.endDateController,
                isDateField: true,
              ),
              32.height,

              // Generate QR Code Toggle
              Obx(
                () => _buildToggleSection(
                  title: "Generate QR Code",
                  value: controller.generateQRCode.value,
                  onChanged: controller.toggleQRCode,
                ),
              ),
              24.height,

              // Generate Promo Code Toggle
              Obx(
                () => _buildToggleSection(
                  title: "Generate Promo Code",
                  value: controller.generatePromoCode.value,
                  onChanged: controller.togglePromoCode,
                ),
              ),
              40.height,

              // Create Button
              Obx(
                () => CommonButton(
                  titleText: "Create",
                  titleColor: AppColors.white,
                  buttonColor: AppColors.secondary,
                  borderColor: AppColors.secondary,
                  buttonHeight: 50,
                  buttonRadius: 8,
                  titleSize: 16,
                  titleWeight: FontWeight.w600,
                  isLoading: controller.isLoading.value,
                  onTap: controller.handleCreatePromo,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController textController,
    bool isDateField = false,
    TextInputType? keyboardType,
    int maxLines = 1,
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
        Builder(
          builder: (context) => CommonTextField(
            controller: textController,
            fillColor: AppColors.white10,
            hintTextColor: AppColors.textFiledColor,
            textColor: AppColors.white,
            borderColor: AppColors.transparent,
            borderRadius: 10,
            paddingHorizontal: 16,
            paddingVertical: 14,
            keyboardType: keyboardType ?? TextInputType.text,
            maxLines: maxLines,
            readOnly: isDateField,
            onTap: isDateField
                ? () => controller.selectDate(context, label == "Start date")
                : null,
            suffixIcon:
                isDateField
                    ? Icon(
                      Icons.calendar_today_outlined,
                      color: AppColors.textFiledColor,
                      size: 20.sp,
                    )
                    : null,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '$label is required';
              }
              if (label == "Discount (%)" && int.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildToggleSection({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonText(
          text: title,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.white,
          textAlign: TextAlign.left,
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.secondary,
          activeTrackColor: AppColors.secondary.withOpacity(0.3),
          inactiveThumbColor: AppColors.grey,
          inactiveTrackColor: AppColors.grey.withOpacity(0.3),
        ),
      ],
    );
  }

}
