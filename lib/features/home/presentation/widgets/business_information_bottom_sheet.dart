import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tcovert/component/button/common_button.dart';
import 'package:tcovert/component/image/common_image.dart';
import 'package:tcovert/component/text_field/common_text_field.dart';
import 'package:tcovert/features/home/data/services/business_service.dart';
import 'package:tcovert/utils/constants/app_colors.dart';
import 'package:tcovert/utils/constants/app_images.dart';
import 'package:tcovert/utils/helpers/other_helper.dart';
import '../../../../component/text/common_text.dart';
import '../controller/home_controller.dart';

class BusinessInformationBottomSheet extends StatefulWidget {
  const BusinessInformationBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) => BusinessInformationBottomSheet(),
    );
  }

  @override
  State<BusinessInformationBottomSheet> createState() =>
      _BusinessInformationBottomSheetState();
}

class _BusinessInformationBottomSheetState
    extends State<BusinessInformationBottomSheet> {
  String? selectedImagePath;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> _handleConfirm() async {
    // Validate inputs
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Please enter restaurant name",
        backgroundColor: AppColors.red,
        colorText: AppColors.white,
      );
      return;
    }

    if (addressController.text.trim().isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Please enter location/address",
        backgroundColor: AppColors.red,
        colorText: AppColors.white,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Get current location
      final homeController = Get.find<HomeController>();
      Position? position = homeController.currentPosition.value;

      // If no position available, try to get it
      if (position == null) {
        try {
          position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            timeLimit: const Duration(seconds: 10),
          );
        } catch (e) {
          // Use default location if can't get current position
          position = Position(
            latitude: 23.810331,
            longitude: 90.412521,
            timestamp: DateTime.now(),
            accuracy: 0,
            altitude: 0,
            altitudeAccuracy: 0,
            heading: 0,
            headingAccuracy: 0,
            speed: 0,
            speedAccuracy: 0,
          );
        }
      }

      // Prepare image paths
      List<String>? imagePaths;
      if (selectedImagePath != null) {
        imagePaths = [selectedImagePath!];
      }

      // Call API
      final response = await BusinessService.createBusiness(
        name: nameController.text.trim(),
        address: addressController.text.trim(),
        latitude: position.latitude,
        longitude: position.longitude,
        imagePaths: imagePaths,
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          "Business created successfully",
          backgroundColor: AppColors.secondary,
          colorText: AppColors.white,
        );

        // Refresh business list
        await homeController.fetchNearbyBusinesses();

        // Close bottom sheet
        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        final message = response.data['message'] ?? 'Failed to create business';
        Get.snackbar(
          "Error",
          message,
          backgroundColor: AppColors.red,
          colorText: AppColors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An error occurred: ${e.toString()}",
        backgroundColor: AppColors.red,
        colorText: AppColors.white,
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            _buildHeader(),
            SizedBox(height: 20.h),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: "Restaurant Name",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(height: 20.h),
                    CommonTextField(
                      controller: nameController,
                      hintText: "Starbucks",
                      textColor: Colors.white,
                      fillColor: AppColors.grey.withOpacity(0.1),
                    ),
                    SizedBox(height: 20.h),
                    CommonText(
                      text: "Location",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(height: 20.h),
                    CommonTextField(
                      controller: addressController,
                      hintText: "756 031 Ines Riverway, USA",
                      textColor: Colors.white,
                      fillColor: AppColors.grey.withOpacity(0.1),
                    ),
                    SizedBox(height: 20.h),
                    CommonText(
                      text: "Cover Photo",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(height: 20.h),
                    _buildPhotoSection(context),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
            CommonButton(
              titleText: isLoading ? "Creating..." : "Confirm",
              buttonColor: AppColors.secondary,
              onTap: isLoading ? null : _handleConfirm,
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: CommonText(
          text: "Business Information",
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.white,
          textAlign: TextAlign.left,
          left: 20.w,
        ),
      ),
    );
  }

  Widget _buildPhotoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildAddPhotoCard(
                AppImages.camera,
                "Take a Photo",
                context,
              ),
            ),
            SizedBox(width: 20.w),
            Expanded(
              child: _buildAddPhotoCard(
                AppImages.gallery,
                "Choose from Gallery",
                context,
              ),
            ),
          ],
        ),
        if (selectedImagePath != null) ...[
          SizedBox(height: 16.h),
          Container(
            width: double.infinity,
            height: 150.h,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.file(File(selectedImagePath!), fit: BoxFit.cover),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAddPhotoCard(String icon, String text, BuildContext context) {
    final bool isCamera = icon == AppImages.camera;
    return Container(
      width: double.infinity,
      height: 114.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.0),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () async {
            // Open camera or gallery based on the option
            String? imagePath =
                isCamera
                    ? await OtherHelper.openCamera()
                    : await OtherHelper.openGallery();

            if (imagePath != null && context.mounted) {
              setState(() {
                selectedImagePath = imagePath;
              });
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: CommonImage(imageSrc: icon, width: 20.w),
              ),
              SizedBox(height: 8.h),

              CommonText(
                text: text,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF9E9E9E),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
