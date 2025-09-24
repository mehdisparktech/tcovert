import 'package:get/get.dart';
import '../../features/auth/change_password/presentation/screen/change_password_screen.dart';
import '../../features/auth/forgot password/presentation/screen/create_password.dart';
import '../../features/auth/forgot password/presentation/screen/forgot_password.dart';
import '../../features/auth/forgot password/presentation/screen/verify_screen.dart';
import '../../features/auth/sign in/presentation/screen/sign_in_screen.dart';
import '../../features/auth/sign up/presentation/screen/sign_up_screen.dart';
import '../../features/auth/sign up/presentation/screen/verify_user.dart';
import '../../features/profile/presentation/screen/about_us_screen.dart';
import '../../features/profile/presentation/screen/contact_us_screen.dart';
import '../../features/profile/presentation/screen/create_promo_screen.dart';
import '../../features/profile/presentation/screen/edit_profile.dart';
import '../../features/profile/presentation/screen/permission_screen.dart';
import '../../features/profile/presentation/screen/preferences_screen.dart';
import '../../features/profile/presentation/screen/profile_screen.dart';
import '../../features/profile/presentation/screen/request_screen.dart';
import '../../features/setting/presentation/screen/privacy_policy_screen.dart';
import '../../features/setting/presentation/screen/setting_screen.dart';
import '../../features/setting/presentation/screen/terms_of_services_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/home/presentation/screen/home_screen.dart';

class AppRoutes {
  static const String test = "/test_screen.dart";
  static const String splash = "/splash_screen.dart";
  static const String home = "/home_screen.dart";
  static const String signUp = "/sign_up_screen.dart";
  static const String verifyUser = "/verify_user.dart";
  static const String signIn = "/sign_in_screen.dart";
  static const String forgotPassword = "/forgot_password.dart";
  static const String verifyEmail = "/verify_screen.dart";
  static const String createPassword = "/create_password.dart";
  static const String changePassword = "/change_password_screen.dart";

  static const String profile = "/profile_screen.dart";
  static const String editProfile = "/edit_profile.dart";
  static const String preferences = "/preferences_screen.dart";
  static const String permission = "/permission_screen.dart";
  static const String createPromo = "/create_promo_screen.dart";
  static const String contactUs = "/contact_us_screen.dart";
  static const String request = "/request_screen.dart";
  static const String aboutUs = "/about_us_screen.dart";
  static const String privacyPolicy = "/privacy_policy_screen.dart";
  static const String termsOfServices = "/terms_of_services_screen.dart";
  static const String setting = "/setting_screen.dart";

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: home, page: () => const HomeScreen()),

    GetPage(name: signUp, page: () => SignUpScreen()),
    GetPage(name: verifyUser, page: () => const VerifyUser()),
    GetPage(name: signIn, page: () => SignInScreen()),
    GetPage(name: forgotPassword, page: () => ForgotPasswordScreen()),
    GetPage(name: verifyEmail, page: () => const VerifyScreen()),
    GetPage(name: createPassword, page: () => CreatePassword()),
    GetPage(name: changePassword, page: () => ChangePasswordScreen()),

    GetPage(name: profile, page: () => const ProfileScreen()),
    GetPage(name: editProfile, page: () => EditProfile()),
    GetPage(name: preferences, page: () => const PreferencesScreen()),
    GetPage(name: permission, page: () => const PermissionScreen()),
    GetPage(name: createPromo, page: () => const CreatePromoScreen()),
    GetPage(name: contactUs, page: () => const ContactUsScreen()),
    GetPage(name: request, page: () => const RequestScreen()),
    GetPage(name: aboutUs, page: () => const AboutUsScreen()),
    GetPage(name: privacyPolicy, page: () => const PrivacyPolicyScreen()),
    GetPage(name: termsOfServices, page: () => const TermsOfServicesScreen()),
    GetPage(name: setting, page: () => const SettingScreen()),
  ];
}
