import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tcovert/services/location/location_search_service.dart';
import 'package:tcovert/features/home/presentation/widgets/business_image_view_bottom_sheet.dart';
import 'package:tcovert/features/home/presentation/widgets/business_information_bottom_sheet.dart';
import 'package:tcovert/services/api/api_service.dart';
import 'package:tcovert/services/storage/storage_keys.dart';
import 'package:tcovert/services/storage/storage_services.dart';
import 'package:tcovert/utils/app_utils.dart';
import 'package:tcovert/utils/constants/app_images.dart';
import '../../../../config/route/app_routes.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../data/models/business_model.dart';
import '../../data/services/business_service.dart';
import '../../../../config/api/api_end_point.dart';
import '../widgets/user_bottom_sheet.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  // Observable variables
  var isLoading = false.obs;
  var nearbyUsers = <Map<String, dynamic>>[].obs;
  var nearbyBusinesses = <BusinessModel>[].obs;
  var selectedUser = Rxn<Map<String, dynamic>>();
  var selectedBusiness = Rxn<BusinessModel>();
  var role = LocalStorage.role;

  // Location search variables
  final TextEditingController searchController = TextEditingController();
  var searchSuggestions = <Map<String, dynamic>>[].obs;
  var isSearching = false.obs;
  var showSuggestions = false.obs;
  var hasSearchText = false.obs;

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
    print("====================>>>>> Role: $role");
    _initializeSampleUsers();
    // Set the first user as selected by default
    if (nearbyUsers.isNotEmpty) {
      selectedUser.value = nearbyUsers[0];
    }
    // Fetch real-time business data
    fetchNearbyBusinesses();
    profileApiCall();
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
    searchController.dispose();
    super.onClose();
  }

  // Initialize sample user data (would normally come from API)
  Future<void> _initializeSampleUsers() async {
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

    await _createMarkers();
  }

  // Navigation methods
  void navigateToProfile() {
    Get.toNamed(AppRoutes.profile);
  }

  void showUserBottomSheet(BuildContext context, String businessId) {
    UserBottomSheet.show(context, businessId);
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

  // Create custom marker with image on top of pin
  Future<BitmapDescriptor> _createCustomMarkerWithImage(String imageUrl) async {
    try {
      const double imageSize = 100.0;
      const double markerHeight = 200.0;
      const double markerWidth = 100.0;

      final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);

      // Load the image
      ui.Image? userImage;

      if (imageUrl.startsWith('http')) {
        try {
          final response = await http.get(Uri.parse(imageUrl));
          if (response.statusCode == 200) {
            final Uint8List bytes = response.bodyBytes;
            final ui.Codec codec = await ui.instantiateImageCodec(
              bytes,
              targetWidth: imageSize.toInt(),
              targetHeight: imageSize.toInt(),
            );
            final ui.FrameInfo frameInfo = await codec.getNextFrame();
            userImage = frameInfo.image;
          }
        } catch (e) {
          print('Error loading network image: $e');
        }
      } else {
        try {
          final ByteData data = await rootBundle.load(imageUrl);
          final Uint8List bytes = data.buffer.asUint8List();
          final ui.Codec codec = await ui.instantiateImageCodec(
            bytes,
            targetWidth: imageSize.toInt(),
            targetHeight: imageSize.toInt(),
          );
          final ui.FrameInfo frameInfo = await codec.getNextFrame();
          userImage = frameInfo.image;
        } catch (e) {
          print('Error loading asset image: $e');
        }
      }

      // Draw white background with border for image
      final Paint bgPaint =
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.fill;

      final Paint borderPaint =
          Paint()
            ..color = AppColors.secondary
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3.0;

      const double imageX = (markerWidth - imageSize) / 2;
      const double imageY = 0;

      // Draw rounded rectangle background
      final RRect imageRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(imageX, imageY, imageSize, imageSize),
        const Radius.circular(8),
      );

      canvas.drawRRect(imageRect, bgPaint);

      // Draw the user image if loaded
      if (userImage != null) {
        final Rect srcRect = Rect.fromLTWH(
          0,
          0,
          userImage.width.toDouble(),
          userImage.height.toDouble(),
        );
        final Rect dstRect = Rect.fromLTWH(
          imageX + 3,
          imageY + 3,
          imageSize - 6,
          imageSize - 6,
        );

        // Clip to rounded rectangle
        canvas.save();
        canvas.clipRRect(
          RRect.fromRectAndRadius(dstRect, const Radius.circular(6)),
        );
        canvas.drawImageRect(userImage, srcRect, dstRect, Paint());
        canvas.restore();
      }

      // Draw border
      canvas.drawRRect(imageRect, borderPaint);

      // Draw location pin icon below the image
      const double pinTop = imageSize;
      const double pinSize = 80.0;

      final Paint pinPaint =
          Paint()
            ..color = AppColors.secondary
            ..style = PaintingStyle.fill;

      final Paint pinBorderPaint =
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.0;

      // Draw location pin shape (teardrop/pin shape)
      final Path pinPath = Path();

      // Top circle part of the pin
      final double circleRadius = pinSize * 0.35;
      final double circleCenterX = markerWidth / 2;
      final double circleCenterY = pinTop + circleRadius;

      pinPath.addOval(
        Rect.fromCircle(
          center: Offset(circleCenterX, circleCenterY),
          radius: circleRadius,
        ),
      );

      // Bottom triangle/point of the pin
      final double pointTop = circleCenterY + circleRadius * 0.7;
      final double pointBottom = pinTop + pinSize;
      final double pointWidth = circleRadius * 0.8;

      pinPath.moveTo(circleCenterX - pointWidth, pointTop);
      pinPath.lineTo(circleCenterX, pointBottom);
      pinPath.lineTo(circleCenterX + pointWidth, pointTop);
      pinPath.close();

      // Draw pin with shadow effect
      canvas.save();
      canvas.drawShadow(pinPath, Colors.black.withOpacity(0.3), 3.0, false);
      canvas.restore();

      canvas.drawPath(pinPath, pinPaint);
      canvas.drawPath(pinPath, pinBorderPaint);

      // Draw inner circle (white dot in the middle)
      final Paint innerCirclePaint =
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(circleCenterX, circleCenterY),
        circleRadius * 0.4,
        innerCirclePaint,
      );

      // Convert to image
      final ui.Image markerImage = await pictureRecorder.endRecording().toImage(
        markerWidth.toInt(),
        markerHeight.toInt(),
      );
      final ByteData? byteData = await markerImage.toByteData(
        format: ui.ImageByteFormat.png,
      );
      final Uint8List imageData = byteData!.buffer.asUint8List();

      return BitmapDescriptor.fromBytes(imageData);
    } catch (e) {
      print('Error creating custom marker: $e');
      return BitmapDescriptor.defaultMarker;
    }
  }

  // Create markers for nearby users
  Future<void> _createMarkers() async {
    markers.clear();

    for (var i = 0; i < nearbyUsers.length; i++) {
      final user = nearbyUsers[i];

      // Create custom marker with image
      final customIcon = await _createCustomMarkerWithImage(user['image']);

      final marker = Marker(
        markerId: MarkerId(user['id']),
        position: LatLng(user['lat'], user['lng']),
        onTap: () => selectUser(user),
        infoWindow: InfoWindow(
          title: user['name'],
          snippet: user['description'],
        ),
        icon: customIcon,
        anchor: const Offset(0.5, 1.0), // Anchor at bottom center of marker
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
        await _createMarkers();

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

  Future<void> profileApiCall() async {
    try {
      var profileResponse = await ApiService.get(
        ApiEndPoint.profile,
        header: {"Authorization": "Bearer ${LocalStorage.token}"},
      );
      if (profileResponse.statusCode == 200) {
        var profileData = profileResponse.data;
        LocalStorage.userId = profileData['data']['_id'];
        LocalStorage.myRole = profileData['data']['role'];
        LocalStorage.status = profileData['data']['status'];
        LocalStorage.verified = profileData['data']['verified'];
        LocalStorage.myImage = profileData['data']['profileImage'];
        LocalStorage.myName = profileData['data']['name'];
        LocalStorage.myEmail = profileData['data']['email'];
        LocalStorage.role = profileData['data']['role'];
        LocalStorage.setString(LocalStorageKeys.myRole, LocalStorage.myRole);
        LocalStorage.setString(LocalStorageKeys.status, LocalStorage.status);
        LocalStorage.setBoolValue(
          LocalStorageKeys.verified,
          LocalStorage.verified,
        );
        LocalStorage.setString(LocalStorageKeys.myImage, LocalStorage.myImage);
        LocalStorage.setString(LocalStorageKeys.myName, LocalStorage.myName);
        LocalStorage.setString(LocalStorageKeys.myEmail, LocalStorage.myEmail);
        LocalStorage.setString(LocalStorageKeys.role, LocalStorage.role);
      } else {
        Utils.errorSnackBar(
          profileResponse.statusCode.toString(),
          profileResponse.message,
        );
      }
    } catch (e) {
      Utils.errorSnackBar(e.toString(), e.toString());
    }
  }

  // Location search methods
  Future<void> searchLocation(String query) async {
    hasSearchText.value = query.isNotEmpty;

    if (query.isEmpty) {
      searchSuggestions.clear();
      showSuggestions.value = false;
      return;
    }

    try {
      isSearching.value = true;
      showSuggestions.value = true;

      final results = await LocationSearchService.searchPlaces(query);
      searchSuggestions.value = results;
    } catch (e) {
      print('Error searching location: $e');
      searchSuggestions.clear();
    } finally {
      isSearching.value = false;
    }
  }

  Future<void> selectLocation(Map<String, dynamic> place) async {
    try {
      final lat = place['lat'];
      final lng = place['lng'];
      final description = place['description'];

      // Update search field
      searchController.text = description;
      showSuggestions.value = false;

      // Move camera to selected location
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(lat, lng), 15.0),
      );

      // Add a marker for the searched location
      final searchMarker = Marker(
        markerId: const MarkerId('searched_location'),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: place['name'], snippet: description),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      );

      // Add to markers
      markers.removeWhere((m) => m.markerId.value == 'searched_location');
      markers.add(searchMarker);

      Get.snackbar(
        "Location Found",
        description,
        backgroundColor: AppColors.secondary,
        colorText: AppColors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('Error selecting location: $e');
      Get.snackbar(
        "Error",
        "Failed to navigate to location",
        backgroundColor: AppColors.red,
        colorText: AppColors.white,
      );
    }
  }

  void clearSearch() {
    searchController.clear();
    searchSuggestions.clear();
    showSuggestions.value = false;
    hasSearchText.value = false;
    // Remove search marker
    markers.removeWhere((m) => m.markerId.value == 'searched_location');
  }

  Future<void> gotoBusinessInformationBottomSheet(BuildContext context) async {
    try {
      final response = await ApiService.get(
        ApiEndPoint.businessInformation,
        header: {"Authorization": "Bearer ${LocalStorage.token}"},
      );

      if (response.statusCode == 200) {
        // Parse the response data
        final businessData = response.data['data'];

        // Check if gallery or usersPictures exist
        final hasGallery =
            businessData['gallery'] != null &&
            (businessData['gallery'] as List).isNotEmpty;
        final hasUsersPictures =
            businessData['usersPictures'] != null &&
            (businessData['usersPictures'] as List).isNotEmpty;

        if (hasGallery || hasUsersPictures) {
          // Navigate to BusinessImageViewBottomSheet with data
          BusinessImageViewBottomSheet.show(
            context,
            businessId: businessData['_id'] ?? 'Unknown',
            businessName: businessData['name'] ?? 'Unknown',
            businessAddress: businessData['address'] ?? 'Unknown',
            gallery: businessData['gallery'] ?? [],
            usersPictures: businessData['usersPictures'] ?? [],
          );
        } else {
          BusinessInformationBottomSheet.show(context);
        }
      } else {
        BusinessInformationBottomSheet.show(context);
      }
    } catch (e) {
      BusinessInformationBottomSheet.show(context);
    }
  }
}
