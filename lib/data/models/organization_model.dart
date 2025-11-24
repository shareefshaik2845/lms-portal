class OrganizationModel {
  final int? id;
  final String name;
  final String description;
  final String? createdAt;
  final String? updatedAt;

  OrganizationModel({
    this.id,
    required this.name,
    required this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory OrganizationModel.fromJson(Map<String, dynamic> json) {
    return OrganizationModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
    };
  }
}