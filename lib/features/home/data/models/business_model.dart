import 'location_model.dart';
import 'cover_photo_model.dart';

class BusinessModel {
  final String id;
  final String name;
  final LocationModel location;
  final String address;
  final bool isApproved;
  final String createdAt;
  final String updatedAt;
  final CoverPhotoModel? coverPhoto;
  final String? crowdStatus;

  BusinessModel({
    required this.id,
    required this.name,
    required this.location,
    required this.address,
    required this.isApproved,
    required this.createdAt,
    required this.updatedAt,
    this.coverPhoto,
    this.crowdStatus,
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      location: LocationModel.fromJson(json['location'] ?? {}),
      address: json['address'] ?? '',
      isApproved: json['isApproved'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      coverPhoto:
          json['coverPhoto'] != null
              ? CoverPhotoModel.fromJson(json['coverPhoto'])
              : null,
      crowdStatus: json['crowdStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'location': location.toJson(),
      'address': address,
      'isApproved': isApproved,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'coverPhoto': coverPhoto?.toJson(),
      'crowdStatus': crowdStatus,
    };
  }
}
