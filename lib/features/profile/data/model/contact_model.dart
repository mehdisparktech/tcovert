class ContactModel {
  final bool success;
  final String message;
  final Data data;

  ContactModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      success: json['success'],
      message: json['message'],
      data: Data.fromJson(json['data']),
    );
  }
}

class Data {
  final String name;
  final String email;
  final String subject;
  final String message;
  final bool resolved;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  Data({
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
    required this.resolved,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      name: json['name'],
      email: json['email'],
      subject: json['subject'],
      message: json['message'],
      resolved: json['resolved'],
      id: json['_id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'],
    );
  }
}
