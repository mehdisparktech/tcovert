import 'business_detail_model.dart';

class BusinessDetailResponseModel {
  final bool success;
  final String message;
  final BusinessDetailModel data;

  BusinessDetailResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory BusinessDetailResponseModel.fromJson(Map<String, dynamic> json) {
    return BusinessDetailResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: BusinessDetailModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }
}
