class PromoResponseModel {
  final bool success;
  final String message;
  final PromoData? data;

  PromoResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory PromoResponseModel.fromJson(Map<dynamic, dynamic> json) {
    return PromoResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? PromoData.fromJson(json['data']) : null,
    );
  }
}

class PromoData {
  final String id;
  final String user;
  final String title;
  final int discount;
  final String description;
  final String startDate;
  final String endDate;
  final String? promoCode;
  final String? qrCode;
  final bool generatePromocode;
  final bool generateQrCode;
  final bool active;
  final String createdAt;
  final String updatedAt;
  final int v;

  PromoData({
    required this.id,
    required this.user,
    required this.title,
    required this.discount,
    required this.description,
    required this.startDate,
    required this.endDate,
    this.promoCode,
    this.qrCode,
    required this.generatePromocode,
    required this.generateQrCode,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory PromoData.fromJson(Map<String, dynamic> json) {
    return PromoData(
      id: json['_id'] ?? '',
      user: json['user'] ?? '',
      title: json['title'] ?? '',
      discount: json['discount'] ?? 0,
      description: json['description'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      promoCode: json['promoCode'],
      qrCode: json['QRCode'],
      generatePromocode: json['generatePromocode'] ?? false,
      generateQrCode: json['generateQrCode'] ?? false,
      active: json['active'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      v: json['__v'] ?? 0,
    );
  }
}
