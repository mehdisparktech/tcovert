import 'package:flutter/material.dart';
import 'package:tcovert/utils/constants/app_images.dart';
import 'package:tcovert/utils/extensions/extension.dart';
import '../../../../../../utils/helpers/other_helper.dart';
import '../../../../../../utils/constants/app_string.dart';
import '../../../../../component/text_field/common_text_field.dart';
import '../controller/sign_up_controller.dart';
import '../../../../../../utils/constants/app_colors.dart';

class SignUpAllField extends StatelessWidget {
  const SignUpAllField({super.key, required this.controller});

  final SignUpController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// User Name here
        CommonTextField(
          prefixIcon: Image.asset(AppImages.user),
          hintText: AppString.fullName,
          controller: controller.nameController,
          validator: OtherHelper.validator,
          fillColor: AppColors.textfieldColor,
        ),
        20.height,

        /// User Email here
        CommonTextField(
          controller: controller.emailController,
          prefixIcon: Image.asset(AppImages.email),
          hintText: AppString.email,
          validator: OtherHelper.emailValidator,
          fillColor: AppColors.textfieldColor,
        ),
        20.height,
        // User Password here
        CommonTextField(
          controller: controller.passwordController,
          prefixIcon: Image.asset(AppImages.password),
          isPassword: true,
          hintText: AppString.password,
          fillColor: AppColors.textfieldColor,
          validator: OtherHelper.passwordValidator,
        ),
        20.height,

        /// User Confirm Password here
        CommonTextField(
          controller: controller.confirmPasswordController,
          prefixIcon: Image.asset(AppImages.password),
          isPassword: true,
          hintText: AppString.confirmPassword,
          fillColor: AppColors.textfieldColor,
          validator:
              (value) => OtherHelper.confirmPasswordValidator(
                value,
                controller.passwordController,
              ),
        ),
      ],
    );
  }
}
