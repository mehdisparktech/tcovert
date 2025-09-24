import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tcovert/features/auth/sign%20up/presentation/screen/set_password_screen.dart';
import '../../../../../component/button/common_button.dart';
import '../../../../../component/text/common_text.dart';
import '../controller/sign_up_controller.dart';
import '../../../../../../../utils/constants/app_colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../../../../utils/constants/app_string.dart';

class VerifyUser extends StatefulWidget {
  const VerifyUser({super.key});

  @override
  State<VerifyUser> createState() => _VerifyUserState();
}

class _VerifyUserState extends State<VerifyUser> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Get.find<SignUpController>().startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// App Bar Section starts here
      appBar: AppBar(
        title: const CommonText(
          text: AppString.otpVerify,
          fontWeight: FontWeight.w700,
          fontSize: 24,
        ),
      ),

      /// Body Section starts here
      body: GetBuilder<SignUpController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  /// instruction how to get OTP
                  Center(
                    child: CommonText(
                      text: "Check Your Email For the Activation Link",
                      fontSize: 28.sp,
                      top: 100,
                      bottom: 30,
                      maxLines: 3,
                    ),
                  ),

                  /// OTP Filed here
                  // Flexible(
                  //   flex: 0,
                  //   child: PinCodeTextField(
                  //     controller: controller.otpController,
                  //     autoDisposeControllers: false,
                  //     cursorColor: AppColors.black,
                  //     appContext: (context),
                  //     autoFocus: true,
                  //     pinTheme: PinTheme(
                  //       shape: PinCodeFieldShape.box,
                  //       borderRadius: BorderRadius.circular(16.r),
                  //       fieldHeight: 60.h,
                  //       fieldWidth: 60.w,
                  //       activeFillColor: AppColors.transparent,
                  //       selectedFillColor: AppColors.transparent,
                  //       inactiveFillColor: AppColors.transparent,
                  //       borderWidth: 0.5.w,
                  //       selectedColor: AppColors.primaryColor,
                  //       activeColor: AppColors.primaryColor,
                  //       inactiveColor: AppColors.black,
                  //     ),
                  //     length: 6,
                  //     keyboardType: TextInputType.number,
                  //     autovalidateMode: AutovalidateMode.disabled,
                  //     enableActiveFill: true,
                  //     validator: (value) {
                  //       if (value != null && value.length == 6) {
                  //         return null;
                  //       } else {
                  //         return AppString.otpIsInValid;
                  //       }
                  //     },
                  //   ),
                  // ),

                  // /// Resent OTP or show Timer
                  // GestureDetector(
                  //   onTap:
                  //       controller.time == '00:00'
                  //           ? () {
                  //             controller.startTimer();
                  //             controller.signUpUser();
                  //           }
                  //           : () {},
                  //   child: CommonText(
                  //     text:
                  //         controller.time == '00:00'
                  //             ? AppString.resendCode
                  //             : "${AppString.resendCodeIn} ${controller.time} ${AppString.minute}",
                  //     top: 60,
                  //     bottom: 100,
                  //     fontSize: 18,
                  //   ),
                  // ),

                  ///  Submit Button here
                  CommonButton(
                    titleText: AppString.resendLink,
                    isLoading: controller.isLoadingVerify,
                    onTap: () {
                      Get.to(() => const SetPasswordScreen());
                    },
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
