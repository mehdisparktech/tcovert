class ContactUsResponseModel {
  final bool success;
  final String message;
  final ContactUsData? data;

  ContactUsResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory ContactUsResponseModel.fromJson(Map<dynamic, dynamic> json) {
    return ContactUsResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? ContactUsData.fromJson(json['data']) : null,
    );
  }
}

class ContactUsData {
  final String id;
  final String name;
  final String email;
  final String subject;
  final String message;
  final bool resolved;
  final String createdAt;
  final String updatedAt;
  final int v;

  ContactUsData({
    required this.id,
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
    required this.resolved,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory ContactUsData.fromJson(Map<String, dynamic> json) {
    return ContactUsData(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      subject: json['subject'] ?? '',
      message: json['message'] ?? '',
      resolved: json['resolved'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      v: json['__v'] ?? 0,
    );
  }
}
