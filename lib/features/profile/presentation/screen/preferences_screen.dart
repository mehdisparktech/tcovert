import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../component/text/common_text.dart';
import '../../../../component/button/common_button.dart';
import '../../../../component/other_widgets/custom_checkbox.dart';
import '../../../../utils/constants/app_colors.dart';
import '../controller/preferences_controller.dart';

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PreferencesController());

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        title: const CommonText(
          text: "Preferences",
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  _buildPreferenceItem(
                    title: "Family",
                    value: controller.familyEnabled,
                    onChanged: (_) => controller.toggleFamily(),
                  ),
                  SizedBox(height: 24.h),
                  _buildPreferenceItem(
                    title: "Nature",
                    value: controller.natureEnabled,
                    onChanged: (_) => controller.toggleNature(),
                  ),
                  SizedBox(height: 24.h),
                  _buildPreferenceItem(
                    title: "Social",
                    value: controller.socialEnabled,
                    onChanged: (_) => controller.toggleSocial(),
                  ),
                  SizedBox(height: 24.h),
                  _buildPreferenceItem(
                    title: "Friends",
                    value: controller.friendsEnabled,
                    onChanged: (_) => controller.toggleFriends(),
                  ),
                  SizedBox(height: 24.h),
                  _buildPreferenceItem(
                    title: "Travel",
                    value: controller.travelEnabled,
                    onChanged: (_) => controller.toggleTravel(),
                  ),
                  SizedBox(height: 24.h),
                  _buildPreferenceItem(
                    title: "Restaurants",
                    value: controller.restaurantsEnabled,
                    onChanged: (_) => controller.toggleRestaurants(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h),
            CommonButton(
              titleText: "Save Changes",
              onTap: () => controller.saveChanges(),
              buttonColor: AppColors.secondary,
              titleColor: AppColors.white,
              buttonHeight: 52.h,
              buttonRadius: 12.r,
              titleSize: 16,
              titleWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceItem({
    required String title,
    required RxBool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommonText(
            text: title,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.white,
          ),
          CustomCheckbox(value: value.value, onChanged: onChanged, size: 24),
        ],
      ),
    );
  }
}
