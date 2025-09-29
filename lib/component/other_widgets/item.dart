import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcovert/component/image/common_image.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../component/text/common_text.dart';

class Item extends StatelessWidget {
  const Item({super.key, required this.title, required this.icon, this.onTap});

  final String title;
  final String icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52.h,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        margin: EdgeInsets.only(bottom: 15.h),
        decoration: BoxDecoration(
          color: AppColors.white10,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            /// show icon here
            CommonImage(
              imageSrc: icon,
              size: 20.w,
              imageColor: AppColors.white,
            ),

            /// show Title here
            CommonText(text: title, color: AppColors.white, left: 12),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
