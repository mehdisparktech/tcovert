import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcovert/component/button/common_button.dart';
import 'package:tcovert/component/image/common_image.dart';
import 'package:tcovert/utils/constants/app_colors.dart';
import 'package:tcovert/utils/constants/app_images.dart';
import '../../../../component/text/common_text.dart';

class BusinessImageViewBottomSheet extends StatefulWidget {
  const BusinessImageViewBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) => BusinessImageViewBottomSheet(),
    );
  }

  @override
  State<BusinessImageViewBottomSheet> createState() => _ImageBottomSheetState();
}

class _ImageBottomSheetState extends State<BusinessImageViewBottomSheet> {
  int selectedTabIndex = 0;

  // Gallery images
  final List<Map<String, String>> galleryImages = [
    {'image': AppImages.image1, 'time': '1 mo ago'},
    {'image': AppImages.image1, 'time': '1 mo ago'},
    {'image': AppImages.image1, 'time': '1 mo ago'},
    {'image': AppImages.image1, 'time': '1 mo ago'},
    {'image': AppImages.image1, 'time': '1 mo ago'},
    {'image': AppImages.image1, 'time': '1 mo ago'},
    {'image': AppImages.image1, 'time': '1 mo ago'},
    {'image': AppImages.image1, 'time': '1 mo ago'},
    {'image': AppImages.image1, 'time': '1 mo ago'},
  ];

  // User pic images with user info
  final List<Map<String, String>> userPicImages = [
    {'image': AppImages.image1, 'name': 'Bíp Tachibana', 'time': '1 mo ago'},
    {'image': AppImages.image1, 'name': 'Rina Ishihara', 'time': '1 mo ago'},
    {'image': AppImages.image1, 'name': 'Shima Sora', 'time': '1 mo ago'},
    {'image': AppImages.image1, 'name': 'Yua Mikami', 'time': '1 mo ago'},
    {'image': AppImages.image1, 'name': 'Minori Hatsune', 'time': '1 mo ago'},
    {'image': AppImages.image1, 'name': 'Naomi Sasaki', 'time': '1 mo ago'},
    {'image': AppImages.image1, 'name': 'Shima Sora', 'time': '1 mo ago'},
    {'image': AppImages.image1, 'name': 'Seito Hara', 'time': '1 mo ago'},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: Color(0xFF0A0E27),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          children: [
            _buildHeader(),
            _buildTabs(),
            Expanded(
              child:
                  selectedTabIndex == 0
                      ? _buildGalleryView()
                      : _buildUserPicView(),
            ),
            _buildSaveButton(),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CommonText(
                  text: "Starbucks",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 6.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CommonImage(imageSrc: AppImages.location2, size: 20.w),
                    SizedBox(width: 4.w),
                    Flexible(
                      child: CommonText(
                        text: "756 031 Ines Riverway, Rhiannonchester",
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          _buildTabItem("Gallery", 0),
          SizedBox(width: 20.w),
          _buildTabItem("User Pic", 1),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
    bool isSelected = selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTabIndex = index;
        });
      },
      child: Column(
        children: [
          CommonText(
            text: title,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Color(0xFF9E9E9E),
          ),
          SizedBox(height: 8.h),
          Container(
            height: 2.h,
            width: 50.w,
            color: isSelected ? AppColors.secondary : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryView() {
    return Padding(
      padding: EdgeInsets.all(10.w),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8.w,
          mainAxisSpacing: 8.h,
          childAspectRatio: 0.9,
        ),
        itemCount: galleryImages.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildAddPhotoCard();
          }
          return _buildGalleryImageCard(galleryImages[index - 1]);
        },
      ),
    );
  }

  Widget _buildUserPicView() {
    return Padding(
      padding: EdgeInsets.all(10.w),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8.w,
          mainAxisSpacing: 8.h,
          childAspectRatio: 0.9,
        ),
        itemCount: userPicImages.length,
        itemBuilder: (context, index) {
          return _buildUserPicImageCard(userPicImages[index]);
        },
      ),
    );
  }

  Widget _buildAddPhotoCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () {
            // Handle add photo action
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: Colors.grey[400], size: 32.sp),
              SizedBox(height: 8.h),
              CommonText(
                text: "Add Photo",
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFF9E9E9E),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGalleryImageCard(Map<String, String> imageData) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        image: DecorationImage(
          image: AssetImage(imageData['image']!),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
              ),
            ),
          ),
          Positioned(
            bottom: 8.h,
            left: 8.w,
            child: CommonText(
              text: imageData['time']!,
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserPicImageCard(Map<String, String> imageData) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        image: DecorationImage(
          image: AssetImage(imageData['image']!),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
              ),
            ),
          ),
          Positioned(
            bottom: 8.h,
            left: 8.w,
            right: 8.w,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 10.r,
                  backgroundImage: AssetImage(imageData['image']!),
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        text: imageData['name']!,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        maxLines: 1,
                      ),
                      CommonText(
                        text: imageData['time']!,
                        fontSize: 8,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[400]!,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: CommonButton(
        titleText: "Save",
        buttonColor: AppColors.secondary,
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
