import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcovert/component/image/common_image.dart';
import 'package:tcovert/utils/constants/app_images.dart';
import '../../../../component/text/common_text.dart';
import '../../../../utils/constants/app_colors.dart';

class PromoCodeScreen extends StatelessWidget {
  const PromoCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
          child: Column(
            children: [
              // Main content
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Starbucks logo placeholder (using a circular container)
                    _buildLogoContainer(),

                    SizedBox(height: 24.h),

                    // Store name
                    const CommonText(
                      text: "Starbucks",
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),

                    SizedBox(height: 8.h),

                    // Store location
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CommonImage(imageSrc: AppImages.location2, size: 24),
                        SizedBox(width: 4.w),
                        CommonText(
                          text: "756 031 Ines Riverway, Rhiannonchester",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white.withOpacity(0.9),
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
                            text: "Buy 1 Get 1 Free!",
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white.withOpacity(0.9),
                          ),

                          SizedBox(height: 12.h),

                          // Offer description
                          CommonText(
                            text:
                                "Get one of our select handcrafted beverages for free when you buy one",
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.white.withOpacity(0.9),
                            textAlign: TextAlign.center,
                            maxLines: 2,
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

                    // Offer title
                  ],
                ),
              ),
            ],
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
      child: CommonImage(imageSrc: AppImages.promoimage, fill: BoxFit.cover),
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
            const CommonText(
              text: "BG44Y90",
              fontSize: 30,
              fontWeight: FontWeight.w600,
              color: AppColors.secondary,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                SizedBox(width: 8.w),
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
                SizedBox(width: 8.w),
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
        _buildTermItem("  • Offer valid on select handcrafted beverages"),
        SizedBox(height: 8.h),
        _buildTermItem("  • Valid until December 31, 2024"),
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
}
