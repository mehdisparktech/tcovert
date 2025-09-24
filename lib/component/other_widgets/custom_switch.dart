import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/constants/app_colors.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final Color thumbColor;
  final double width;
  final double height;

  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor = AppColors.secondary,
    this.inactiveColor = AppColors.white10,
    this.thumbColor = AppColors.white,
    this.width = 50,
    this.height = 28,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width.w,
        height: height.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height.h / 2),
          color: value ? activeColor : inactiveColor,
          border: Border.all(
            color: value ? activeColor : AppColors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              top: 2.h,
              left: value ? (width - height + 2).w : 2.w,
              child: Container(
                width: (height - 4).h,
                height: (height - 4).h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: thumbColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
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
}