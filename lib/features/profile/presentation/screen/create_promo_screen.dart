import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../component/text/common_text.dart';
import '../../../../component/text_field/common_text_field.dart';
import '../../../../component/button/common_button.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/extensions/extension.dart';

class CreatePromoScreen extends StatefulWidget {
  const CreatePromoScreen({super.key});

  @override
  State<CreatePromoScreen> createState() => _CreatePromoScreenState();
}

class _CreatePromoScreenState extends State<CreatePromoScreen> {
  final TextEditingController promoTitleController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool generateQRCode = true;
  bool generatePromoCode = false;

  @override
  void initState() {
    super.initState();
    promoTitleController.text = "20% flat Discount";
    discountController.text = "40%";
    startDateController.text = "dd/mm/yyyy";
    endDateController.text = "dd/mm/yyyy";
  }

  @override
  void dispose() {
    promoTitleController.dispose();
    discountController.dispose();
    startDateController.dispose();
    endDateController.dispose();
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
          text: "Create Promo",
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
              // Promo Title Field
              _buildInputField(
                label: "Promo Title",
                controller: promoTitleController,
              ),
              24.height,

              // Discount Field
              _buildInputField(
                label: "Discount",
                controller: discountController,
              ),
              24.height,

              // Description Section
              _buildDescriptionSection(),
              24.height,

              // Start Date Field
              _buildInputField(
                label: "Start date",
                controller: startDateController,
                isDateField: true,
              ),
              24.height,

              // End Date Field
              _buildInputField(
                label: "End date",
                controller: endDateController,
                isDateField: true,
              ),
              32.height,

              // Generate QR Code Toggle
              _buildToggleSection(
                title: "Generate QR Code",
                value: generateQRCode,
                onChanged: (value) {
                  setState(() {
                    generateQRCode = value;
                  });
                },
              ),
              24.height,

              // Generate Promo Code Toggle
              _buildToggleSection(
                title: "Generate Promo Code",
                value: generatePromoCode,
                onChanged: (value) {
                  setState(() {
                    generatePromoCode = value;
                  });
                },
              ),
              40.height,

              // Create Button
              CommonButton(
                titleText: "Create",
                titleColor: AppColors.white,
                buttonColor: AppColors.secondary,
                borderColor: AppColors.secondary,
                buttonHeight: 50,
                buttonRadius: 8,
                titleSize: 16,
                titleWeight: FontWeight.w600,
                isLoading: isLoading,
                onTap: _handleCreatePromo,
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
    bool isDateField = false,
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
          fillColor: AppColors.white10,
          hintTextColor: AppColors.textFiledColor,
          textColor: AppColors.white,
          borderColor: AppColors.transparent,
          borderRadius: 10,
          paddingHorizontal: 16,
          paddingVertical: 14,
          onTap: isDateField ? () => _selectDate(controller) : null,
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
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonText(
          text: "Description",
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.white,
          textAlign: TextAlign.left,
          bottom: 8,
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.white10,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBulletPoint("Offer valid on select handcrafted beverages"),
              8.height,
              _buildBulletPoint("Valid until December 31, 2024"),
              8.height,
              _buildBulletPoint("Cannot be combined with other offers"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4.w,
          height: 4.h,
          margin: EdgeInsets.only(top: 6.h, right: 8.w),
          decoration: const BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: CommonText(
            text: text,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.white,
            textAlign: TextAlign.left,
            maxLines: 2,
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

  void _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.secondary,
              onPrimary: AppColors.white,
              surface: AppColors.textfieldColor,
              onSurface: AppColors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.secondary),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.text =
          "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
    }
  }

  void _handleCreatePromo() async {
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
        "Promo created successfully!",
        backgroundColor: AppColors.secondary,
        colorText: AppColors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );

      // Navigate back
      Get.back();
    }
  }
}
