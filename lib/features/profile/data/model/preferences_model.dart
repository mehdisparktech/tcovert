class PreferencesModel {
  final bool success;
  final String message;
  final Pagination pagination;
  final List<PhotoOfInterest> data;

  PreferencesModel({
    required this.success,
    required this.message,
    required this.pagination,
    required this.data,
  });

  factory PreferencesModel.fromJson(Map<dynamic, dynamic> json) {
    return PreferencesModel(
      success: json['success'],
      message: json['message'],
      pagination: Pagination.fromJson(json['pagination']),
      data: List<PhotoOfInterest>.from(
        json['data'].map((x) => PhotoOfInterest.fromJson(x)),
      ),
    );
  }
}

class Pagination {
  final int total;
  final int limit;
  final int page;
  final int totalPage;

  Pagination({
    required this.total,
    required this.limit,
    required this.page,
    required this.totalPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'],
      limit: json['limit'],
      page: json['page'],
      totalPage: json['totalPage'],
    );
  }
}

class PhotoOfInterest {
  final String id;
  final String name;
  bool active;
  final String createdAt;
  final String updatedAt;

  PhotoOfInterest({
    required this.id,
    required this.name,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PhotoOfInterest.fromJson(Map<String, dynamic> json) {
    return PhotoOfInterest(
      id: json['_id'],
      name: json['name'],
      active: json['active'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
