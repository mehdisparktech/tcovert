import 'package:flutter/material.dart';
import 'package:tcovert/utils/constants/app_images.dart';
import '../../../../../../../utils/extensions/extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../component/button/common_button.dart';
import '../../../../../component/text/common_text.dart';
import '../../../../../component/text_field/common_text_field.dart';
import '../controller/forget_password_controller.dart';
import '../../../../../../../utils/constants/app_string.dart';
import '../../../../../../../utils/helpers/other_helper.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForgetPasswordController>(
      builder:
          (controller) => Scaffold(
            /// App Bar Section
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

            /// body section
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CommonText(
                      text: AppString.forgotPassword,
                      fontSize: 28,
                      bottom: 20,
                      top: 36,
                    ).center,
                    CommonTextField(
                      controller: controller.emailController,
                      prefixIcon: const Icon(Icons.mail),
                      hintText: AppString.email,
                      validator: OtherHelper.emailValidator,
                    ),
                    30.height,
                    CommonButton(
                      titleText: AppString.continues,
                      isLoading: controller.isLoadingEmail,
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          controller.forgotPasswordRepo();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
