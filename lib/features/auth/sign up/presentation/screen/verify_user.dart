import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:tcovert/utils/constants/app_colors.dart';
import 'package:tcovert/utils/constants/app_images.dart';
import '../../../../../component/button/common_button.dart';
import '../../../../../component/text/common_text.dart';
import '../controller/sign_up_controller.dart';
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
                      text: "Check Your Email For the OTP",
                      fontSize: 28.sp,
                      top: 100,
                      bottom: 40,
                      maxLines: 3,
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
                        borderRadius: BorderRadius.circular(16.r),
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
                      validator: (value) {
                        if (value != null && value.length == 4) {
                          return null;
                        } else {
                          return AppString.otpIsInValid;
                        }
                      },
                    ),
                  ),

                  /// Resent OTP or show Timer
                  GestureDetector(
                    onTap:
                        controller.time == '00:00'
                            ? () {
                              controller.startTimer();
                              controller.resendOtpRepo();
                            }
                            : () {},
                    child: CommonText(
                      text:
                          controller.time == '00:00'
                              ? AppString.resendCode
                              : "${AppString.resendCodeIn} ${controller.time} ${AppString.minute}",
                      top: 60,
                      bottom: 100,
                      fontSize: 18,
                    ),
                  ),

                  ///  Submit Button here
                  CommonButton(
                    titleText: AppString.verify,
                    isLoading: controller.isLoadingVerify,
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        controller.verifyOtpRepo();
                      }
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
