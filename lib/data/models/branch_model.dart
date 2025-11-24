class BranchModel {
  final int? id;
  final String name;
  final String address;
  final int organizationId;

  BranchModel({
    this.id,
    required this.name,
    required this.address,
    required this.organizationId,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      organizationId: json['organization_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'address': address,
      'organization_id': organizationId,
    };
  }
}