import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tcovert/utils/constants/app_images.dart';
import '../../../../config/route/app_routes.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../data/models/business_model.dart';
import '../../data/services/business_service.dart';
import '../../../../config/api/api_end_point.dart';
import '../widgets/user_bottom_sheet.dart';

class HomeController extends GetxController {
  // Observable variables
  var isLoading = false.obs;
  var nearbyUsers = <Map<String, dynamic>>[].obs;
  var nearbyBusinesses = <BusinessModel>[].obs;
  var selectedUser = Rxn<Map<String, dynamic>>();
  var selectedBusiness = Rxn<BusinessModel>();

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
    // Fetch real-time business data
    fetchNearbyBusinesses();
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

      // Refresh business data with new location
      await fetchNearbyBusinesses();
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

  // API methods
  Future<void> fetchNearbyBusinesses() async {
    try {
      isLoading.value = true;

      // Get current position or use default coordinates
      final lat = currentPosition.value?.latitude ?? 23.810331;
      final lng = currentPosition.value?.longitude ?? 90.412521;

      final response = await BusinessService.getNearbyBusinesses(
        page: 1,
        limit: 10,
        lat: lat,
        lng: lng,
      );

      if (response != null && response.success) {
        nearbyBusinesses.value = response.data;

        // Convert businesses to user format for backward compatibility
        nearbyUsers.value =
            response.data.map((business) {
              return {
                'id': business.id,
                'name': business.name,
                'description': business.address,
                'time': _calculateDistance(
                  business.location.latitude,
                  business.location.longitude,
                ),
                'image':
                    business.coverPhoto != null
                        ? '${ApiEndPoint.imageUrl}${business.coverPhoto!.imageUrl}'
                        : AppImages.image1,
                'isOnline': business.isApproved,
                'lat': business.location.latitude,
                'lng': business.location.longitude,
              };
            }).toList();

        // Set first business as selected
        if (nearbyBusinesses.isNotEmpty) {
          selectedBusiness.value = nearbyBusinesses[0];
          selectedUser.value = nearbyUsers[0];
        }

        // Update markers
        _createMarkers();

        Get.snackbar(
          "Success",
          "${response.data.length} businesses loaded",
          backgroundColor: AppColors.secondary,
          colorText: AppColors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          "Info",
          "No businesses found nearby",
          backgroundColor: AppColors.secondary,
          colorText: AppColors.white,
        );
      }
    } catch (e) {
      print('Error fetching businesses: $e');
      Get.snackbar(
        "Error",
        "Failed to fetch nearby businesses",
        backgroundColor: AppColors.red,
        colorText: AppColors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Calculate distance and time estimation
  String _calculateDistance(double lat, double lng) {
    if (currentPosition.value == null) {
      return 'Unknown distance';
    }

    final distance = Geolocator.distanceBetween(
      currentPosition.value!.latitude,
      currentPosition.value!.longitude,
      lat,
      lng,
    );

    // Convert to miles
    final miles = distance / 1609.34;
    // Estimate time (assuming 20 mph average speed)
    final minutes = (miles / 20 * 60).round();

    return '${miles.toStringAsFixed(1)} mi - $minutes min';
  }

  Future<void> fetchNearbyUsers() async {
    // Redirect to business fetch
    await fetchNearbyBusinesses();
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
