import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../component/text/common_text.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_images.dart';
import '../../../../component/image/common_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markers = {};
  LatLng? currentLocation;
  bool isLoading = true;

  // Sample user data that would normally come from API
  final List<Map<String, dynamic>> nearbyUsers = [
    {
      'id': '1',
      'name': 'Alan Deo',
      'description': 'Uploaded 14 photos',
      'time': '2 mi - 17 min',
      'lat': 37.7749,
      'lng': -122.4194,
      'image': 'https://via.placeholder.com/60x60',
      'isRed': true,
    },
    {
      'id': '2',
      'name': 'Martinez',
      'description': 'Active now',
      'time': '1.5 mi - 12 min',
      'lat': 37.7849,
      'lng': -122.4094,
      'image': 'https://via.placeholder.com/60x60',
      'isRed': false,
    },
    {
      'id': '3',
      'name': 'Concord',
      'description': 'Last seen 5 min ago',
      'time': '3 mi - 20 min',
      'lat': 37.7649,
      'lng': -122.4294,
      'image': 'https://via.placeholder.com/60x60',
      'isRed': true,
    },
    {
      'id': '4',
      'name': 'Pleasant Hill',
      'description': 'Online',
      'time': '2.5 mi - 15 min',
      'lat': 37.7549,
      'lng': -122.4394,
      'image': 'https://via.placeholder.com/60x60',
      'isRed': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    await _requestLocationPermission();
    await _getCurrentLocation();
    _createMarkers();
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isDenied) {
      Get.snackbar(
        "Permission Required",
        "Location permission is required to show nearby friends",
        backgroundColor: AppColors.red,
        colorText: AppColors.white,
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
        isLoading = false;
      });
    } catch (e) {
      // Use default location (San Francisco) if location access fails
      setState(() {
        currentLocation = const LatLng(37.7749, -122.4194);
        isLoading = false;
      });
    }
  }

  void _createMarkers() {
    for (var user in nearbyUsers) {
      markers.add(
        Marker(
          markerId: MarkerId(user['id']),
          position: LatLng(user['lat'], user['lng']),
          icon:
              user['isRed']
                  ? BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed,
                  )
                  : BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue,
                  ),
          onTap: () => _showUserBottomSheet(user),
        ),
      );
    }
  }

  void _showUserBottomSheet(Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder:
          (context) => Container(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Profile Section
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30.r,
                      backgroundColor: AppColors.grey,
                      child: ClipOval(
                        child: CommonImage(
                          imageSrc: user['image'],
                          height: 60,
                          width: 60,
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText(
                            text: user['name'],
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 4.h),
                          CommonText(
                            text: user['description'],
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textFiledColor,
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 4.h),
                          CommonText(
                            text: user['time'],
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.secondary,
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Get.back(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: const CommonText(
                          text: "Message",
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Get.back(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.transparent,
                          side: const BorderSide(color: AppColors.secondary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: const CommonText(
                          text: "View Profile",
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Google Map
          if (currentLocation != null && !isLoading)
            GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              initialCameraPosition: CameraPosition(
                target: currentLocation!,
                zoom: 14.0,
              ),
              markers: markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: false,
              trafficEnabled: false,
              buildingsEnabled: true,
              mapType: MapType.normal,
            ),

          // Loading indicator
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(color: AppColors.secondary),
            ),

          // Top Header with Search and Profile
          Positioned(
            top: MediaQuery.of(context).padding.top + 10.h,
            left: 20.w,
            right: 20.w,
            child: Row(
              children: [
                // Search Bar
                Expanded(
                  child: Container(
                    height: 45.h,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(25.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 15.w),
                        Icon(Icons.search, color: AppColors.grey, size: 20.sp),
                        SizedBox(width: 10.w),
                        const Expanded(
                          child: CommonText(
                            text: "Nearby Friends",
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.grey,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 15.w),
                // Profile Avatar
                CircleAvatar(
                  radius: 22.r,
                  backgroundColor: AppColors.white,
                  child: CircleAvatar(
                    radius: 20.r,
                    backgroundColor: AppColors.grey,
                    child: ClipOval(
                      child: CommonImage(
                        imageSrc: AppImages.profile,
                        height: 40,
                        width: 40,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom User Card (like Alan Deo in the image)
          Positioned(
            bottom: 30.h,
            left: 20.w,
            right: 20.w,
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25.r,
                    backgroundColor: AppColors.grey,
                    child: ClipOval(
                      child: CommonImage(
                        imageSrc: nearbyUsers[0]['image'],
                        height: 50,
                        width: 50,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CommonText(
                          text: nearbyUsers[0]['name'],
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 2.h),
                        CommonText(
                          text: nearbyUsers[0]['description'],
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.grey,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 2.h),
                        CommonText(
                          text: nearbyUsers[0]['time'],
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.grey,
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showUserBottomSheet(nearbyUsers[0]),
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.grey,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // My Location Button
          Positioned(
            bottom: 200.h,
            right: 20.w,
            child: FloatingActionButton(
              onPressed: _goToCurrentLocation,
              backgroundColor: AppColors.white,
              child: const Icon(Icons.my_location, color: AppColors.secondary),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _goToCurrentLocation() async {
    if (currentLocation != null) {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: currentLocation!, zoom: 16.0),
        ),
      );
    }
  }
}
