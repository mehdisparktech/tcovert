import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcovert/utils/constants/app_images.dart';
import '../../../../config/route/app_routes.dart';
import '../../../../utils/constants/app_colors.dart';
import '../widgets/user_bottom_sheet.dart';

class HomeController extends GetxController {
  // Observable variables
  var isLoading = false.obs;
  var nearbyUsers = <Map<String, dynamic>>[].obs;
  var selectedUser = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    _initializeSampleUsers();
    // Set the first user as selected by default
    if (nearbyUsers.isNotEmpty) {
      selectedUser.value = nearbyUsers[0];
    }
  }

  // Initialize sample user data (would normally come from API)
  void _initializeSampleUsers() {
    nearbyUsers.value = [
      {
        'id': '1',
        'name': 'Alan Deo',
        'description': 'Uploaded 14 photos',
        'time': '2 mi - 17 min',
        'image': AppImages.image1,
        'isOnline': true,
      },
      {
        'id': '2',
        'name': 'Martinez',
        'description': 'Active now',
        'time': '1.5 mi - 12 min',
        'image': AppImages.image2,
        'isOnline': true,
      },
      {
        'id': '3',
        'name': 'Concord',
        'description': 'Last seen 5 min ago',
        'time': '3 mi - 20 min',
        'image': AppImages.image3,
        'isOnline': false,
      },
      {
        'id': '4',
        'name': 'Pleasant Hill',
        'description': 'Uploaded 8 photos',
        'time': '2.5 mi - 15 min',
        'image': AppImages.image4,
        'isOnline': true,
      },
    ];

    // Set the first user as selected by default
    if (nearbyUsers.isNotEmpty) {
      selectedUser.value = nearbyUsers[0];
    }
  }

  // Navigation methods
  void navigateToProfile() {
    Get.toNamed(AppRoutes.profile);
  }

  void showUserBottomSheet(BuildContext context, Map<String, dynamic> user) {
    UserBottomSheet.show(context, user);
  }

  // Method to select a user when marker is clicked
  void selectUser(Map<String, dynamic> user) {
    selectedUser.value = user;
  }

  // Location methods
  void getCurrentLocation() {
    Get.snackbar(
      "Location",
      "Getting current location...",
      backgroundColor: AppColors.secondary,
      colorText: AppColors.white,
    );
  }

  // API methods (for future implementation)
  Future<void> fetchNearbyUsers() async {
    try {
      isLoading.value = true;
      // nearbyUsers.value = await apiService.getNearbyUsers();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to fetch nearby users",
        backgroundColor: AppColors.red,
        colorText: AppColors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      _initializeSampleUsers();
      return;
    }

    try {
      isLoading.value = true;
      // TODO: Implement search API call
      // Filter locally for now
      final filteredUsers =
          nearbyUsers
              .where(
                (user) =>
                    user['name'].toString().toLowerCase().contains(
                      query.toLowerCase(),
                    ) ||
                    user['description'].toString().toLowerCase().contains(
                      query.toLowerCase(),
                    ),
              )
              .toList();

      nearbyUsers.value = filteredUsers;
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to search users",
        backgroundColor: AppColors.red,
        colorText: AppColors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Marker-related methods
  Color getMarkerColor(int index) {
    return index % 2 == 0 ? AppColors.red : AppColors.secondary;
  }

  // Utility methods - now use selected user instead of first user
  String getSelectedUserName() {
    return selectedUser.value?['name'] ?? 'Unknown';
  }

  String getSelectedUserDescription() {
    return selectedUser.value?['description'] ?? 'No description';
  }

  String getSelectedUserTime() {
    return selectedUser.value?['time'] ?? 'Unknown time';
  }

  String getSelectedUserImage() {
    return selectedUser.value?['image'] ?? 'https://via.placeholder.com/60x60';
  }

  Map<String, dynamic>? getSelectedUser() {
    return selectedUser.value;
  }

  Map<String, dynamic>? getUserAt(int index) {
    return index < nearbyUsers.length ? nearbyUsers[index] : null;
  }
}
