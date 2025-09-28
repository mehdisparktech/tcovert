// ... existing code ...
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcovert/component/image/common_image.dart';
import 'package:tcovert/component/text/common_text.dart';
import 'package:tcovert/utils/constants/app_images.dart';
import 'package:tcovert/utils/extensions/extension.dart';

class ImageViewScreen extends StatelessWidget {
  final String imageUrl;
  final String? title;
  final String? subtitle;

  const ImageViewScreen({
    super.key,
    required this.imageUrl,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.8),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Full-screen image
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    AppImages.image1,
                  ), // Changed from AssetImage(AppI) to AssetImage(AppImages.image1)
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Positioned(
              top: 16.w,
              left: 16.w,
              right: 16.w,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20.r,
                    backgroundColor: Colors.white.withOpacity(0.9),
                    child: ClipOval(
                      child: CommonImage(imageSrc: AppImages.profile),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CommonText(
                          text: "Risa Tachibana",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          textAlign: TextAlign.left,
                          maxLines: 1,
                        ),
                        CommonText(
                          text: "1 mo ago",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.8),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Bottom navigation bar
            Positioned(
              bottom: 60,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  20.width,
                  Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  20.width,
                  Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  20.width,
                  Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
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
}
