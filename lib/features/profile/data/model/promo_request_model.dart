class PromoRequestModel {
  final String title;
  final int discount;
  final String description;
  final String startDate;
  final String endDate;
  final bool generatePromocode;
  final bool generateQrCode;

  PromoRequestModel({
    required this.title,
    required this.discount,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.generatePromocode,
    required this.generateQrCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'discount': discount,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'generatePromocode': generatePromocode,
      'generateQrCode': generateQrCode,
    };
  }
}
