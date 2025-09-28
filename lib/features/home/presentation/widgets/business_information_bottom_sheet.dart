// ignore_for_file: empty_catches

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class BusinessInformationBottomSheet extends StatefulWidget {
  const BusinessInformationBottomSheet({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BusinessInformationBottomSheetState createState() =>
      _BusinessInformationBottomSheetState();
}

class _BusinessInformationBottomSheetState
    extends State<BusinessInformationBottomSheet> {
  final TextEditingController _restaurantNameController =
      TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Pre-fill with sample data like in your image
    _restaurantNameController.text = "Starbucks";
    _locationController.text = "756 031 Ines Riverway, USA";
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (photo != null) {
        setState(() {
          _selectedImage = File(photo.path);
        });
      }
    } catch (e) {}
  }

  Future<void> _chooseFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {}
  }

  void _onConfirm() {
    // Handle confirm button press

    // Close the bottom sheet
    Navigator.of(context).pop({
      'restaurantName': _restaurantNameController.text,
      'location': _locationController.text,
      'image': _selectedImage,
    });
  }

  @override
  void dispose() {
    _restaurantNameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1A1B2E), // Dark blue background
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Business Information',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 24),

            // Restaurant Name Field
            Text(
              'Restaurant Name',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF2A2D47), // Darker blue for input
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Color(0xFF3A3F5C), width: 1),
              ),
              child: TextField(
                controller: _restaurantNameController,
                style: TextStyle(color: Colors.white, fontSize: 16),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  hintText: 'Enter restaurant name',
                  hintStyle: TextStyle(color: Colors.white38),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Location Field
            Text(
              'Location',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF2A2D47),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Color(0xFF3A3F5C), width: 1),
              ),
              child: TextField(
                controller: _locationController,
                style: TextStyle(color: Colors.white, fontSize: 16),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  hintText: 'Enter location',
                  hintStyle: TextStyle(color: Colors.white38),
                  suffixIcon: Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.my_location,
                      color: Colors.white54,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Cover Photo Section
            Text(
              'Cover Photo',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 12),

            // Photo Options
            Row(
              children: [
                // Take a Photo Button
                Expanded(
                  child: GestureDetector(
                    onTap: _takePhoto,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: Color(0xFF2A2D47),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Color(0xFF3A3F5C), width: 1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white54,
                            size: 24,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Take a Photo',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),

                // Choose from Gallery Button
                Expanded(
                  child: GestureDetector(
                    onTap: _chooseFromGallery,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: Color(0xFF2A2D47),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Color(0xFF3A3F5C), width: 1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.photo_library_outlined,
                            color: Colors.white54,
                            size: 24,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Choose from Gallery',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Show selected image preview
            if (_selectedImage != null) ...[
              SizedBox(height: 16),
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: FileImage(_selectedImage!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],

            SizedBox(height: 24),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00BCD4), // Cyan blue
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Confirm',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 16), // Bottom padding for safe area
          ],
        ),
      ),
    );
  }
}

// Usage Example - How to show the bottom sheet
// class BusinessInfoExample extends StatelessWidget {
//   void _showBusinessInfoBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder:
//           (context) => Padding(
//             padding: EdgeInsets.only(
//               bottom: MediaQuery.of(context).viewInsets.bottom,
//             ),
//             child: BusinessInformationBottomSheet(),
//           ),
//     ).then((result) {
//       // Handle the result when bottom sheet is dismissed
//       if (result != null) {
//         print('Bottom sheet result: $result');
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Business Info Example')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () => _showBusinessInfoBottomSheet(context),
//           child: Text('Show Business Information'),
//         ),
//       ),
//     );
//   }
// }

// Main function to run the example
