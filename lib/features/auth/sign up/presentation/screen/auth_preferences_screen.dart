import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tcovert/component/button/common_button.dart';
import 'package:tcovert/component/other_widgets/custom_switch.dart';
import 'package:tcovert/component/text/common_text.dart';
import 'package:tcovert/features/auth/sign up/presentation/controller/auth_preferences_controller.dart';
import 'package:tcovert/utils/constants/app_colors.dart';

class AuthPreferencesScreen extends StatelessWidget {
  const AuthPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthPreferencesController());

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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.white),
            onPressed: () {
              controller.getAuthPreferences();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: AppColors.white10.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CommonText(
                        text: "Photos of Interest",
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                        bottom: 20.h,
                      ),
                      Obx(
                        () => GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.photoOfInterest.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 3,
                                crossAxisSpacing: 8.w,
                                mainAxisSpacing: 12.h,
                              ),
                          itemBuilder: (context, index) {
                            return Obx(
                              () => _buildPreferenceItem(
                                title: controller.photoOfInterest[index].name,
                                title2: controller.photoOfInterest[index].name,
                                isSelected: controller.isPreferenceSelected(
                                  index,
                                ),
                                onTap:
                                    () => controller.togglePreferenceSelection(
                                      index,
                                      controller.photoOfInterest[index].id,
                                    ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: AppColors.white10.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CommonText(
                        text: "Permission",
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                        bottom: 20.h,
                      ),
                      _buildPermissionItem(
                        icon: Icons.location_on_outlined,
                        title: "Location Service",
                        value: controller.locationServiceEnabled,
                        onChanged: (_) => controller.toggleLocationService(),
                      ),
                      SizedBox(height: 20.h),
                      _buildPermissionItem(
                        icon: Icons.calendar_today_outlined,
                        title: "Access Calendar",
                        value: controller.accessCalendarEnabled,
                        onChanged: (_) => controller.toggleAccessCalendar(),
                      ),
                      SizedBox(height: 20.h),
                      _buildPermissionItem(
                        icon: Icons.contacts_outlined,
                        title: "Access Contacts",
                        value: controller.accessContactsEnabled,
                        onChanged: (_) => controller.toggleAccessContacts(),
                      ),
                      SizedBox(height: 20.h),
                      _buildPermissionItem(
                        icon: Icons.notifications_outlined,
                        title: "Allow Notification",
                        value: controller.allowNotificationEnabled,
                        onChanged: (_) => controller.toggleAllowNotification(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),
                CommonButton(
                  titleText: "Save",
                  onTap: () {
                    controller.savePreferences();
                  },
                  titleColor: AppColors.white,
                  buttonHeight: 52.h,
                  buttonRadius: 12.r,
                  titleSize: 16,
                  titleWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionItem({
    required IconData icon,
    required String title,
    required RxBool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.white10.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.white.withOpacity(0.8), size: 20.w),
            Expanded(
              child: CommonText(
                text: title,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.white,
              ),
            ),
            CustomSwitch(
              value: value.value,
              onChanged: onChanged,
              width: 50,
              height: 28,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceItem({
    required String title,
    required String title2,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.secondary.withOpacity(0.2)
                  : AppColors.secondary.withOpacity(0.04),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color:
                isSelected
                    ? AppColors.secondary
                    : AppColors.secondary.withOpacity(0.5),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonText(text: title, fontSize: 16.sp, color: AppColors.white),
              if (isSelected) ...[
                SizedBox(width: 8.w),
                Icon(
                  Icons.check_circle,
                  color: AppColors.secondary,
                  size: 20.w,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
