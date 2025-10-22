import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tcovert/utils/constants/app_images.dart';
import '../../../../config/route/app_routes.dart';
import '../../../../utils/constants/app_colors.dart';
import '../widgets/user_bottom_sheet.dart';

class HomeController extends GetxController {
  // Observable variables
  var isLoading = false.obs;
  var nearbyUsers = <Map<String, dynamic>>[].obs;
  var selectedUser = Rxn<Map<String, dynamic>>();

  // Google Maps variables
  GoogleMapController? mapController;
  var currentPosition = Rxn<Position>();
  var markers = <Marker>{}.obs;
  var initialCameraPosition =
      const CameraPosition(
        target: LatLng(23.8103, 90.4125), // Dhaka, Bangladesh default
        zoom: 14.0,
      ).obs;

  @override
  void onInit() {
    super.onInit();
    _initializeSampleUsers();
    // Set the first user as selected by default
    if (nearbyUsers.isNotEmpty) {
      selectedUser.value = nearbyUsers[0];
    }
  }

  @override
  void onReady() {
    super.onReady();
    // Request location permission when the screen is fully loaded
    _requestLocationPermission();
  }

  @override
  void onClose() {
    mapController?.dispose();
    super.onClose();
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
        'lat': 23.8103,
        'lng': 90.4125,
      },
      {
        'id': '2',
        'name': 'Martinez',
        'description': 'Active now',
        'time': '1.5 mi - 12 min',
        'image': AppImages.image2,
        'isOnline': true,
        'lat': 23.8140,
        'lng': 90.4200,
      },
      {
        'id': '3',
        'name': 'Concord',
        'description': 'Last seen 5 min ago',
        'time': '3 mi - 20 min',
        'image': AppImages.image3,
        'isOnline': false,
        'lat': 23.8050,
        'lng': 90.4080,
      },
      {
        'id': '4',
        'name': 'Pleasant Hill',
        'description': 'Uploaded 8 photos',
        'time': '2.5 mi - 15 min',
        'image': AppImages.image4,
        'isOnline': true,
        'lat': 23.8180,
        'lng': 90.4150,
      },
    ];

    // Set the first user as selected by default
    if (nearbyUsers.isNotEmpty) {
      selectedUser.value = nearbyUsers[0];
    }

    _createMarkers();
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

  // Location permission
  Future<void> _requestLocationPermission() async {
    try {
      // Check current permission status
      var status = await Permission.location.status;

      // If permission not determined yet or denied, request it
      if (status.isDenied || status.isRestricted || status.isLimited) {
        // Request permission - this will show the system dialog
        status = await Permission.location.request();
      }

      if (status.isGranted || status.isLimited) {
        // Permission granted, get location
        await getCurrentLocation();
      } else if (status.isDenied) {
        // User denied the permission
        Get.snackbar(
          "Permission Denied",
          "Location permission is needed to show your position",
          backgroundColor: AppColors.red.withOpacity(0.9),
          colorText: AppColors.white,
          duration: const Duration(seconds: 4),
          isDismissible: true,
          mainButton: TextButton(
            onPressed: () {
              Get.back();
              _requestLocationPermission(); // Ask again
            },
            child: const Text(
              "Retry",
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      print("Permission error: $e");
    }
  }

  // Location methods
  Future<void> getCurrentLocation() async {
    try {
      // Check permission first
      final permissionStatus = await Permission.location.status;
      if (!permissionStatus.isGranted) {
        await _requestLocationPermission();
        return;
      }

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar(
          "Location Service",
          "Please enable location services in your device settings",
          backgroundColor: AppColors.red,
          colorText: AppColors.white,
          duration: const Duration(seconds: 3),
        );
        return;
      }

      // Show loading indicator
      Get.snackbar(
        "Getting Location",
        "Please wait...",
        backgroundColor: AppColors.secondary.withOpacity(0.8),
        colorText: AppColors.white,
        duration: const Duration(seconds: 1),
        showProgressIndicator: true,
      );

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      currentPosition.value = position;

      // Move camera to current location
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          15.0,
        ),
      );

      Get.snackbar(
        "Location Updated",
        "Moved to your current location",
        backgroundColor: AppColors.secondary,
        colorText: AppColors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to get location. Please check your GPS and try again.",
        backgroundColor: AppColors.red,
        colorText: AppColors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  // Map methods
  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    print("✅ Google Map Created Successfully");
    // Location will be fetched after permission is granted
  }

  // Create markers for nearby users
  void _createMarkers() {
    markers.clear();

    for (var i = 0; i < nearbyUsers.length; i++) {
      final user = nearbyUsers[i];
      final marker = Marker(
        markerId: MarkerId(user['id']),
        position: LatLng(user['lat'], user['lng']),
        onTap: () => selectUser(user),
        infoWindow: InfoWindow(
          title: user['name'],
          snippet: user['description'],
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          i % 2 == 0 ? BitmapDescriptor.hueRed : BitmapDescriptor.hueAzure,
        ),
      );
      markers.add(marker);
    }
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
