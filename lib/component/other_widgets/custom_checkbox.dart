import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/constants/app_colors.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final Color checkColor;
  final double size;

  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor = AppColors.secondary,
    this.inactiveColor = AppColors.white10,
    this.checkColor = AppColors.white,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: size.w,
        height: size.w,
        decoration: BoxDecoration(
          color: value ? activeColor : inactiveColor,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(
            color: value ? activeColor : AppColors.grey.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: value
            ? Icon(
                Icons.check,
                color: checkColor,
                size: (size * 0.7).w,
              )
            : null,
      ),
    );
  }
}