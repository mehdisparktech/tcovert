import 'package:flutter/material.dart';
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
          prefixIcon: const Icon(Icons.person),
          hintText: AppString.fullName,
          controller: controller.nameController,
          validator: OtherHelper.validator,
          fillColor: AppColors.textfieldColor,
        ),
        20.height,

        /// User Email here
        CommonTextField(
          controller: controller.emailController,
          prefixIcon: const Icon(Icons.mail),
          hintText: AppString.email,
          validator: OtherHelper.emailValidator,
          fillColor: AppColors.textfieldColor,
        ),

        /// User Password here
        // const CommonText(text: AppString.password, bottom: 8, top: 12),
        // CommonTextField(
        //   controller: controller.passwordController,
        //   prefixIcon: const Icon(Icons.lock, color: AppColors.black),
        //   isPassword: true,
        //   hintText: AppString.password,
        //   validator: OtherHelper.passwordValidator,
        // ),

        // /// User Confirm Password here
        // const CommonText(text: AppString.confirmPassword, bottom: 8, top: 12),
        // CommonTextField(
        //   controller: controller.confirmPasswordController,
        //   prefixIcon: const Icon(Icons.lock, color: AppColors.black),
        //   isPassword: true,
        //   hintText: AppString.confirmPassword,
        //   validator:
        //       (value) => OtherHelper.confirmPasswordValidator(
        //         value,
        //         controller.passwordController,
        //       ),
        // ),
      ],
    );
  }
}
