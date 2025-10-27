import 'package:get/get.dart';
import '../../data/models/business_detail_model.dart';
import '../../data/services/business_service.dart';

class UserBottomSheetController extends GetxController {
  // Observable variables
  var isLoading = false.obs;
  var businessDetail = Rxn<BusinessDetailModel>();
  var errorMessage = ''.obs;

  // Fetch business detail by ID
  Future<void> fetchBusinessDetail(String businessId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await BusinessService.getBusinessDetail(
        businessId: businessId,
      );

      if (response != null && response.success) {
        businessDetail.value = response.data;
      } else {
        errorMessage.value = 'Failed to load business details';
      }
    } catch (e) {
      print('Error fetching business detail: $e');
      errorMessage.value = 'An error occurred while loading data';
    } finally {
      isLoading.value = false;
    }
  }

  // Get formatted time ago from upload date
  String getTimeAgo(DateTime uploadedAt) {
    final now = DateTime.now();
    final difference = now.difference(uploadedAt);

    if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} min ago';
    } else {
      return 'Just now';
    }
  }

  @override
  void onClose() {
    businessDetail.value = null;
    super.onClose();
  }
}
