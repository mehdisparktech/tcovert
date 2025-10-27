class BusinessDetailModel {
  final String id;
  final String name;
  final String address;
  final List<ImageModel> images;
  final OwnerModel owner;
  final DateTime createdAt;
  final DateTime updatedAt;
  final PromoCodeModel? promoCode;
  final bool isPromoActive;

  BusinessDetailModel({
    required this.id,
    required this.name,
    required this.address,
    required this.images,
    required this.owner,
    required this.createdAt,
    required this.updatedAt,
    this.promoCode,
    required this.isPromoActive,
  });

  factory BusinessDetailModel.fromJson(Map<String, dynamic> json) {
    return BusinessDetailModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      images:
          (json['images'] as List<dynamic>?)
              ?.map(
                (image) => ImageModel.fromJson(image as Map<String, dynamic>),
              )
              .toList() ??
          [],
      owner: OwnerModel.fromJson(json['owner'] as Map<String, dynamic>? ?? {}),
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      promoCode:
          json['promoCode'] != null
              ? PromoCodeModel.fromJson(
                json['promoCode'] as Map<String, dynamic>,
              )
              : null,
      isPromoActive: json['isPromoActive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'address': address,
      'images': images.map((image) => image.toJson()).toList(),
      'owner': owner.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'promoCode': promoCode?.toJson(),
      'isPromoActive': isPromoActive,
    };
  }
}

class ImageModel {
  final String imageUrl;
  final UploaderModel? uploadedBy;
  final DateTime uploadedAt;

  ImageModel({
    required this.imageUrl,
    this.uploadedBy,
    required this.uploadedAt,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      imageUrl: json['imageUrl'] ?? '',
      uploadedBy:
          json['uploadedBy'] != null
              ? UploaderModel.fromJson(
                json['uploadedBy'] as Map<String, dynamic>,
              )
              : null,
      uploadedAt: DateTime.parse(
        json['uploadedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'uploadedBy': uploadedBy?.toJson(),
      'uploadedAt': uploadedAt.toIso8601String(),
    };
  }
}

class UploaderModel {
  final String id;
  final String name;
  final String profileImage;

  UploaderModel({
    required this.id,
    required this.name,
    required this.profileImage,
  });

  factory UploaderModel.fromJson(Map<String, dynamic> json) {
    return UploaderModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profileImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'profileImage': profileImage};
  }
}

class OwnerModel {
  final String id;
  final String name;
  final String profileImage;
  final String email;

  OwnerModel({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.email,
  });

  factory OwnerModel.fromJson(Map<String, dynamic> json) {
    return OwnerModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profileImage'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'profileImage': profileImage,
      'email': email,
    };
  }
}

class PromoCodeModel {
  final String id;
  final String title;
  final int discount;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String promoCode;
  final String qrCode;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;

  PromoCodeModel({
    required this.id,
    required this.title,
    required this.discount,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.promoCode,
    required this.qrCode,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PromoCodeModel.fromJson(Map<String, dynamic> json) {
    return PromoCodeModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      discount: json['discount'] ?? 0,
      description: json['description'] ?? '',
      startDate: DateTime.parse(
        json['startDate'] ?? DateTime.now().toIso8601String(),
      ),
      endDate: DateTime.parse(
        json['endDate'] ?? DateTime.now().toIso8601String(),
      ),
      promoCode: json['promoCode'] ?? '',
      qrCode: json['QRCode'] ?? '',
      active: json['active'] ?? false,
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'discount': discount,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'promoCode': promoCode,
      'QRCode': qrCode,
      'active': active,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
