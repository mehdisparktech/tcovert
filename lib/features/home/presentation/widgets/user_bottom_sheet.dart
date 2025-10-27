import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tcovert/config/api/api_end_point.dart';
import 'package:tcovert/features/home/presentation/screen/image_view_screen.dart';
import 'package:tcovert/features/home/presentation/screen/promo_code_screen.dart';
import 'package:tcovert/features/home/presentation/widgets/image_selete_bottom_sheet.dart';
import 'package:tcovert/utils/constants/app_colors.dart';
import 'package:tcovert/utils/extensions/extension.dart';
import '../../../../component/text/common_text.dart';
import '../../../../component/image/common_image.dart';
import '../../../../utils/constants/app_images.dart';
import '../controller/user_bottom_sheet_controller.dart';

class UserBottomSheet extends StatefulWidget {
  final String businessId;

  const UserBottomSheet({super.key, required this.businessId});

  static void show(BuildContext context, String businessId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) => UserBottomSheet(businessId: businessId),
    );
  }

  @override
  State<UserBottomSheet> createState() => _UserBottomSheetState();
}

class _UserBottomSheetState extends State<UserBottomSheet> {
  late UserBottomSheetController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(UserBottomSheetController());
    // Fetch business detail when bottom sheet opens
    controller.fetchBusinessDetail(widget.businessId);
  }

  @override
  void dispose() {
    Get.delete<UserBottomSheetController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child:
            controller.isLoading.value
                ? const Center(
                  child: CircularProgressIndicator(color: AppColors.secondary),
                )
                : controller.errorMessage.value.isNotEmpty
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 60.sp, color: Colors.red),
                      SizedBox(height: 16.h),
                      CommonText(
                        text: controller.errorMessage.value,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: () {
                          controller.fetchBusinessDetail(widget.businessId);
                        },
                        child: const CommonText(
                          text: 'Retry',
                          fontSize: 14,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20.h),
                    _buildHeader(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          children: [
                            SizedBox(height: 20.h),
                            if (controller.businessDetail.value?.promoCode !=
                                null)
                              _buildPromoCard(),
                            SizedBox(height: 24.h),
                            _buildPhotoSection(context),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  Widget _buildHeader() {
    final business = controller.businessDetail.value;
    if (business == null) return const SizedBox.shrink();

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
                  text: business.name,
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
                        text: business.address,
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
        ],
      ),
    );
  }

  // Widget _buildCloseButton() {
  //   return GestureDetector(
  //     onTap: () => Get.back(),
  //     child: Padding(
  //       padding: EdgeInsets.only(right: 8.w),
  //       child: Icon(Icons.close, color: Colors.white, size: 20.sp),
  //     ),
  //   );
  // }

  Widget _buildPromoCard() {
    final business = controller.businessDetail.value;
    if (business == null) return const SizedBox.shrink();

    final promo = business.promoCode;
    final hasPromo = promo != null;

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
              text: hasPromo ? promo.title : "No Active Promo",
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 8.h),
            CommonText(
              text:
                  hasPromo ? promo.description : "Check back later for offers!",
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.9),
              textAlign: TextAlign.left,
            ),
            if (hasPromo) ...[
              SizedBox(height: 12.h),
              CommonText(
                text: "Discount: ${promo.discount}%",
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                textAlign: TextAlign.left,
              ),
            ],
            SizedBox(height: 20.h),
            if (hasPromo) _buildPromoButton(),
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
            Get.to(() => PromoCodeScreen());
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

  Widget _buildPhotoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAddPhotoCard(context),
        SizedBox(height: 16.h),
        _buildPhotoGrid(context),
      ],
    );
  }

  Widget _buildAddPhotoCard(BuildContext context) {
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
            // Close current bottom sheet first
            Navigator.pop(context);
            // Then show the image select bottom sheet
            ImageSeleteBottomSheet.show(context);
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

  Widget _buildPhotoGrid(BuildContext context) {
    final business = controller.businessDetail.value;
    if (business == null || business.images.isEmpty) {
      return Center(
        child: CommonText(
          text: 'No photos available',
          fontSize: 14,
          color: Colors.grey,
        ),
      );
    }

    final images = business.images;

    return Column(
      children: [
        // First row - 2 large items (if available)
        if (images.length >= 2)
          Row(
            children: [
              Expanded(
                child: _buildPhotoCard(
                  images[0],
                  isLarge: true,
                  context: context,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildPhotoCard(
                  images[1],
                  isLarge: true,
                  context: context,
                ),
              ),
            ],
          ),
        if (images.length >= 2) SizedBox(height: 8.h),

        // Remaining items in 3-column grid
        if (images.length > 2)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8.w,
              mainAxisSpacing: 8.h,
              childAspectRatio: 1.0,
            ),
            itemCount: images.length - 2,
            itemBuilder: (context, index) {
              return _buildPhotoCard(images[index + 2], context: context);
            },
          ),
        // If only 1 image
        if (images.length == 1)
          _buildPhotoCard(images[0], isLarge: true, context: context),
      ],
    );
  }

  Widget _buildPhotoCard(
    dynamic image, {
    bool isLarge = false,
    required BuildContext context,
  }) {
    final business = controller.businessDetail.value;
    final imageUrl = '${ApiEndPoint.imageUrl}${image.imageUrl}';
    final uploader = image.uploadedBy;
    final uploaderName = uploader?.name ?? 'Anonymous';
    final uploaderImage =
        uploader?.profileImage != null
            ? '${ApiEndPoint.imageUrl}${uploader!.profileImage}'
            : AppImages.profile;
    final timeAgo = controller.getTimeAgo(image.uploadedAt);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => ImageViewScreen(
                  imageUrl: imageUrl,
                  title: business?.name ?? 'Business',
                  subtitle: business?.address ?? '',
                ),
          ),
        );
      },
      child: Container(
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
                imageSrc: imageUrl,
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
                      child: CommonImage(
                        imageSrc: uploaderImage,
                        width: isLarge ? 24 : 16,
                        height: isLarge ? 24 : 16,
                        fill: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CommonText(
                          text: uploaderName,
                          fontSize: isLarge ? 12 : 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          textAlign: TextAlign.left,
                          maxLines: 1,
                        ),
                        CommonText(
                          text: timeAgo,
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
      ),
    );
  }
}
