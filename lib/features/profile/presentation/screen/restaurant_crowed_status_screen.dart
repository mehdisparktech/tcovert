import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tcovert/component/button/common_button.dart';
import 'package:tcovert/component/text/common_text.dart';
import 'package:tcovert/features/profile/presentation/controller/restaurant_crowd_status_controller.dart';

class RestaurantCrowedStatusScreen extends StatelessWidget {
  const RestaurantCrowedStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RestaurantCrowdStatusController());

    return Scaffold(
      appBar: AppBar(
        title: CommonText(
          text: 'Restaurant Crowd Status',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20.h),
            CommonText(
              text: 'Select Current Status',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.h),
            ...controller.statusOptions.map((option) {
              return Obx(() {
                final isSelected =
                    controller.selectedStatus.value == option['value'];
                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: InkWell(
                    onTap: () {
                      controller.selectStatus(option['value']);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              isSelected
                                  ? option['color']
                                  : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color:
                            isSelected
                                ? option['color'].withOpacity(0.1)
                                : Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 24.w,
                            height: 24.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: option['color'],
                            ),
                          ),
                          SizedBox(width: 16.w),
                          CommonText(
                            text: option['label'],
                            fontSize: 18,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
            }),
            const Spacer(),
            Obx(() {
              final hasSelection = controller.selectedStatus.value != null;
              return CommonButton(
                titleText: 'Save',
                isLoading: controller.isLoading.value,
                buttonColor:
                    hasSelection
                        ? const Color(0xFF6C63FF)
                        : Colors.grey.shade300,
                titleColor: hasSelection ? Colors.white : Colors.grey.shade600,
                onTap:
                    hasSelection && !controller.isLoading.value
                        ? () => controller.saveCrowdStatus()
                        : null,
              );
            }),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
