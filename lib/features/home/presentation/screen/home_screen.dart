import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tcovert/config/route/app_routes.dart';
import '../../../../component/text/common_text.dart';
import '../../../../component/image/common_image.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_images.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;

  // Sample user data that would normally come from API
  final List<Map<String, dynamic>> nearbyUsers = [
    {
      'id': '1',
      'name': 'Alan Deo',
      'description': 'Uploaded 14 photos',
      'time': '2 mi - 17 min',
      'image': 'https://via.placeholder.com/60x60',
      'isOnline': true,
    },
    {
      'id': '2',
      'name': 'Martinez',
      'description': 'Active now',
      'time': '1.5 mi - 12 min',
      'image': 'https://via.placeholder.com/60x60',
      'isOnline': true,
    },
    {
      'id': '3',
      'name': 'Concord',
      'description': 'Last seen 5 min ago',
      'time': '3 mi - 20 min',
      'image': 'https://via.placeholder.com/60x60',
      'isOnline': false,
    },
    {
      'id': '4',
      'name': 'Pleasant Hill',
      'description': 'Online',
      'time': '2.5 mi - 15 min',
      'image': 'https://via.placeholder.com/60x60',
      'isOnline': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header
            _buildHeader(),

            // Map Placeholder (will be replaced with Google Maps later)
            Expanded(
              child: Stack(
                children: [
                  // Map placeholder with background
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryColor.withOpacity(0.3),
                          AppColors.secondary.withOpacity(0.2),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.map_outlined,
                            size: 80,
                            color: AppColors.white,
                          ),
                          SizedBox(height: 16),
                          CommonText(
                            text: "Map will load here",
                            fontSize: 16,
                            color: AppColors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          CommonText(
                            text: "Google Maps Integration",
                            fontSize: 12,
                            color: AppColors.textFiledColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Sample markers overlay
                  ..._buildSampleMarkers(),

                  // Bottom User Card
                  _buildBottomUserCard(),

                  // My Location Button
                  _buildLocationButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
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
          GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.profile);
            },
            child: CircleAvatar(
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
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSampleMarkers() {
    return [
      // Sample marker positions (will be replaced with real map markers)
      Positioned(
        top: 100.h,
        left: 80.w,
        child: _buildMarkerWidget(nearbyUsers[0], AppColors.red),
      ),
      Positioned(
        top: 150.h,
        right: 100.w,
        child: _buildMarkerWidget(nearbyUsers[1], AppColors.secondary),
      ),
      Positioned(
        top: 250.h,
        left: 120.w,
        child: _buildMarkerWidget(nearbyUsers[2], AppColors.red),
      ),
      Positioned(
        bottom: 200.h,
        right: 80.w,
        child: _buildMarkerWidget(nearbyUsers[3], AppColors.secondary),
      ),
    ];
  }

  Widget _buildMarkerWidget(Map<String, dynamic> user, Color color) {
    return GestureDetector(
      onTap: () => _showUserBottomSheet(user),
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(Icons.person, color: AppColors.white, size: 20),
      ),
    );
  }

  Widget _buildBottomUserCard() {
    return Positioned(
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
    );
  }

  Widget _buildLocationButton() {
    return Positioned(
      bottom: 200.h,
      right: 20.w,
      child: FloatingActionButton(
        onPressed: () {
          Get.snackbar(
            "Location",
            "Getting current location...",
            backgroundColor: AppColors.secondary,
            colorText: AppColors.white,
          );
        },
        backgroundColor: AppColors.white,
        child: const Icon(Icons.my_location, color: AppColors.secondary),
      ),
    );
  }

  void _showUserBottomSheet(Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.transparent,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            child: Column(
              children: [
                // Header Section
                _buildBottomSheetHeader(user),

                // Content Section
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      children: [
                        // Promo Section
                        _buildPromoSection(),
                        SizedBox(height: 20.h),

                        // Photo Gallery Section
                        _buildPhotoGallerySection(),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildBottomSheetHeader(Map<String, dynamic> user) {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          // Drag Handle
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.grey,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 16.h),

          // Header with Close Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title and Location
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: "Starbucks",
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: AppColors.textFiledColor,
                          size: 16.sp,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: CommonText(
                            text: "756 Q31 Ines Riverwaly, Rhiannonchester",
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textFiledColor,
                            textAlign: TextAlign.left,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Close Button
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.white10,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, color: AppColors.white, size: 20.sp),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPromoSection() {
    return Column(
      children: [
        // Buy 1 Get 1 Free Promo
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(
                text: "Buy 1 Get 1 Free!",
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 4.h),
              CommonText(
                text: "Don't miss out on this amazing offer!",
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.white,
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),

        SizedBox(height: 12.h),

        // Get Promo Code Button
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: const CommonText(
            text: "Get Promo Code",
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoGallerySection() {
    final List<Map<String, String>> photos = [
      {'image': AppImages.image1, 'user': 'Ria Tachihara', 'time': '1 day ago'},
      {'image': AppImages.image2, 'user': 'Rina Shihara', 'time': '2 days ago'},
      {'image': AppImages.image2, 'user': 'Yua Minami', 'time': '3 days ago'},
      {'image': AppImages.image2, 'user': 'Ichikawa Mas', 'time': '4 days ago'},
      {
        'image': AppImages.image2,
        'user': 'Nozomi Sasaki',
        'time': '5 days ago',
      },
      {'image': AppImages.image2, 'user': 'Shima Sora', 'time': '1 week ago'},
      {'image': AppImages.image2, 'user': 'Stone Hans', 'time': '1 week ago'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Add Photo Button
        Container(
          width: double.infinity,
          height: 120.h,
          decoration: BoxDecoration(
            color: AppColors.white10,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColors.textFiledColor.withOpacity(0.3),
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: AppColors.textFiledColor, size: 32.sp),
              SizedBox(height: 8.h),
              CommonText(
                text: "Add Photo",
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textFiledColor,
              ),
            ],
          ),
        ),

        SizedBox(height: 16.h),

        // Photo Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.w,
            mainAxisSpacing: 8.h,
            childAspectRatio: 1.2,
          ),
          itemCount: photos.length,
          itemBuilder: (context, index) {
            return _buildPhotoItem(photos[index]);
          },
        ),
      ],
    );
  }

  Widget _buildPhotoItem(Map<String, String> photo) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: AppColors.white10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photo
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8.r)),
                color: AppColors.grey,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8.r)),
                child: CommonImage(
                  imageSrc: photo['image']!,
                  width: double.infinity,
                  fill: BoxFit.cover,
                ),
              ),
            ),
          ),

          // User Info
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(6.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 6.r,
                        backgroundColor: AppColors.secondary,
                        child: Icon(
                          Icons.person,
                          size: 8.sp,
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: CommonText(
                          text: photo['user']!,
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                          textAlign: TextAlign.left,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  CommonText(
                    text: photo['time']!,
                    fontSize: 7,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textFiledColor,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
