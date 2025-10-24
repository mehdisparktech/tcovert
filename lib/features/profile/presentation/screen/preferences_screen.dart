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
          fontSize: 20,
          fontWeight: FontWeight.w400,
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
            GetBuilder<PreferencesController>(
              builder:
                  (controller) => Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller.photoOfInterest.length,
                      itemBuilder: (context, index) {
                        return _buildPreferenceItem(
                          title: controller.photoOfInterest[index].name,
                          value: controller.photoOfInterest[index].active,
                          onChanged: (_) => controller.togglePreference(index),
                        );
                      },
                      separatorBuilder:
                          (context, index) => SizedBox(height: 24.h),
                    ),
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
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonText(
          text: title,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.white,
        ),
        CustomCheckbox(value: value, onChanged: onChanged, size: 24),
      ],
    );
  }
}
