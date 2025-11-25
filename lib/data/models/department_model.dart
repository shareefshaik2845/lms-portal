class DepartmentModel {
  final int? id;
  final String name;
  final String code;
  final String description;
  final bool status;
  final String? createdAt;
  final String? updatedAt;

  DepartmentModel({
    this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: json['id'],
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] == true,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'code': code,
      'description': description,
      'status': status,
    };
  }
}
