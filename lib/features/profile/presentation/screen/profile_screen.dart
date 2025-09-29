import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tcovert/utils/constants/app_colors.dart';
import '../../../../../../config/route/app_routes.dart';
import '../../../../component/image/common_image.dart';
import '../../../../component/other_widgets/item.dart';
import '../../../../component/text/common_text.dart';
import '../controller/profile_controller.dart';
import '../../../../../../utils/constants/app_images.dart';
import '../../../../../../utils/constants/app_string.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Body Section Starts here
      body: GetBuilder<ProfileController>(
        builder: (controller) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 100.h),
              child: Column(
                children: [
                  /// User Profile Image here
                  Center(
                    child: CommonImage(
                      imageSrc: AppImages.profile,
                      size: 120,
                      defaultImage: AppImages.profile,
                    ),
                  ),

                  /// User Name here
                  const CommonText(
                    text: "Emma Phillips",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    top: 20,
                  ),
                  const CommonText(
                    text: "www.emmaphilips.com",
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey,
                    top: 4,
                    bottom: 24,
                  ),

                  /// Edit Profile item here
                  Item(
                    icon: AppImages.edit,
                    title: AppString.editProfile,
                    onTap: () => Get.toNamed(AppRoutes.editProfile),
                  ),
                  Item(
                    icon: AppImages.password,
                    title: AppString.changePassword,
                    onTap: () => Get.toNamed(AppRoutes.changePassword),
                  ),

                  /// Setting item here
                  Item(
                    icon: AppImages.option,
                    title: "Preferences",
                    onTap: () => Get.toNamed(AppRoutes.preferences),
                  ),
                  Item(
                    icon: AppImages.check,
                    title: "Permission",
                    onTap: () => Get.toNamed(AppRoutes.permission),
                  ),

                  /// Setting item here
                  Item(
                    icon: AppImages.qrscan,
                    title: "Create Promo",
                    onTap: () => Get.toNamed(AppRoutes.createPromo),
                  ),
                  Item(
                    icon: AppImages.information,
                    title: "Contact Us",
                    onTap: () => Get.toNamed(AppRoutes.contactUs),
                  ),

                  /// Language item here

                  /// Log Out item here
                  // Item(
                  //   icon: AppImages.information,
                  //   title: AppString.logOut,
                  //   onTap: logOutPopUp,
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
