import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tcovert/config/api/api_end_point.dart';
import 'package:tcovert/features/home/presentation/widgets/business_information_bottom_sheet.dart';
import 'package:tcovert/services/storage/storage_services.dart';
import '../../../../component/text/common_text.dart';
import '../../../../component/image/common_image.dart';
import '../../../../utils/constants/app_colors.dart';
import '../controller/home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          // image: DecorationImage(
          //   image: AssetImage(AppImages.mapBackground),
          //   fit: BoxFit.cover,
          // ),
        ),
        child: Column(
          children: [
            // Top Header

            // Google Maps
            Expanded(
              child: Obx(
                () => Stack(
                  children: [
                    // Google Map Widget
                    GoogleMap(
                      initialCameraPosition:
                          controller.initialCameraPosition.value,
                      onMapCreated: controller.onMapCreated,
                      markers: controller.markers,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      mapToolbarEnabled: false,
                      mapType: MapType.normal,
                      compassEnabled: true,
                      rotateGesturesEnabled: true,
                      scrollGesturesEnabled: true,
                      tiltGesturesEnabled: true,
                      zoomGesturesEnabled: true,
                      indoorViewEnabled: true,
                      trafficEnabled: false,
                      buildingsEnabled: true,
                      liteModeEnabled: false,
                    ),
                    _buildHeader(controller, context),

                    // Bottom User Card
                    _buildBottomUserCard(controller, context),

                    // My Location Button
                    _buildLocationButton(controller, context),

                    // User Bottom Sheet
                    _buildUserBottomSheet(controller, context),

                    // Loading Indicator
                    if (controller.isLoading.value)
                      Container(
                        color: AppColors.black.withOpacity(0.3),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(HomeController controller, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: MediaQuery.of(context).padding.top + 8.h,
      ),
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
                    imageSrc: ApiEndPoint.imageUrl + LocalStorage.myImage,
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

  Widget _buildBottomUserCard(HomeController controller, BuildContext context) {
    final selectedUser = controller.getSelectedUser();
    if (selectedUser == null) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + 80.h,
      left: 20.w,
      right: 20.w,
      child: GestureDetector(
        onTap: () => controller.showUserBottomSheet(Get.context!, selectedUser['id']),
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

  Widget _buildLocationButton(HomeController controller, BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 200.h,
      right: 10.w,
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
      bottom: MediaQuery.of(context).padding.bottom + 10.h,
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
