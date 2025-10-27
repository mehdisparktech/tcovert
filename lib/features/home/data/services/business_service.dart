import '../../../../config/api/api_end_point.dart';
import '../../../../services/api/api_response_model.dart';
import '../../../../services/api/api_service.dart';
import '../models/business_response_model.dart';
import '../models/business_detail_response_model.dart';

class BusinessService {
  /// Fetch nearby businesses
  static Future<BusinessResponseModel?> getNearbyBusinesses({
    required int page,
    required int limit,
    required double lat,
    required double lng,
  }) async {
    try {
      final url =
          '${ApiEndPoint.business}?page=$page&limit=$limit&lat=$lat&lng=$lng';

      final ApiResponseModel response = await ApiService.get(url);

      if (response.statusCode == 200 && response.data.isNotEmpty) {
        return BusinessResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      print('Error fetching businesses: $e');
      return null;
    }
  }

  /// Fetch business details by ID
  static Future<BusinessDetailResponseModel?> getBusinessDetail({
    required String businessId,
  }) async {
    try {
      final url = '${ApiEndPoint.business}/user/$businessId';

      final ApiResponseModel response = await ApiService.get(url);

      if (response.statusCode == 200 && response.data.isNotEmpty) {
        return BusinessDetailResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      print('Error fetching business detail: $e');
      return null;
    }
  }
}
