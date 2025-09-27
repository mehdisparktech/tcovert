import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tcovert/features/auth/change_password/presentation/controller/change_password_controller.dart';
import 'package:tcovert/utils/constants/app_images.dart';
import '../../../../../../../config/route/app_routes.dart';
import '../../../../../../../utils/extensions/extension.dart';
import '../../../../../component/button/common_button.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../component/text_field/common_text_field.dart';
import '../../../../../../../utils/constants/app_colors.dart';
import '../../../../../../../utils/constants/app_string.dart';
import '../../../../../utils/helpers/other_helper.dart';

class SetPasswordScreen extends StatelessWidget {
  const SetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.bg),
              fit: BoxFit.cover,
            ),
          ),
        ),
        toolbarHeight: 200.h,
      ),
      body: GetBuilder<ChangePasswordController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  70.height,
                  CommonText(
                    text: AppString.setPassword,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    bottom: 20,
                  ).center,

                  /// New Password section
                  CommonTextField(
                    controller: controller.newPasswordController,
                    hintText: AppString.newPassword,
                    validator: OtherHelper.passwordValidator,
                    isPassword: true,
                    prefixIcon: Icon(Icons.lock, size: 20.sp),
                    fillColor: AppColors.textfieldColor,
                  ),
                  20.height,
                  CommonTextField(
                    controller: controller.confirmPasswordController,
                    hintText: AppString.confirmPassword,
                    validator:
                        (value) => OtherHelper.confirmPasswordValidator(
                          value,
                          controller.newPasswordController,
                        ),
                    isPassword: true,
                    prefixIcon: Icon(Icons.lock, size: 20.sp),
                    fillColor: AppColors.textfieldColor,
                  ),

                  /// forget Password button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.forgotPassword),
                      child: CommonText(
                        text: AppString.forgotPassword,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp,
                        bottom: 20.h,
                      ),
                    ),
                  ),

                  /// submit Button
                  CommonButton(
                    titleText: AppString.confirm,
                    isLoading: controller.isLoading,
                    onTap: controller.changePasswordRepo,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
