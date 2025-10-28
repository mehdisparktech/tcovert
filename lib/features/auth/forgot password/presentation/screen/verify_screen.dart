import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tcovert/utils/constants/app_images.dart';
import 'package:tcovert/utils/extensions/extension.dart';
import '../../../../../component/button/common_button.dart';
import '../../../../../component/text/common_text.dart';
import '../controller/forget_password_controller.dart';
import '../../../../../../../utils/constants/app_colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../../../../utils/constants/app_string.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final formKey = GlobalKey<FormState>();

  /// init State here
  @override
  void initState() {
    Get.find<ForgetPasswordController>().startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

      /// Body Section
      body: GetBuilder<ForgetPasswordController>(
        builder:
            (controller) => SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    CommonText(
                      text: AppString.verifyCode,
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      top: 40,
                      bottom: 20,
                    ).center,

                    /// instruction how to get OTP
                    Center(
                      child: CommonText(
                        text:
                            "${AppString.codeHasBeenSendTo} ${controller.emailController.text}",
                        fontSize: 18,

                        bottom: 60,
                        maxLines: 2,
                      ),
                    ),

                    /// OTP Filed here
                    Flexible(
                      flex: 0,
                      child: PinCodeTextField(
                        controller: controller.otpController,
                        autoDisposeControllers: false,
                        cursorColor: AppColors.white,
                        textStyle: TextStyle(color: AppColors.white),
                        appContext: (context),
                        autoFocus: true,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(8),
                          fieldHeight: 60.h,
                          fieldWidth: 60.w,
                          activeFillColor: AppColors.textfieldColor,
                          selectedFillColor: AppColors.textfieldColor,
                          inactiveFillColor: AppColors.textfieldColor,
                          borderWidth: 0.5.w,
                          selectedColor: AppColors.textfieldColor,
                          activeColor: AppColors.textfieldColor,
                          inactiveColor: AppColors.textfieldColor,
                        ),
                        length: 4,
                        keyboardType: TextInputType.number,
                        autovalidateMode: AutovalidateMode.disabled,
                        enableActiveFill: true,
                      ),
                    ),

                    /// Resent OTP or show Timer
                    GestureDetector(
                      onTap:
                          controller.time == '00:00'
                              ? () {
                                controller.startTimer();
                                controller.forgotPasswordRepo();
                              }
                              : () {},
                      child: CommonText(
                        text:
                            controller.time == '00:00'
                                ? AppString.resendCode
                                : "${AppString.resendCodeIn} ${controller.time} ${AppString.minute}",
                        top: 30,
                        bottom: 40,
                        fontSize: 18,
                      ),
                    ),

                    ///  Submit Button here
                    CommonButton(
                      titleText: AppString.verify,
                      isLoading: controller.isLoadingVerify,
                      onTap: () {
                        controller.verifyOtpRepo();
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
