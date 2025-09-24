import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../component/text/common_text.dart';
import '../../../../utils/constants/app_colors.dart';

class PermissionScreen extends StatelessWidget {
  const PermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CommonText(
          text: "Permission",
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CommonText(
              text: "App Permissions",
              fontSize: 20,
              fontWeight: FontWeight.w700,
              bottom: 20,
            ),
            // Add your permissions content here
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.white10,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: const CommonText(
                text: "Permission settings will be implemented here.",
                fontSize: 14,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
