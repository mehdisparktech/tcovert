import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tcovert/services/storage/storage_keys.dart';
import '../../../../../../config/route/app_routes.dart';
import '../../../../component/image/common_image.dart';
import '../../../../component/other_widgets/item.dart';
import '../../../../component/pop_up/common_pop_menu.dart';
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
                    text: LocalStorageKeys.myName,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    top: 20,
                    bottom: 24,
                  ),

                  /// Edit Profile item here
                  Item(
                    icon: Icons.person,
                    title: AppString.editProfile,
                    onTap: () => Get.toNamed(AppRoutes.editProfile),
                  ),
                  Item(
                    icon: Icons.password,
                    title: AppString.changePassword,
                    onTap: () => Get.toNamed(AppRoutes.changePassword),
                  ),

                  /// Setting item here
                  Item(icon: Icons.settings, title: "Preferences"),
                  Item(icon: Icons.check_circle, title: "Permission"),

                  /// Setting item here
                  Item(icon: Icons.scanner, title: "Create Promo"),
                  Item(icon: Icons.contact_support, title: "Contact Us"),
                  Item(icon: Icons.info, title: "About Us"),

                  /// Language item here

                  /// Log Out item here
                  Item(
                    icon: Icons.logout,
                    title: AppString.logOut,
                    onTap: logOutPopUp,
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
