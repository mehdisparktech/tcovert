import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tcovert/component/button/common_button.dart';
import 'package:tcovert/component/image/common_image.dart';
import 'package:tcovert/features/home/presentation/widgets/image_selete_bottom_sheet.dart';
import 'package:tcovert/services/api/api_service.dart';
import 'package:tcovert/utils/constants/app_colors.dart';
import 'package:tcovert/utils/constants/app_images.dart';
import 'package:tcovert/utils/extensions/extension.dart';
import '../../../../component/text/common_text.dart';

class ImageBottomSheet extends StatelessWidget {
  final List<String> selectedImagePaths;
  final String businessId;

  const ImageBottomSheet({
    super.key,
    required this.selectedImagePaths,
    required this.businessId,
  });

  static void show(
    BuildContext context, {
    required List<String> selectedImagePaths,
    required String businessId,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder:
          (context) => ImageBottomSheet(
            selectedImagePaths: selectedImagePaths,
            businessId: businessId,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.40,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20.h),
          _buildHeader(),
          SizedBox(height: 20.h),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                children: [_buildPhotoSection(context), SizedBox(height: 10.h)],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CommonButton(
              titleText: "Save",
              buttonColor: AppColors.secondary,
              onTap: () async {
                if (selectedImagePaths.isEmpty) {
                  Get.snackbar(
                    "Error",
                    "Please select at least one image",
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }

                // Show loading
                Get.dialog(
                  Center(
                    child: CircularProgressIndicator(
                      color: AppColors.secondary,
                    ),
                  ),
                  barrierDismissible: false,
                );

                try {
                  // Upload images to business API
                  final response = await ApiService.multipartMultipleImages(
                    "business/68e5fd6078e258f0611e0344",
                    method: "PATCH",
                    imageName: "image",
                    imagePaths: selectedImagePaths,
                  );

                  // Hide loading
                  Get.back();

                  if (response.statusCode == 200) {
                    Get.snackbar(
                      "Success",
                      "Images uploaded successfully",
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                    Navigator.pop(context);
                  } else {
                    Get.snackbar(
                      "Error",
                      "Failed to upload images",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                } catch (e) {
                  Get.back();
                  Get.snackbar(
                    "Error",
                    "An error occurred: $e",
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
            ),
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonText(
                  text: "Starbucks",
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  textAlign: TextAlign.left,
                  left: 20.w,
                ),
                SizedBox(height: 8.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    80.width,
                    CommonImage(
                      imageSrc: AppImages.location2,
                      height: 20.h,
                      width: 20.w,
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: CommonText(
                        text: "756 031 Ines Riverway, Rhiannonchester",
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF9E9E9E),
                        textAlign: TextAlign.left,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoSection(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display all selected images
        ...selectedImagePaths
            .map(
              (imagePath) => [
                Expanded(
                  child: _buildSelectedPhotoCard(
                    imagePath,
                    context,
                    isFile: true,
                  ),
                ),
                SizedBox(width: 10.w),
              ],
            )
            .expand((widget) => widget),
        // Add more button
        Expanded(child: _buildAddPhotoCard(AppImages.add, "Add more", context)),
      ],
    );
  }

  Widget _buildAddPhotoCard(String icon, String text, BuildContext context) {
    return Container(
      width: double.infinity,
      height: 114.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () {
            // Close current bottom sheet and show ImageSeleteBottomSheet
            Navigator.pop(context);
            ImageSeleteBottomSheet.show(
              context,
              existingImages: selectedImagePaths,
              businessId: businessId,
              businessName: 'businessName',
              businessAddress: 'businessAddress',
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: CommonImage(imageSrc: icon, height: 24.h, width: 24.w),
              ),
              SizedBox(height: 8.h),
              CommonText(
                text: text,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.withOpacity(0.8),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedPhotoCard(
    String imagePath,
    BuildContext context, {
    bool isFile = false,
  }) {
    return Container(
      width: double.infinity,
      height: 114.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
        image: DecorationImage(
          image:
              isFile
                  ? FileImage(File(imagePath)) as ImageProvider
                  : AssetImage(imagePath),
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () {
            // Handle add photo action
          },
        ),
      ),
    );
  }
}
