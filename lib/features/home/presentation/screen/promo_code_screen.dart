import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tcovert/component/image/common_image.dart';
import 'package:tcovert/config/api/api_end_point.dart';
import 'package:tcovert/utils/constants/app_images.dart';
import '../../../../component/text/common_text.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../data/models/business_detail_model.dart';

class PromoCodeScreen extends StatelessWidget {
  final PromoCodeModel promoCode;
  final String businessName;
  final String businessAddress;
  final String? businessLogo;

  const PromoCodeScreen({
    super.key,
    required this.promoCode,
    required this.businessName,
    required this.businessAddress,
    this.businessLogo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(leading: BackButton(color: AppColors.white)),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
            child: Column(
              children: [
                // Main content
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Starbucks logo placeholder (using a circular container)
                    _buildLogoContainer(),
                    SizedBox(height: 24.h),

                    // Store name
                    CommonText(
                      text: businessName,
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                    SizedBox(height: 8.h),

                    // Store location
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CommonImage(imageSrc: AppImages.location2, size: 22),
                        SizedBox(width: 4.w),
                        CommonText(
                          text: businessAddress,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white.withOpacity(0.9),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    SizedBox(height: 40.h),
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        children: [
                          CommonText(
                            text: promoCode.title,
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white.withOpacity(0.9),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 12.h),

                          // Offer description
                          CommonText(
                            text: promoCode.description,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.white.withOpacity(0.9),
                            textAlign: TextAlign.center,
                            maxLines: 3,
                          ),
                          SizedBox(height: 12.h),

                          // Discount percentage
                          CommonText(
                            text: "${promoCode.discount}% OFF",
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondary,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 40.h),

                          // Promo code container
                          _buildPromoCodeContainer(),

                          // Action buttons
                          SizedBox(height: 40.h),

                          // Terms and conditions
                          _buildTermsAndConditions(),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoContainer() {
    return Container(
      width: 110.w,
      height: 110.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child:
          businessLogo != null
              ? CommonImage(
                imageSrc: '${ApiEndPoint.imageUrl}$businessLogo',
                fill: BoxFit.cover,
              )
              : CommonImage(imageSrc: AppImages.promoimage, fill: BoxFit.cover),
    );
  }

  Widget _buildPromoCodeContainer() {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: Radius.circular(12),
      dashPattern: [4, 4], // 6 length dash, 3 length gap
      color: Colors.grey,
      strokeWidth: 2,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.grey.withOpacity(0.10),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            CommonText(
              text: "Your promo code",
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.white.withOpacity(0.9),
            ),
            SizedBox(height: 20.h),
            CommonText(
              text: promoCode.promoCode,
              fontSize: 30,
              fontWeight: FontWeight.w600,
              color: AppColors.secondary,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),

            // QR Code
            if (promoCode.qrCode.isNotEmpty)
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: CommonImage(
                  imageSrc: '${ApiEndPoint.imageUrl}${promoCode.qrCode}',
                  width: 150.w,
                  height: 150.h,
                  fill: BoxFit.contain,
                ),
              ),
            if (promoCode.qrCode.isNotEmpty) SizedBox(height: 20.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: promoCode.promoCode));
                    Get.snackbar(
                      'Copied!',
                      'Promo code copied to clipboard',
                      backgroundColor: AppColors.secondary,
                      colorText: AppColors.white,
                      duration: const Duration(seconds: 2),
                    );
                  },
                  child: Row(
                    children: [
                      CommonImage(
                        imageSrc: AppImages.copy,
                        width: 20.w,
                        height: 20.h,
                      ),
                      SizedBox(width: 8.w),
                      CommonText(
                        text: "Copy Code",
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.secondary,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.w),
                GestureDetector(
                  onTap: () {
                    // Share functionality can be implemented here
                    Get.snackbar(
                      'Share',
                      'Share functionality coming soon',
                      backgroundColor: AppColors.secondary,
                      colorText: AppColors.white,
                      duration: const Duration(seconds: 2),
                    );
                  },
                  child: Row(
                    children: [
                      CommonImage(
                        imageSrc: AppImages.share,
                        width: 20.w,
                        height: 20.h,
                      ),
                      SizedBox(width: 8.w),
                      CommonText(
                        text: "Share",
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.secondary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsAndConditions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          text: "Terms & Conditions",
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.white.withOpacity(0.9),
        ),
        SizedBox(height: 12.h),
        _buildTermItem(
          "  • Valid from ${_formatDate(promoCode.startDate)} to ${_formatDate(promoCode.endDate)}",
        ),
        SizedBox(height: 8.h),
        _buildTermItem("  • Discount: ${promoCode.discount}%"),
        SizedBox(height: 8.h),
        _buildTermItem(
          "  • Status: ${promoCode.active ? 'Active' : 'Inactive'}",
        ),
        SizedBox(height: 8.h),
        _buildTermItem("  • Cannot be combined with other offers"),
      ],
    );
  }

  Widget _buildTermItem(String text) {
    return CommonText(
      text: text,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.white.withOpacity(0.9),
      textAlign: TextAlign.left,
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
