class ApiEndPoint {
  static const baseUrl = "http://10.10.7.72:5000/api/v1/";
  static const imageUrl = "http://10.10.7.72:5000";
  static const socketUrl = "http://10.10.7.72:5000";

  static const signUp = "user";
  static const verifyEmail = "auth/send-otp";
  static const signIn = "auth/login";
  static const forgotPassword = "auth/forget-password";
  static const verifyOtp = "auth/verify-otp";
  static const resetPassword = "auth/reset-password";
  static const changePassword = "auth/change-password";
  static const user = "user";
  static const notifications = "notifications";
  static const privacyPolicies = "privacy-policies";
  static const termsOfServices = "terms-and-conditions";
  static const chats = "chats";
  static const messages = "messages";
  static const contactUs = "contact";
  static const preferences = "preference";
  static const profile = "user/me";
  static const authPreferences = "preference";
  static const resendOtp = "auth/resend-otp";
  static const promo = "promo";
  static const business = "business";
  static const businessRequest = "business-request";
}
