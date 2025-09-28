import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../component/text/common_text.dart';
import '../../../../component/button/common_button.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/app_utils.dart';

class PromoCodeScreen extends StatelessWidget {
  const PromoCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            children: [
              // Header with back button
              _buildHeader(),

              SizedBox(height: 40.h),

              // Main content
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Starbucks logo placeholder (using a circular container)
                    _buildLogoContainer(),

                    SizedBox(height: 24.h),

                    // Store name
                    const CommonText(
                      text: "Starbucks",
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),

                    SizedBox(height: 8.h),

                    // Store location
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: AppColors.grey,
                          size: 16.sp,
                        ),
                        SizedBox(width: 4.w),
                        const CommonText(
                          text: "756 031 Ines Riverway, Rhiannonchester",
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.grey,
                        ),
                      ],
                    ),

                    SizedBox(height: 40.h),

                    // Offer title
                    const CommonText(
                      text: "Buy 1 Get 1 Free!",
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.white,
                    ),

                    SizedBox(height: 12.h),

                    // Offer description
                    const CommonText(
                      text:
                          "Get one of our select handcrafted beverages for free\nwhen you buy one",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),

                    SizedBox(height: 40.h),

                    // Promo code container
                    _buildPromoCodeContainer(),

                    SizedBox(height: 24.h),

                    // Action buttons
                    _buildActionButtons(),

                    SizedBox(height: 40.h),

                    // Terms and conditions
                    _buildTermsAndConditions(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.white10,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.arrow_back, color: AppColors.white, size: 20.sp),
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            // Share functionality
            _sharePromoCode();
          },
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.white10,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.share, color: AppColors.white, size: 20.sp),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoContainer() {
    return Container(
      width: 80.w,
      height: 80.h,
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
      child: Center(
        child: Container(
          width: 50.w,
          height: 50.h,
          decoration: BoxDecoration(
            color: AppColors.secondary,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.local_cafe, color: AppColors.white, size: 24.sp),
        ),
      ),
    );
  }

  Widget _buildPromoCodeContainer() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.white10,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.secondary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          const CommonText(
            text: "Your promo code",
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.grey,
          ),
          SizedBox(height: 12.h),
          const CommonText(
            text: "BG44Y90",
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: AppColors.secondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: CommonButton(
            titleText: "Copy Code",
            buttonColor: AppColors.secondary,
            titleColor: AppColors.white,
            buttonRadius: 8,
            buttonHeight: 48,
            onTap: () => _copyPromoCode(),
          ),
        ),
        SizedBox(width: 12.w),
        GestureDetector(
          onTap: () => _sharePromoCode(),
          child: Container(
            height: 48.h,
            width: 48.w,
            decoration: BoxDecoration(
              color: AppColors.white10,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: AppColors.secondary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(Icons.share, color: AppColors.secondary, size: 20.sp),
          ),
        ),
      ],
    );
  }

  Widget _buildTermsAndConditions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonText(
          text: "Terms & Conditions",
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
        SizedBox(height: 12.h),
        _buildTermItem("• Offer valid on select handcrafted beverages"),
        SizedBox(height: 8.h),
        _buildTermItem("• Valid until December 31, 2024"),
        SizedBox(height: 8.h),
        _buildTermItem("• Cannot be combined with other offers"),
      ],
    );
  }

  Widget _buildTermItem(String text) {
    return CommonText(
      text: text,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.grey,
      textAlign: TextAlign.left,
    );
  }

  void _copyPromoCode() {
    Clipboard.setData(const ClipboardData(text: "BG44Y90"));
    Utils.successSnackBar("Success", "Promo code copied to clipboard!");
  }

  void _sharePromoCode() {
    // Share functionality would be implemented here
    Utils.successSnackBar("Share", "Share functionality will be implemented");
  }
}
