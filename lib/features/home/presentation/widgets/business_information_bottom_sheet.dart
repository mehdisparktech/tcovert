import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcovert/component/button/common_button.dart';
import 'package:tcovert/component/text_field/common_text_field.dart';
import 'package:tcovert/features/home/presentation/widgets/business_image_view_bottom_sheet.dart';
import 'package:tcovert/features/home/presentation/widgets/image_selete_bottom_sheet.dart';
import 'package:tcovert/utils/constants/app_colors.dart';
import '../../../../component/text/common_text.dart';

class BusinessInformationBottomSheet extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.60,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                _buildHeader(),
                SizedBox(height: 20.h),
                CommonText(
                  text: "Restaurant Name",
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(height: 20.h),
                CommonTextField(
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
                Expanded(child: _buildPhotoSection(context)),
                CommonButton(
                  titleText: "Confirm",
                  buttonColor: AppColors.secondary,
                  onTap: () {
                    Navigator.pop(context);
                    BusinessImageViewBottomSheet.show(context);
                  },
                ),
              ],
            ),
          ),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildAddPhotoCard(
            Icons.camera_alt_outlined,
            "Take a Photo",
            context,
          ),
        ),
        SizedBox(width: 20.w),
        Expanded(
          child: _buildAddPhotoCard(
            Icons.photo_library_outlined,
            "Choose from Gallery",
            context,
          ),
        ),
      ],
    );
  }

  Widget _buildAddPhotoCard(IconData icon, String text, BuildContext context) {
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
          onTap: () {
            Navigator.pop(context);
            // Handle add photo action
            ImageSeleteBottomSheet.show(
              context,
              businessId: 'businessId',
              businessName: 'businessName',
              businessAddress: 'businessAddress',
            );
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
                child: Icon(icon, color: Colors.grey[400], size: 24.sp),
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
