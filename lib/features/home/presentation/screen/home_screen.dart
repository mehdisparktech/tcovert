import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tcovert/features/home/presentation/widgets/business_information_bottom_sheet.dart';
import '../../../../component/text/common_text.dart';
import '../../../../component/image/common_image.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_images.dart';
import '../controller/home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.mapBackground),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              // Top Header
              _buildHeader(controller),

              // Map Placeholder (will be replaced with Google Maps later)
              Expanded(
                child: Stack(
                  children: [
                    // Sample markers overlay
                    Obx(() => Stack(children: _buildSampleMarkers(controller))),

                    // Bottom User Card
                    Obx(() => _buildBottomUserCard(controller)),

                    // My Location Button
                    _buildLocationButton(controller),
                    // User Bottom Sheet
                    _buildUserBottomSheet(controller, context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(HomeController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: [
          // Search Bar
          Expanded(
            child: Container(
              height: 45.h,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(25.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  SizedBox(width: 15.w),
                  Icon(Icons.search, color: AppColors.grey, size: 20.sp),
                  SizedBox(width: 10.w),
                  const Expanded(
                    child: CommonText(
                      text: "Nearby Friends",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 15.w),
          // Profile Avatar
          GestureDetector(
            onTap: controller.navigateToProfile,
            child: CircleAvatar(
              radius: 22.r,
              backgroundColor: AppColors.white,
              child: CircleAvatar(
                radius: 20.r,
                backgroundColor: AppColors.grey,
                child: ClipOval(
                  child: CommonImage(
                    imageSrc: AppImages.profile,
                    height: 40,
                    width: 40,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSampleMarkers(HomeController controller) {
    final users = controller.nearbyUsers;
    if (users.isEmpty) return [];

    return [
      // Sample marker positions (will be replaced with real map markers)
      if (users.isNotEmpty)
        Positioned(
          top: 100.h,
          left: 80.w,
          child: _buildMarkerWidget(
            controller,
            users[0],
            controller.getMarkerColor(0),
          ),
        ),
      if (users.length > 1)
        Positioned(
          top: 150.h,
          right: 100.w,
          child: _buildMarkerWidget(
            controller,
            users[1],
            controller.getMarkerColor(1),
          ),
        ),
      if (users.length > 2)
        Positioned(
          top: 250.h,
          left: 120.w,
          child: _buildMarkerWidget(
            controller,
            users[2],
            controller.getMarkerColor(2),
          ),
        ),
      if (users.length > 3)
        Positioned(
          bottom: 200.h,
          right: 80.w,
          child: _buildMarkerWidget(
            controller,
            users[3],
            controller.getMarkerColor(3),
          ),
        ),
    ];
  }

  Widget _buildMarkerWidget(
    HomeController controller,
    Map<String, dynamic> user,
    Color color,
  ) {
    return GestureDetector(
      onTap: () => controller.selectUser(user),
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: color,
          //shape: BoxShape.circle,
          border: Border.all(color: AppColors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: CommonImage(imageSrc: AppImages.image2, fill: BoxFit.cover),
      ),
    );
  }

  Widget _buildBottomUserCard(HomeController controller) {
    final selectedUser = controller.getSelectedUser();
    if (selectedUser == null) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 80.h,
      left: 20.w,
      right: 20.w,
      child: GestureDetector(
        onTap: () => controller.showUserBottomSheet(Get.context!, selectedUser),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: CommonImage(
                  imageSrc: controller.getSelectedUserImage(),
                  height: 50,
                  width: 50,
                  fill: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CommonText(
                      text: controller.getSelectedUserName(),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 2.h),
                    CommonText(
                      text: controller.getSelectedUserDescription(),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey,
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 2.h),
                    CommonText(
                      text: controller.getSelectedUserTime(),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationButton(HomeController controller) {
    return Positioned(
      bottom: 200.h,
      right: 20.w,
      child: FloatingActionButton(
        onPressed: controller.getCurrentLocation,
        backgroundColor: AppColors.white,
        child: const Icon(Icons.my_location, color: AppColors.secondary),
      ),
    );
  }

  Widget _buildUserBottomSheet(
    HomeController controller,
    BuildContext context,
  ) {
    return Positioned(
      bottom: 10,
      left: 50.w,
      right: 50.w,
      child: GestureDetector(
        onTap: () {
          BusinessInformationBottomSheet.show(context);
        },
        child: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.8),
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: CommonText(
            text: "Map Activity",
            color: AppColors.secondary,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
