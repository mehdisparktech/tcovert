import 'package:tcovert/services/storage/storage_services.dart';

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

  /// Create a new business
  static Future<ApiResponseModel> createBusiness({
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    List<String>? imagePaths,
  }) async {
    try {
      final body = {
        'name': name,
        'address': address,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
      };
      print("================>>${LocalStorage.token}");

      final ApiResponseModel response =
          await ApiService.multipartMultipleImages(
            ApiEndPoint.business,
            method: 'POST',
            body: body,
            imageName: 'image',
            imagePaths: imagePaths,
            header: {'Authorization': 'Bearer ${LocalStorage.token}'},
          );

      return response;
    } catch (e) {
      print('Error creating business: $e');
      return ApiResponseModel(500, {'message': 'Error creating business'});
    }
  }
}
