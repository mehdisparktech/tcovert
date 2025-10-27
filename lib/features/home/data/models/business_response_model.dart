import 'business_model.dart';
import 'pagination_model.dart';

class BusinessResponseModel {
  final bool success;
  final String message;
  final PaginationModel pagination;
  final List<BusinessModel> data;

  BusinessResponseModel({
    required this.success,
    required this.message,
    required this.pagination,
    required this.data,
  });

  factory BusinessResponseModel.fromJson(Map<String, dynamic> json) {
    return BusinessResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      pagination: PaginationModel.fromJson(json['pagination'] ?? {}),
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => BusinessModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'pagination': pagination.toJson(),
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}
