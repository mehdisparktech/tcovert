import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcovert/component/button/common_button.dart';
import 'package:tcovert/component/image/common_image.dart';
import 'package:tcovert/features/home/presentation/screen/image_view_screen.dart';
import 'package:tcovert/features/home/presentation/widgets/image_selete_bottom_sheet.dart';
import 'package:tcovert/utils/constants/app_colors.dart';
import 'package:tcovert/utils/constants/app_images.dart';
import '../../../../component/text/common_text.dart';
import '../../../../config/api/api_end_point.dart';
import 'package:timeago/timeago.dart' as timeago;

class BusinessImageViewBottomSheet extends StatefulWidget {
  final String businessId;
  final String businessName;
  final String businessAddress;
  final List<dynamic> gallery;
  final List<dynamic> usersPictures;

  const BusinessImageViewBottomSheet({
    super.key,
    required this.businessId,
    required this.businessName,
    required this.businessAddress,
    required this.gallery,
    required this.usersPictures,
  });

  static void show(
    BuildContext context, {
    required String businessId,
    required String businessName,
    required String businessAddress,
    required List<dynamic> gallery,
    required List<dynamic> usersPictures,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder:
          (context) => BusinessImageViewBottomSheet(
            businessId: businessId,
            businessName: businessName,
            businessAddress: businessAddress,
            gallery: gallery,
            usersPictures: usersPictures,
          ),
    );
  }

  @override
  State<BusinessImageViewBottomSheet> createState() => _ImageBottomSheetState();
}

class _ImageBottomSheetState extends State<BusinessImageViewBottomSheet> {
  int selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          SizedBox(height: 16.h),
        ],
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
                  text: widget.businessName,
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
                        text: widget.businessAddress,
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
        itemCount: widget.gallery.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildAddPhotoCard();
          }
          return _buildGalleryImageCard(widget.gallery[index - 1]);
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
        itemCount: widget.usersPictures.length,
        itemBuilder: (context, index) {
          return _buildUserPicImageCard(widget.usersPictures[index]);
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
            Navigator.pop(context);
            // Then show the image select bottom sheet
            ImageSeleteBottomSheet.show(
              context,
              businessId: widget.businessId,
              businessName: widget.businessName,
              businessAddress: widget.businessAddress,
            );
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

  Widget _buildGalleryImageCard(dynamic imageData) {
    final imageUrl = '${ApiEndPoint.imageUrl}${imageData['imageUrl']}';
    final uploadedAt = DateTime.parse(imageData['uploadedAt']);
    final timeAgo = timeago.format(uploadedAt);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageViewScreen(imageUrl: imageUrl),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
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
                text: timeAgo,
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserPicImageCard(dynamic imageData) {
    final imageUrl = '${ApiEndPoint.imageUrl}${imageData['imageUrl']}';
    final uploadedBy = imageData['uploadedBy'];
    final userName = uploadedBy['name'] ?? 'Unknown';
    final userProfileImage = uploadedBy['profileImage'];
    final uploadedAt = DateTime.parse(imageData['uploadedAt']);
    final timeAgo = timeago.format(uploadedAt);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageViewScreen(imageUrl: imageUrl),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
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
                    backgroundImage: NetworkImage(
                      userProfileImage.startsWith('http')
                          ? userProfileImage
                          : '${ApiEndPoint.imageUrl}$userProfileImage',
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                          text: userName,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          maxLines: 1,
                        ),
                        CommonText(
                          text: timeAgo,
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
