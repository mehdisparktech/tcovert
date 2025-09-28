import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../component/text/common_text.dart';
import '../../../../component/button/common_button.dart';
import '../../../../component/other_widgets/custom_switch.dart';
import '../../../../utils/constants/app_colors.dart';
import '../controller/permission_controller.dart';

class PermissionScreen extends StatelessWidget {
  const PermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PermissionController());

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        title: const CommonText(
          text: "Permission",
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
                children: [
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
          color: AppColors.grey.withOpacity(0.1),
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
}
