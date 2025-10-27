class CoverPhotoModel {
  final String imageUrl;
  final String uploadedBy;
  final String uploadedAt;

  CoverPhotoModel({
    required this.imageUrl,
    required this.uploadedBy,
    required this.uploadedAt,
  });

  factory CoverPhotoModel.fromJson(Map<String, dynamic> json) {
    return CoverPhotoModel(
      imageUrl: json['imageUrl'] ?? '',
      uploadedBy: json['uploadedBy'] ?? '',
      uploadedAt: json['uploadedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'uploadedBy': uploadedBy,
      'uploadedAt': uploadedAt,
    };
  }
}
