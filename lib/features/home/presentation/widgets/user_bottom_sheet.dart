import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tcovert/utils/constants/app_colors.dart';
import 'package:tcovert/utils/extensions/extension.dart';
import '../../../../component/text/common_text.dart';
import '../../../../component/image/common_image.dart';
import '../../../../utils/constants/app_images.dart';

class UserBottomSheet extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserBottomSheet({super.key, required this.user});

  static void show(BuildContext context, Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) => UserBottomSheet(user: user),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1B2E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildDragHandle(),
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  _buildPromoCard(),
                  SizedBox(height: 24.h),
                  _buildPhotoSection(),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
      width: 40.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: Colors.grey[600],
        borderRadius: BorderRadius.circular(2.r),
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
                  fontSize: 28,
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
                    60.width,
                    Icon(
                      Icons.location_on_outlined,
                      color: Colors.grey[400],
                      size: 16.sp,
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: CommonText(
                        text: "756 031 Ines Riverway, Rhiannonchester",
                        fontSize: 14,
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
          SizedBox(width: 16.w),
          _buildCloseButton(),
        ],
      ),
    );
  }

  Widget _buildCloseButton() {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Icon(Icons.close, color: Colors.white, size: 20.sp),
    );
  }

  Widget _buildPromoCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText(
              text: "Buy 1 Get 1 Free!",
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 8.h),
            CommonText(
              text: "Don't miss out on this amazing offer!",
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.9),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 20.h),
            _buildPromoButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () {
            // Handle promo code action
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: const CommonText(
              text: "Get Promo Code",
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.secondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAddPhotoCard(),
        SizedBox(height: 16.h),
        _buildPhotoGrid(),
      ],
    );
  }

  Widget _buildAddPhotoCard() {
    return Container(
      width: double.infinity,
      height: 120.h,
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
            // Handle add photo action
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
                child: Icon(Icons.add, color: Colors.grey[400], size: 24.sp),
              ),
              SizedBox(height: 8.h),
              CommonText(
                text: "Add Photo",
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

  Widget _buildPhotoGrid() {
    final List<PhotoModel> photos = [
      PhotoModel(AppImages.image1, 'Risa Tachibana', '1 mo ago'),
      PhotoModel(AppImages.image2, 'Rina Ishihara', '1 mo ago'),
      PhotoModel(AppImages.image2, 'Yua Mikami', '1 mo ago'),
      PhotoModel(AppImages.image2, 'Ichikawa Mas', '1 mo ago'),
      PhotoModel(AppImages.image2, 'Nozomi Sasaki', '1 mo ago'),
      PhotoModel(AppImages.image2, 'Shina Sora', '1 mo ago'),
      PhotoModel(AppImages.image2, 'Saori Hara', '1 mo ago'),
    ];

    return Column(
      children: [
        // First row - 2 large items
        Row(
          children: [
            Expanded(child: _buildPhotoCard(photos[0], isLarge: true)),
            SizedBox(width: 8.w),
            Expanded(child: _buildPhotoCard(photos[1], isLarge: true)),
          ],
        ),
        SizedBox(height: 8.h),

        // Remaining items in 3-column grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.w,
            mainAxisSpacing: 8.h,
            childAspectRatio: 1.0,
          ),
          itemCount: photos.length - 2,
          itemBuilder: (context, index) {
            return _buildPhotoCard(photos[index + 2]);
          },
        ),
      ],
    );
  }

  Widget _buildPhotoCard(PhotoModel photo, {bool isLarge = false}) {
    return Container(
      height: isLarge ? 140.h : null,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Photo
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: CommonImage(
              imageSrc: photo.imagePath,
              width: double.infinity,
              height: double.infinity,
              fill: BoxFit.cover,
            ),
          ),

          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.6),
                ],
              ),
            ),
          ),

          // User info
          Positioned(
            left: 8.w,
            bottom: 8.h,
            right: 8.w,
            child: Row(
              children: [
                CircleAvatar(
                  radius: isLarge ? 12.r : 8.r,
                  backgroundColor: Colors.white.withOpacity(0.9),
                  child: ClipOval(
                    child: CommonImage(imageSrc: AppImages.profile),
                  ),
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CommonText(
                        text: photo.userName,
                        fontSize: isLarge ? 12 : 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        textAlign: TextAlign.left,
                        maxLines: 1,
                      ),
                      CommonText(
                        text: photo.timeAgo,
                        fontSize: isLarge ? 10 : 8,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.8),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PhotoModel {
  final String imagePath;
  final String userName;
  final String timeAgo;

  PhotoModel(this.imagePath, this.userName, this.timeAgo);
}
